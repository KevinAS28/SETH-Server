from django.urls import path
from . import views
# from face_core import views as face_view
from django.shortcuts import render
from User import views as UserViews
import B_WEB.qr_views as qr_views

app_name = "b_web"

urlpatterns = [
    path('', views.qr_page),
    path('login', UserViews.buser_login, name='buser_login'),
    path('logout/', UserViews.buser_logout, name ='buser_logout'), 
    path('history', views.history, name='history'),
    path('face_recog', lambda r: render(r, "front2/dashboard.html")),
    path('find_user_c', views.find_user_c, name='find_user_c'),
    path('auth_face_result', views.auth_face_result, name='auth_face_result'),
    path('qr_page', views.qr_page, name='qr_page'),
    path('check_qr', views.check_qr, name='check_qr'),
    path('receive_qr', views.receive_qr, name='receive_qr'),
    path('fingerprint', views.fingerprint, name='fingerprint'),
    path('check_fingerprint', views.check_fingerprint, name='check_fingerprint'),
    path('fingerprint_result', views.fingerprint_result, name='fingerprint_result'),
    path('receive_finger', views.receive_fingerprint, name='receive_finger'),
    path('qr_src', qr_views.serve_qr_code_image, name='qr_src'),
]