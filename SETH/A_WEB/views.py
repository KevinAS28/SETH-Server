# Create your views here.

from SETH.models import *
import os


from django.contrib.auth.decorators import user_passes_test, login_required as django_login
from django.shortcuts import render, redirect
from django.contrib import messages 
from django.db.models import Q
from datetime import date
from django.conf import settings
from django.contrib.auth.decorators import REDIRECT_FIELD_NAME
# from facial_simple import Add as face_add

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


@login_required
@auser_required
def register_c(request):
    if (request.method=='POST'):
        #if (request.POST.is_valid()):
        form = request.POST

        to_get = "nik email name phone bday address city country postalcode".split()
        data = dict()
        for col in to_get:
            data[col] = form.get(col)
            
        CUser(**data).save()
        messages.success(request, f' Data {data["name"]} sucessfully registered !!') 
        return redirect("a_web:cuser")

    elif request.method=='GET':
        print("GET register_c")
        return render(request, "front1/user.html", {"data": []})
    else:
        print("invalid method")

@login_required
@auser_required
def register_face(request):
    if request.method=="GET":
        pass
    else:
        print("Invalid method")

@login_required
@auser_required
def find_user_c(request):
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
    print(request.user.is_authenticated)
    if request.method=="GET":
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