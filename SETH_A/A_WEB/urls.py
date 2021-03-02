from django.urls import path, re_path
from .views import *
from django.views.generic.base import TemplateView 
from django.conf import settings




app_name = 'a_web'

urlpatterns = [
    path('dashboard/', TemplateView.as_view(template_name='front1/dashboard.html'), name='dashboard'), 
    path('makecert/', TemplateView.as_view(template_name='front1/makecert.html'), name='makecert'), 
    re_path('find_user_c', find_user_c, name='find_user_c'), 
    re_path('makecertun/', make_cert, name='makecertun'),
    path('userc/', register_c, name='userc'), # new
    path('registered', register_c, name='regist_c_registered'), 
    path('not_registered', register_c, name='regist_c_notregistered'), 
    path('register_face', register_face, name="register_face"),

    re_path(r'^file/(?P<file>.+)/$', test_frontend, name="test_frontend"),
    
] 

# + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

