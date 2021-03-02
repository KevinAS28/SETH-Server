from django.urls import path
from . import views

from .views import HomePageView, SearchResultsView

urlpatterns = [
    path('', HomePageView.as_view(), name='home'),
    path('history',views.history_view),
    path('results', SearchResultsView.as_view(),name='results'),
    path('profile',views.profile_view),
    path('registration',views.registration),
]