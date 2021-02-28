from django.urls import path, re_path
from .views import *
from django.views.generic.base import TemplateView 
from django.conf import settings
from django.conf.urls.static import static

app_name = 'web'

urlpatterns = [

    # re_path(r'^file/(?P<file>.+)/$', test_frontend, name="test_frontend"),
    path('file/', test_frontend, name="test_frontend"),
    
] 


urlpatterns = [

]
