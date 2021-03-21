from django.urls import path, re_path
from .views import *


app_name = 'c_api'

urlpatterns = [
    path('get_user', test),
    path('find_place', find_place),
    path('get_transit', get_transit),
    path('get_place_by_id', get_place_by_id),

]