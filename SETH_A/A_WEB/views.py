# Create your views here.

import os

from django.contrib.auth.forms import UserCreationForm
from django.urls import reverse_lazy
from django.views import generic
from django.contrib.auth.decorators import login_required as django_login
from .models import *
from django.shortcuts import render, redirect
from django.contrib import messages 
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
        #     users = list(UserC.objects.filter(nik=form.get("name_nik")))
        # elif form.get("by_name")!=None:
        #     users = list(UserC.objects.filter(name__icontains=form.get("name_nik")))
        # print("result: ", users)

        UserC(**data).save()
        messages.success(request, f' Data {data["name"]} sucessfully registered !!') 
        return redirect("a_web:userc")
        # else:
        #     print("not a valid form")
        #     return render(request, "")
    elif request.method=='GET':
        return render(request, "front1/user.html", {"data": []})
    else:
        print("invalid method")

def register_face(request):
    if request.method=="GET":
        pass
    else:
        print("Invalid method")
    


class SignUpView(generic.CreateView):
    form_class = UserCreationForm
    success_url = reverse_lazy('login')
    template_name = 'registration/signup.html'
