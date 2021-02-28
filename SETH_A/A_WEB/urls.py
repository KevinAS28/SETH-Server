from django.urls import path, re_path
from .views import *
from django.views.generic.base import TemplateView 
from django.conf import settings
from django.conf.urls.static import static



app_name = 'a_web'

urlpatterns = [
    path('dashboard/', TemplateView.as_view(template_name='front1/dashboard.html'), name='home'), 
    path('makecert/', TemplateView.as_view(template_name='front1/makecert.html'), name='makecert'), 
    path('regpcr/', TemplateView.as_view(template_name='front1/regPCR.html'), name='regpcr'), 
    path('userc/', register_c, name='userc'), # new
    path('registered', register_c, name='regist_c_registered'), 
    path('not_registered', TemplateView.as_view(template_name='c_regist/not_registered.html'), name='regist_c_notregistered'), 
    path('register_face', register_face, name="register_face"),

    re_path(r'^file/(?P<file>.+)/$', test_frontend, name="test_frontend"),
    
] 

# + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

