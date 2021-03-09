from django.conf import settings
from django.contrib.auth.hashers import check_password
from SETH.models import *


class AuthenticationBackend:
    def authenticate(self, request, username=None, password=None):
        auser = CommonUser.objects.filter(username=username, password=password)
        if len(auser)==0:
            print("Not exist")
            return None
        else:
            print("Login success")
            return auser[0]

    def get_user(self, username):
        try:
            print(f'Get user {username} success')
            return CommonUser.objects.get(pk=username)
        except CommonUser.DoesNotExist:
            print(f'Not found user {username}')
            return None