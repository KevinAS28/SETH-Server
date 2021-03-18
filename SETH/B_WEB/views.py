from django.shortcuts import render, redirect
from django.views.generic import TemplateView, ListView
from django.db.models import Q
from django.contrib.auth.decorators import user_passes_test, login_required
from django.contrib.auth.decorators import REDIRECT_FIELD_NAME
from django.conf import settings
from django.urls import reverse

from SETH.models import *

import os
import configparser
import json
from urllib.parse import quote, unquote

def session_to_dict(session):
    to_return = dict()
    keys = session.keys()#dir(session)
    for k in keys:
        try:
            to_return[k] = session[k]
        except:
            print('Error 1:', k)
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

@login_required
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

# def auth_result(request)

@login_required
@buser_required
def auth_face(request, data=dict()):
    config = configparser.ConfigParser()
    config.read(os.path.join(settings.BASE_DIR, 'face_core.ini'))       
    redirect_url = config['face_core']['auth_face_page_url']
    data['success_url'] = 'http://127.0.0.1:8000'+reverse('b_web:process_c_registration')#'http://127.0.0.1:8000'+reverse('a_web:regist_c_notregistered')
    data['send_data_only_url'] = 'http://127.0.0.1:8000'+reverse('a_web:process_c_registration')
    # data['send_data_only_url']
    data['session'] = json.dumps(session_to_dict(request.session))
    print(data)
    data_quoted = quote(json.dumps(data))
    redirect_url = f'{redirect_url}?params={data_quoted}'
    print('redirect_url:', '|'+redirect_url+'|')
    # return render(request, 'new_window.html', {'url': f'{redirect_url}?params={data_quoted}'})
    return redirect(redirect_url)

    
@login_required
@buser_required
def qr_page(request):
    return render(request, 'front2/faceRecog.html')