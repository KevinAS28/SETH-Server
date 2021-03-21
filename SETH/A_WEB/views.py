# Create your views here.


from django.contrib.auth.models import User
from SETH.models import *
import os


from django.http.response import HttpResponseBadRequest, JsonResponse

from django.contrib.auth.decorators import user_passes_test, login_required as django_login
from django.shortcuts import render, redirect
from django.contrib import messages 
from django.db.models import Q
from datetime import date
from django.conf import settings
from django.urls import reverse
from django.contrib.auth.decorators import REDIRECT_FIELD_NAME
from django.contrib.sessions.backends.db import SessionStore
from django.views.decorators.csrf import csrf_exempt
from django.db.utils import IntegrityError


import configparser
import json
from urllib.parse import quote, unquote
# from facial_simple import Add as face_add

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

def test_frontend(request, file):
    return render(request, os.path.join("front1", file+".html"))

def auser_required(function=None, redirect_field_name=REDIRECT_FIELD_NAME, login_url='/a_web/login'):
    '''
    Decorator for views that checks that the logged in user is a student,
    redirects to the log-in page if necessary.
    '''
    actual_decorator = user_passes_test(
        lambda u: u.is_active and u.usertype==UserAuthentication.A_TYPE,
        login_url=login_url,
        redirect_field_name=redirect_field_name
    )
    if function:
        return actual_decorator(
            function,
        )
    return actual_decorator

def login_required(function=None, redirect_field_name=REDIRECT_FIELD_NAME, login_url="/a_web/login"):
    return django_login(function, redirect_field_name, login_url)


def process_c_registration(request):
    if request.method == 'GET':
        print('GET process_c_registration')
        print(request.GET)

        request.session = dict_to_session(json.loads(json.loads(request.GET['params'])['session']))
        request.session['params'] = request.GET['params']
        # params = json.loads(request.GET['params'])

        if not ('register_score' in request.session):
            request.session['register_score'] = 1
        else:
            request.session['register_score'] += 1

        return render(request, 'redirect.html', {'url': reverse('a_web:regist_c_notregistered')})

    elif request.method == 'POST':
        print('POST process_c_registration')
        face_data = json.loads(request.POST['person_face_data'])
        # print('FACE_DATA:', face_data)

        face_file_name = os.path.join(settings.BASE_DIR, 'face_data')
        if not os.path.isdir(face_file_name):
            os.makedirs(face_file_name)
        face_file_name = os.path.join(face_file_name, request.POST['user_id'])
        if not os.path.isfile(face_file_name):
            open(face_file_name, 'w+').close()
        

        print('face_file_name:', face_file_name)
        with open(face_file_name, 'r+') as face_file:
            face_file_content = face_file.read()
            try:
                json.loads(face_file_content)
            except:
                face_file_content = '{"face_list": []}'

        with open(face_file_name, 'w+') as face_file:
            to_write = json.loads(face_file_content)
            if not ('face_list' in to_write):
                print('new face list')
                to_write['face_list'] = [face_data]
            else:
                if not (type(to_write['face_list']) == list):
                    print('new face list 2')
                    to_write['face_list'] = [face_data]                    
                else:
                    print('append face')
                    to_write['face_list'] = to_write['face_list'] + [face_data]
            # to_write = {'face_list': [face_data]}
            # print('to_write:', to_write)
            face_file.write(json.dumps(to_write, indent=4, sort_keys=True))

        # return render(request, 'redirect.html', {'url': reverse('a_web:regist_c_notregistered')})
        return JsonResponse({'success': True})
    else:   
        return HttpResponseBadRequest('Invalid method')

        
def register_face(request, data=dict()):
    config = configparser.ConfigParser()
    config.read(os.path.join(settings.BASE_DIR, 'face_core.ini'))       
    redirect_url = config['face_core']['add_face_page_url']
    data['success_url'] = 'http://127.0.0.1:8000'+reverse('a_web:process_c_registration')#'http://127.0.0.1:8000'+reverse('a_web:regist_c_notregistered')
    data['send_data_only_url'] = 'http://127.0.0.1:8000'+reverse('a_web:process_c_registration')
    # data['send_data_only_url']
    data['session'] = json.dumps(session_to_dict(request.session))
    data['user_id'] = data['nik']

    print(data)
    data_quoted = quote(json.dumps(data))
    redirect_url = f'{redirect_url}?params={data_quoted}'
    print('redirect_url:', '|'+redirect_url+'|')


    # return render(request, 'new_window.html', {'url': f'{redirect_url}?params={data_quoted}'})
    return redirect(redirect_url)

