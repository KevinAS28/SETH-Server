from django.urls import path
from . import views
# from face_core import views as face_view
from django.shortcuts import render
from User.views import *

app_name = "b_web"

urlpatterns = [
    path('', views.history),
    path('login', common_user_login, name='buser_login'),
    path('history', views.history),
    path('face_add', lambda r: render(r, "front2/dashboard.html")),
]