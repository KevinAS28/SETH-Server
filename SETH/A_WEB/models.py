# Create your models here.
from django.db import models 
# from django.utils import timezone 
from datetime import date
from User import models as UserModels
from SETH import models as SETHModels

# class Certificate(models.Model):
#     cuser = models.ForeignKey(UserModels.CUser, on_delete=models.CASCADE)
#     cert_type = models.CharField(max_length=10, blank=False)
#     note = models.CharField(max_length=250, blank=True)
#     date = models.DateField(default=date.today, blank=True)
#     a_place = models.ForeignKey(SETHModels.APlace, on_delete=models.CASCADE, blank=True)
#     result = models.BooleanField(blank=False, default=True)
#     good_result = models.BooleanField(blank=False, default=False)