@login_required
@auser_required
def find_user_c_any(request):
    if request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        data = list(CUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        print(data)
        return render(request, "front1/find_user_c_any.html", {"users": data})
    elif request.method=="GET":
        return render(request, "front1/find_user_c_any.html")
    else:
        print("invalid method")

@login_required
@auser_required
@csrf_exempt
def register_c(request):
    if (request.method=='POST'):
        if ('find_user_c' in request.POST):
            return redirect('a_web:find_user_c_any')

        #if (request.POST.is_valid()):
        form = request.POST

        to_get = "nik email name phone bday address city country postalcode".split()
        data = dict()
        for col in to_get:
            data[col] = form.get(col)
        
        if 'finish' in form:
            print(f'Saving data {data["name"]}...')
            cuser = CUser(**data, face_data=True)
            cuser.save()
            print('Saved')

            try:
                UserAuthentication(username=data['nik'], password=data['phone'], usertype=UserAuthentication.C_TYPE, cuser=cuser).save()
            except IntegrityError:
                print(f'Username {data["nik"]} already exist, skipping')


        action_list = ['face_recog']#['fingerprint', 'face_recog', 'idcard']

        actions = {
            'face_recog': register_face
        }

        for al in action_list:
            if not (form.get(al) is None):
                print('Action:', al)
                return actions[al](request, data)
        

        to_get = "nik email name phone bday address city country postalcode".split()
        params = json.loads(request.session['params'])
        for col in to_get:
            try:
                del params[col]
            except:
                print(f'delete {col}')
        messages.success(request, f' Data {data["name"]} sucessfully registered !!') 
        request.session['params'] = json.dumps(params)
        request.session['register_score'] = 0
        return render(request, 'redirect.html', {'url': 'http://127.0.0.1:8000/a_web/not_registered'})        
        

    elif request.method=='GET':
        print("GET register_c")

        minimum_user_registration_score = 1
        able_to_complete = False
        if not ('register_score' in request.session):
            request.session['register_score'] = 0
        else:
            if int(request.session['register_score']) >= minimum_user_registration_score:
                able_to_complete = True 
        print('score:', request.session['register_score'])
        
        data_return = {"data": [], 'able_to_complete': able_to_complete}

        
        if 'params' in list(request.session.keys()):
            print('auto fill')
            params = json.loads(request.session['params'])
            if 'nik' in list(params.keys()):
                to_get = "nik email name phone bday address city country postalcode".split()
                for col in to_get:
                    data_return[col] = params[col]
        if 'nik' in request.GET:
            print('auto fill GET')
            cuser = list(CUser.objects.filter(nik=request.GET['nik']))[0].__dict__
            to_get = "nik email name phone bday address city country postalcode".split()
            for col in to_get:
                data_return[col] = cuser[col]
            


        else:
            print('not auto fill')
            print(list(request.session.keys()))
        print('data_return:', data_return)

        return render(request, "front1/user.html", data_return)
    else:
        print("invalid method")


@login_required
@auser_required
def find_user_c_cert(request):
    cert = request.GET["cert"]
    if request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        data = list(CUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        print(data)
        return render(request, "front1/find_user_c.html", {"users": data, "cert": cert})
    elif request.method=="GET":
        return render(request, "front1/find_user_c.html")
    else:
        print("invalid method")

@login_required
@auser_required
def make_cert(request):
    cert = request.GET["cert"]
    nik = request.GET["nik"]
    a_place = APlace.objects.filter(name=settings.A_PLACE_NAME)[0]
    if request.method=="POST":
        user = list(CUser.objects.filter(nik=nik))
        if len(user)==0:
            print(f"No user with NIK: {nik}")
            return None
        the_user = user[0]
        Certificate(cuser=the_user, cert_type=cert, note=request.POST.get("note"), date=date.today(), a_place=a_place).save()
        # return render(request, "front1/template_cert1.html", )
        messages.success(request, f' Data {the_user.nik} sucessfully registered !!') 
        return redirect("a_web:makecert")
    elif request.method=="GET":
        user = list(CUser.objects.filter(nik=nik))[0]
        return render(request, "front1/template_cert1.html", {"user": user})
    else:
        print("invalid method")


@login_required
@auser_required
def dashboard(request):
    print('Authenticated:', request.user.is_authenticated)
    if request.method=="GET":
        # XMLSerializer = serializers.get_serializer("xml")
        # xml_serializer = XMLSerializer()
        # print('1:', xml_serializer.serialize(request.session))
        # data = xml_serializer.getvalue()
        # print(data)
        # print(dir(request.session))
        request.session = dict_to_session(session_to_dict(request.session))
        # print(dict(request.session))
        return render(request, 'front1/dashboard.html', {"today": list(Certificate.objects.filter(date=date.today())), 'len_all': len(list(Certificate.objects.all()))},  )
    else:
        print("Invalid method")

@login_required
@auser_required
def history(request):
    if request.method=="GET":
        return render(request, 'front1/tables.html', {"history": list(Certificate.objects.all().order_by("-date"))})
    elif request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        users = list(CUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        certs = []
        for u in users:
            certs += (list(Certificate.objects.filter(cuser=u)))

        return render(request, 'front1/tables.html', {"history": certs})
    else:
        print("Invalid method")


