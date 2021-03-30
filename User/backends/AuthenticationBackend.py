from django.conf import settings
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User
from SETH.models import *


class AuthenticationBackend:
    def authenticate(self, request, username=None, password=None):
        user = UserAuthentication.objects.filter(username=username, password=password)
        if user.exists():
            print("Login success")
            return user[0]            
        else:
            print("Not exist")
            return None

    def get_user(self, username):
        try:
            print(f'Get user {username} success')
            return UserAuthentication.objects.get(pk=username)
        except UserAuthentication.DoesNotExist:
            print(f'Not found user {username}')
            return None