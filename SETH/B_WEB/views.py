from django.shortcuts import render
from django.views.generic import TemplateView, ListView
from django.db.models import Q
from A_WEB.models import *

class HomePageView(TemplateView):
    template_name = 'home.html'

def registration(request):
    return render(request, 'registration.html')

def history(request):
    if request.method=="GET":
        return render(request, 'front2/searchCert.html', {"history": list(Certificate.objects.all().order_by("-date"))})
    elif request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        users = list(CommonUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        certs = []
        for u in users:
            certs += (list(Certificate.objects.filter(cuser=u)))

        return render(request, 'front2/searchCert.html', {"history": certs})
    else:
        print("Invalid method")
#
# def face(request):
#     if request.m
