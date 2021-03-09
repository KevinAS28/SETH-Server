from django.db import models

class history(models.Model):
    nik = models.CharField(max_length=100)
    name = models.CharField(max_length=100)
    sertifikat = models.CharField(max_length=20)
    result = models.IntegerField()


