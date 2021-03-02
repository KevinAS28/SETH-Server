# Create your models here.
from django.db import models 
# from django.utils import timezone 
from datetime import date
  


class UserC(models.Model):
    nik = models.CharField(max_length=50, blank=False)
    name = models.CharField(max_length=50, blank=False)
    email = models.CharField(max_length=50, blank=False)
    phone = models.CharField(max_length=50, blank=False)
    bday = models.CharField(max_length=50, blank=False)
    address = models.CharField(max_length=50, blank=False)
    city = models.CharField(max_length=50, blank=False)
    country = models.CharField(max_length=50, blank=False)
    postalcode = models.CharField(max_length=50, blank=False)
    face_data = models.CharField(max_length=25, blank=True)
    fingerprint = models.CharField(max_length=25, blank=True)
    


class Certificate(models.Model):
    userc = models.ForeignKey(UserC, on_delete=models.CASCADE)
    cert_type = models.CharField(max_length=10, blank=False)
    note = models.CharField(max_length=250, blank=True)
    date = models.DateField(default=date.today, blank=True)