# Create your models here.
from django.db import models 
# from django.utils import timezone 
from datetime import date
from User.models import *    


class Certificate(models.Model):
    cuser = models.ForeignKey(CUser, on_delete=models.CASCADE)
    cert_type = models.CharField(max_length=10, blank=False)
    note = models.CharField(max_length=250, blank=True)
    date = models.DateField(default=date.today, blank=True)