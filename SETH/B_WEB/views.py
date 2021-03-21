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
import traceback

user_id_received = []
cert_not_supported = []
failed_msg = []

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
    return render(request, 'registration.html', {'bplace_name': settings.B_PLACE_NAME})

@login_required
@buser_required
def history(request):
    if request.method=="GET":
        passed = (History.objects.filter(b_place__name__contains=settings.B_PLACE_NAME, )) 
        return render(request, 'front2/history.html', {"history": passed.order_by("-datetime"), 'bplace_name': settings.B_PLACE_NAME})
    elif request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        passed = list(History.objects.filter(b_place__name__contains=settings.B_PLACE_NAME, cuser__name__contains=name_nik)) 

        return render(request, 'front2/history.html', {"history": passed, 'bplace_name': settings.B_PLACE_NAME})
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
        return render(request, "front2/find_user_c.html", {"users": data, 'bplace_name': settings.B_PLACE_NAME})
    elif request.method=="GET":
        return render(request, "front2/find_user_c.html", {'bplace_name': settings.B_PLACE_NAME})
    else:
        print("invalid method")

def auth_face_result(request):
    global failed_msg
    if request.method == 'GET':
        params = json.loads(request.GET['params'])
        if not 'result_msg' in params:
            params['result_msg'] = 'Face Authentication SUCCESS'

        request.session = dict_to_session(json.loads(params['session']))

        name = 'Unknown'

        try:
            b_place = list(BPlace.objects.filter(name=settings.B_PLACE_NAME))[0]
            cuser = list(CUser.objects.filter(nik=params['user_id']))[0]
            name = cuser.name
            History(cuser=cuser, passed=True, b_place=b_place).save()
            print('History saved')
        except:
            # params['result_msg'] = failed_msg[0]
            pass

        
        return render(request, 'front2/face_success.html', {'user_id': params['user_id'], 'name': name, 'result_msg': params['result_msg'], 'bplace_name': settings.B_PLACE_NAME})
    else:
        return HttpResponseNotAllowed('Invalid method')

def receive_qr(request):
    global user_id_received, cert_not_supported, failed_msg
    if request.method == 'POST':
        data = json.loads(request.body)
        user_id = data['user_id']

    
        try:
            cuser = list(CUser.objects.filter(nik=user_id))[0]
            certs = Certificate.objects.filter(cuser=cuser)
            b_place = BPlace.objects.filter(name=settings.B_PLACE_NAME)
            for c_cert in certs:
                for b in b_place:
                    cmp = b.supported_certs == c_cert.cert_type
                    print(f'{b.supported_certs} == {c_cert.cert_type}: {cmp}')
                    if cmp:
                        user_id_received.append(user_id)
                        return HttpResponse()

        except Exception as e:
            print(traceback.format_exc())
            print('User not registered yet')
            cert_not_supported.append(user_id)
            failed_msg.append('User not registered yet')
            return HttpResponse('No cert supported')


        
        print('No cert supported')
        cert_not_supported.append(user_id)
        failed_msg.append('No cert supported')
        return HttpResponse('No cert supported')

    elif request.method == 'GET':
        data = face_auth_data(request, request.GET['user_id'])
        return redirect(data['redirect_url'])
    else:
        return HttpResponseNotAllowed('Invalid method')

def check_qr(request):
    global user_id_received, cert_not_supported, failed_msg
    if request.method == 'POST':
        if len(user_id_received) > 0:
            user_id = user_id_received[0]
            del user_id_received[0]

            cuser = list(CUser.objects.filter(nik=user_id))[0]
            if not cuser.face_data:
                params = {'session': json.dumps(session_to_dict(request.session)), 'user_id': user_id, 'result_msg': 'Face not Registered Yet'}
                return JsonResponse({'redirect': True, 'redirect_url': f'/b_web/auth_face_result?params={quote(json.dumps(params))}'})


            data = face_auth_data(request, user_id)
            print(data)

            return JsonResponse(data)
        elif len(cert_not_supported) > 0:
            user_id = cert_not_supported[0]
            params = {'session': json.dumps(session_to_dict(request.session)), 'user_id': user_id, 'result_msg': failed_msg[0]}
            del cert_not_supported[0]
            del failed_msg[0]
            return JsonResponse({'redirect': True, 'redirect_url': f'/b_web/auth_face_result?params={quote(json.dumps(params))}'})            
            
        else:
            return JsonResponse({'redirect': False})
    else:
        return HttpResponseNotAllowed('Invalid method')


def qr_page(request):
    return render(request, 'front2/show_qr.html', {'bplace_name': settings.B_PLACE_NAME})