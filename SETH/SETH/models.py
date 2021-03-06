from django.db import models 
from datetime import datetime, date
from django.utils.translation import ugettext_lazy as _

class CUser(models.Model):
    nik = models.CharField(max_length=50, blank=False)
    name = models.CharField(max_length=50, blank=False)
    email = models.CharField(max_length=50, blank=False)
    phone = models.CharField(max_length=50, blank=False)
    bday = models.CharField(max_length=50, blank=False)
    address = models.CharField(max_length=50, blank=False)
    city = models.CharField(max_length=50, blank=False)
    country = models.CharField(max_length=50, blank=False)
    postalcode = models.CharField(max_length=50, blank=False)
    password = models.CharField(max_length=50, blank=False, default='12345')
    face_data = models.CharField(max_length=25, blank=True)
    fingerprint = models.CharField(max_length=25, blank=True)


class APlace(models.Model):
    name = models.CharField(max_length=50, blank=False)


class Certificate(models.Model):
    cuser = models.ForeignKey(CUser, on_delete=models.CASCADE)
    cert_type = models.CharField(max_length=10, blank=False)
    note = models.CharField(max_length=250, blank=True)
    date = models.DateField(default=date.today, blank=True)
    a_place = models.ForeignKey(APlace, on_delete=models.CASCADE, blank=True)
    result = models.BooleanField(blank=False, default=True)
    good_result = models.BooleanField(blank=False, default=False)



class BPlace(models.Model):
    name = models.CharField(max_length=50, blank=False)
    supported_certs = models.ForeignKey(Certificate, on_delete=models.CASCADE)
    




class AUser(models.Model):
    username = models.CharField(_('username'), blank=True, unique=True, max_length=30, )
    password = models.CharField(_('password'), max_length=30)
    aplace = models.ForeignKey(APlace, on_delete=models.CASCADE, related_name='auser')
    # bplace = models.ForeignKey(SETHModels.BPlace, on_delete=models.CASCADE, related_name='auser')

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['password']


class BUser(models.Model):
    username = models.CharField(_('username'), blank=True, unique=True, max_length=30, )
    password = models.CharField(_('password'), max_length=30)
    bplace = models.ForeignKey(BPlace, on_delete=models.CASCADE, related_name='buser')

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['password']
    

class History(models.Model):
    cert = models.ForeignKey(Certificate, on_delete=models.CASCADE)
    datetime = models.DateTimeField(default=datetime.now, blank=True)
    passed = models.BooleanField(default=False)

