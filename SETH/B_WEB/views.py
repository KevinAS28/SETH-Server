from django.http.response import HttpResponse, HttpResponseNotAllowed, JsonResponse
from django.shortcuts import render, redirect
from django.db.models import Q
from django.contrib.auth.decorators import user_passes_test, login_required as django_login
from django.contrib.auth.decorators import REDIRECT_FIELD_NAME
from django.conf import settings
from django.urls import reverse
from django.contrib.sessions.backends.db import SessionStore

from SETH.models import *

import os
import configparser
import json
from urllib.parse import quote, unquote

user_id_received = []

def login_required(function=None, redirect_field_name=REDIRECT_FIELD_NAME, login_url="/b_web/login"):
    return django_login(function, redirect_field_name, login_url)


def session_to_dict(session):
    to_return = dict()
    keys = session.keys()#dir(session)
    for k in keys:
        try:
            to_return[k] = session[k]
        except:
            print('Error 1:', k)
    return to_return

def dict_to_session(dictionary):
    to_return = SessionStore()
    keys = list(dictionary.keys())
    for k in keys:
        try:
            to_return[k] = dictionary[k]
        except:
            print('Error 2:', k)
    return to_return

def buser_required(function=None, redirect_field_name=REDIRECT_FIELD_NAME, login_url='/b_web/login'):
    '''
    Decorator for views that checks that the logged in user is a student,
    redirects to the log-in page if necessary.
    '''
    actual_decorator = user_passes_test(
        lambda u: u.is_active and u.usertype==UserAuthentication.B_TYPE,
        login_url=login_url,
        redirect_field_name=redirect_field_name
    )
    if function:
        return actual_decorator(
            function,
        )
    return actual_decorator

# @login_required
@buser_required
def registration(request):
    return render(request, 'registration.html')

@login_required
@buser_required
def history(request):
    if request.method=="GET":
        return render(request, 'front2/searchCert.html', {"history": list(Certificate.objects.all().order_by("-date"))})
    elif request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        users = list(CUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        certs = []
        for u in users:
            certs += (list(Certificate.objects.filter(cuser=u)))

        return render(request, 'front2/searchCert.html', {"history": certs})
    else:
        print("Invalid method")

def face_auth_data(request, user_id):
    data = {'redirect': True}
    config = configparser.ConfigParser()
    config.read(os.path.join(settings.BASE_DIR, 'face_core.ini'))       
    redirect_url = config['face_core']['auth_face_page_url']
    data['user_id'] = user_id
    data['success_url'] = 'http://127.0.0.1:8000'+reverse('b_web:auth_face_result')#'http://127.0.0.1:8000'+reverse('a_web:regist_c_notregistered')
    data['session'] = json.dumps(session_to_dict(request.session))
    data['redirect_url'] = f'{redirect_url}?params={quote(json.dumps(data))}'
    return data

@login_required
@buser_required
def find_user_c(request):
    if request.method=="POST":
        
        form = request.POST
        name_nik = form.get("name_nik")
        data = list(CUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        print(data)
        return render(request, "front2/find_user_c.html", {"users": data})
    elif request.method=="GET":
        return render(request, "front2/find_user_c.html")
    else:
        print("invalid method")


def receive_qr(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        user_id_received.append(data['user_id'])
        return HttpResponse()
    elif request.method == 'GET':
        data = face_auth_data(request, request.GET['user_id'])
        return redirect(data['redirect_url'])
    else:
        return HttpResponseNotAllowed('Invalid method')

def auth_face_result(request):
    if request.method == 'GET':
        params = json.loads(request.GET['params'])
        request.session = dict_to_session(json.loads(params['session']))
        cuser = list(CUser.objects.filter(nik=params['user_id']))[0]
        return render(request, 'front2/face_success.html', {'user_id': params['user_id'], 'name': cuser.name})
    else:
        return HttpResponseNotAllowed('Invalid method')


def check_qr(request):
    global user_id_received
    if request.method == 'POST':
        if len(user_id_received) > 0:
            user_id = user_id_received[0]

            data = face_auth_data(request, user_id)
            print(data)
            del user_id_received[0]
            return JsonResponse(data)
        else:
            return JsonResponse({'redirect': False})
    else:
        return HttpResponseNotAllowed('Invalid method')


def qr_page(request):
    return render(request, 'front2/show_qr.html')