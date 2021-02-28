from django.conf import settings
from django.contrib.auth.hashers import check_password
from User.user_models.AUser import AUser


class AuthenticationBackend:
    def authenticate(self, request, username=None, password=None):
        auser = AUser.objects.filter(username=username, password=password)
        if len(auser)==0:
            print("Not exist")
            return None
        else:
            print("Login success")
            return auser[0]

    def get_user(self, user_id):
        try:
            return AUser.objects.get(pk=user_id)
        except AUser.DoesNotExist:
            return None