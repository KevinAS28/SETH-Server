# Create your views here.

import os


from django.contrib.auth.decorators import login_required as django_login
from .models import *
from User.models import *
from django.shortcuts import render, redirect
from django.contrib import messages 
from django.db.models import Q
from datetime import date
# from facial_simple import Add as face_add

def test_frontend(request, file):
    return render(request, os.path.join("front1", file+".html"))

def register_c(request):
    if (request.method=='POST'):
        #if (request.POST.is_valid()):
        form = request.POST

        to_get = "nik email name phone bday address city country postalcode".split()
        data = dict()
        for col in to_get:
            data[col] = form.get(col)

        # print("name: ", form.get("name_nik"))
        # print("by_nik: ", form.get("by_nik"))
        # print("by_name: ", form.get("by_name"))

        # users = []
        # if form.get("by_nik")!=None:
        #     users = list(CUser.objects.filter(nik=form.get("name_nik")))
        # elif form.get("by_name")!=None:
        #     users = list(CUser.objects.filter(name__icontains=form.get("name_nik")))
        # print("result: ", users)

        CUser(**data).save()
        messages.success(request, f' Data {data["name"]} sucessfully registered !!') 
        return redirect("a_web:cuser")
        # else:
        #     print("not a valid form")
        #     return render(request, "")
    elif request.method=='GET':
        print("GET register_c")
        return render(request, "front1/user.html", {"data": []})
    else:
        print("invalid method")

def register_face(request):
    if request.method=="GET":
        pass
    else:
        print("Invalid method")


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

def make_cert(request):
    cert = request.GET["cert"]
    nik = request.GET["nik"]
    if request.method=="POST":
        user = list(CUser.objects.filter(nik=nik))
        if len(user)==0:
            print(f"No user with NIK: {nik}")
            return None
        the_user = user[0]
        Certificate(cuser=the_user, cert_type=cert, note=request.POST.get("note"), date=date.today()).save()
        # return render(request, "front1/template_cert1.html", )
        messages.success(request, f' Data {the_user.nik} sucessfully registered !!') 
        return redirect("a_web:makecert")
    elif request.method=="GET":
        user = list(CUser.objects.filter(nik=nik))[0]
        return render(request, "front1/template_cert1.html", {"user": user})
    else:
        print("invalid method")
    

def dashboard(request):
    if request.method=="GET":
        return render(request, 'front1/dashboard.html', {"today": list(Certificate.objects.filter(date=date.today()))})
    else:
        print("Invalid method")

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