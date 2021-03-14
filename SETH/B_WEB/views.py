from django.shortcuts import render
from django.views.generic import TemplateView, ListView
from django.db.models import Q
from SETH.models import *
from django.contrib.auth.decorators import user_passes_test, login_required
from django.contrib.auth.decorators import REDIRECT_FIELD_NAME

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


