from django.urls import path
from . import views
# from face_core import views as face_view
from django.shortcuts import render

app_name = "b_web"

urlpatterns = [
    # path('', views.HomePageView.as_view(), name='home'),
    # path('History',views.history_view),
    # path('results', views.SearchResultsView.as_view(),name='results'),
    # path('profile',views.profile_view),
    # path('registration',views.registration),
    path('history', views.history),
    path('face_add', lambda r: render(r, "front2/dashboard.html")),
    # path('face_add_src', face_view.add_face_src, name="b_face_add")
]