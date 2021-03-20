from django.urls import path, re_path
from .views import *
from django.views.generic.base import TemplateView 
from django.contrib.auth import views as auth 
from User.views import *


app_name = 'a_web'

urlpatterns = [
    path('', dashboard, name='dashboard'), 
    path('dashboard/', dashboard, name='dashboard'), 
    path('history/', history, name='history'), 
    path('makecert/', TemplateView.as_view(template_name='front1/makecert.html'), name='makecert'), 
    path('find_user_c', find_user_c_cert, name='find_user_c'), 
    path('find_user_c_any', find_user_c_any, name='find_user_c_any'), 
    path('makecertun/', make_cert, name='makecertun'),
    path('cuser/', register_c, name='cuser'), # new
    # path('registered', register_c, name='regist_c_registered'), 
    path('not_registered', register_c, name='regist_c_notregistered'), 
    path('register_face', register_face, name="register_face"),
    path('login/', auser_login, name="login"),
    path('logout/', auser_logout, name ='auser_logout'), 
    path('process_c_registration/', process_c_registration, name ='process_c_registration'), 
    re_path(r'^file/(?P<file>.+)/$', test_frontend, name="test_frontend"),
    
] 

# + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

