from django.urls import path
from .views import *
from django.views.generic.base import TemplateView 

app_name = 'a_web'

urlpatterns = [
    path('', TemplateView.as_view(template_name='home.html'), name='home'), 
    path('signup/', SignUpView.as_view(), name='signup'),
    path('cert', TemplateView.as_view(template_name='cert.html'), name='cert'), 
    path('regist_c/', TemplateView.as_view(template_name='regist_c.html'), name='regist_c'), # new
    path('registered', register_c, name='regist_c_registered'), 
    path('not_registered', TemplateView.as_view(template_name='c_regist/not_registered.html'), name='regist_c_notregistered'), 
    path('register_face', register_face, name="register_face"),
    
    
]