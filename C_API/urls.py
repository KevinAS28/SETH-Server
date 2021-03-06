from django.urls import path, re_path
from .views import *


app_name = 'c_api'

urlpatterns = [
    path('get_user', test),
    path('find_place', find_place),
    path('find_places_model', find_places_model),
    path('get_transit', get_transit),
    path('get_place_by_id', get_place_by_id),
    path('place_input', place_input),
    path('get_certificates', get_certificates),
    path('cert_bplaces', cert_aplaces),
    path('find_aplaces', find_aplaces),
    path('history_a', history_a),
    path('register', register),
    path('find_place_core', find_place_core),
    path('delete_cert', delete_cert),
    path('edit_profile', edit_profile),
    path('get_profile', get_profile)

]