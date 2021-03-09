from django.contrib.auth.models import AbstractBaseUser
from django.db import models 
from datetime import datetime, date
from django.utils.translation import ugettext_lazy as _

class CommonUser(AbstractBaseUser):
    #Basic Authentication
    A_TYPE = 1
    B_TYPE = 2
    C_TYPE = 3
    USER_TYPES = ((A_TYPE, "A_TYPE"), (B_TYPE, "B_TYPE"), (C_TYPE, "C_TYPE"))

    username = models.CharField(_('username'), blank=True, null=True, unique=True, max_length=30, )
    password = models.CharField(_('password'), max_length=30)
    usertype = models.PositiveSmallIntegerField(choices=USER_TYPES, blank=True, null=True)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['password']

    #For C User
    nik = models.CharField(max_length=50, blank=True, null=True)
    name = models.CharField(max_length=50, blank=True, null=True)
    email = models.CharField(max_length=50, blank=True, null=True)
    phone = models.CharField(max_length=50, blank=True, null=True)
    bday = models.CharField(max_length=50, blank=True, null=True)
    address = models.CharField(max_length=50, blank=True, null=True)
    city = models.CharField(max_length=50, blank=True, null=True)
    country = models.CharField(max_length=50, blank=True, null=True)
    postalcode = models.CharField(max_length=50, blank=True, null=True)
    password = models.CharField(max_length=50, blank=True, null=True, default='12345')
    face_data = models.CharField(max_length=25, blank=True, null=True)
    fingerprint = models.CharField(max_length=25, blank=True, null=True)
    
    #For A & B User
    aplace = models.ForeignKey('APlace', on_delete=models.CASCADE, related_name='aplace', blank=True, null=True)
    bplace = models.ForeignKey('BPlace', on_delete=models.CASCADE, related_name='bplace', blank=True, null=True)



# class CommonUser(models.Model):
#     nik = models.CharField(max_length=50, blank=False)
#     name = models.CharField(max_length=50, blank=False)
#     email = models.CharField(max_length=50, blank=False)
#     phone = models.CharField(max_length=50, blank=False)
#     bday = models.CharField(max_length=50, blank=False)
#     address = models.CharField(max_length=50, blank=False)
#     city = models.CharField(max_length=50, blank=False)
#     country = models.CharField(max_length=50, blank=False)
#     postalcode = models.CharField(max_length=50, blank=False)
#     password = models.CharField(max_length=50, blank=False, default='12345')
#     face_data = models.CharField(max_length=25, blank=True, null=True)
#     fingerprint = models.CharField(max_length=25, blank=True, null=True)


class APlace(models.Model):
    name = models.CharField(max_length=50, blank=False)


class Certificate(models.Model):
    cuser = models.ForeignKey(CommonUser, on_delete=models.CASCADE)
    cert_type = models.CharField(max_length=10, blank=False)
    note = models.CharField(max_length=250, blank=True, null=True)
    date = models.DateField(default=date.today, blank=True, null=True)
    a_place = models.ForeignKey(APlace, on_delete=models.CASCADE, blank=True, null=True)
    result = models.BooleanField(blank=False, default=True)
    good_result = models.BooleanField(blank=False, default=False)


class BPlace(models.Model):
    name = models.CharField(max_length=50, blank=False)
    supported_certs = models.ForeignKey(Certificate, on_delete=models.CASCADE)
    

# class CommonUser(models.Model):
    # username = models.CharField(_('username'), blank=True, null=True, unique=True, max_length=30, )
    # password = models.CharField(_('password'), max_length=30)

    # aplace = models.ForeignKey(APlace, on_delete=models.CASCADE, related_name='CommonUser')
    # bplace = models.ForeignKey(SETHModels.BPlace, on_delete=models.CASCADE, related_name='CommonUser')

    # USERNAME_FIELD = 'username'
    # REQUIRED_FIELDS = ['password']


# class CommonUser(models.Model):
    # username = models.CharField(_('username'), blank=True, null=True, unique=True, max_length=30, )
    # password = models.CharField(_('password'), max_length=30)
    # bplace = models.ForeignKey(BPlace, on_delete=models.CASCADE, related_name='CommonUser')

    # USERNAME_FIELD = 'username'
    # REQUIRED_FIELDS = ['password']
    

class History(models.Model):
    cert = models.ForeignKey(Certificate, on_delete=models.CASCADE)
    datetime = models.DateTimeField(default=datetime.now, blank=True, null=True)
    passed = models.BooleanField(default=False)






