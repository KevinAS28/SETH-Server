from django.urls import path, re_path
from .views import *
from django.views.generic.base import TemplateView 
from django.contrib.auth import views as auth 
from User.views import *


app_name = 'a_web'

urlpatterns = [
    path('dashboard/', dashboard, name='dashboard'), 
    path('history/', history, name='history'), 
    path('makecert/', TemplateView.as_view(template_name='front1/makecert.html'), name='makecert'), 
    re_path('find_user_c', find_user_c, name='find_user_c'), 
    re_path('makecertun/', make_cert, name='makecertun'),
    path('cuser/', register_c, name='cuser'), # new
    path('registered', register_c, name='regist_c_registered'), 
    path('not_registered', register_c, name='regist_c_notregistered'), 
    path('register_face', register_face, name="register_face"),
    path('login/', common_user_login, name="login"),
    path('logout/', auth.LogoutView.as_view(template_name ='index.html'), name ='logout'), 
    path('process_c_registration/', process_c_registration, name ='process_c_registration'), 
    re_path(r'^file/(?P<file>.+)/$', test_frontend, name="test_frontend"),
    
] 

# + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

