"""SETH URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.contrib.auth.models import User
from django.urls import path, include
from django.urls.conf import re_path
from django.conf import settings
from .views import *
from User import views as UserViews
from django.views.generic.base import TemplateView 
from django.shortcuts import redirect

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('django.contrib.auth.urls')),
    path('', lambda r:  redirect('a_web:dashboard'), name='home'), # new
    path('a_web/', include('A_WEB.urls')),
    path('b_web/', include('B_WEB.urls')),
    path('c_api/', include('C_API.urls')),
    
    path('authenticate', UserViews.common_user_login, name='authenticate'),
    path('qr_code/', include('qr_code.urls', namespace="qr_code")),
    re_path(r'^staticfiles/(?P<path>.+)/$', static_serve, name="test_frontend"),


    # path('face_core/', include('face_core.urls')),

    # path("user/", include('User.urls', namespace='user') ),
    # path('logout/', auth.LogoutView.as_view(template_name ='index.html'), name ='logout'), 


]  