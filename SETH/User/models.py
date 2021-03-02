from django.db import models
from django.contrib.auth.models import AbstractUser
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
    face_data = models.CharField(max_length=25, blank=True)
    fingerprint = models.CharField(max_length=25, blank=True)


class AUser(AbstractUser):
    username = models.CharField(_('username'), blank=True, unique=True, max_length=30)
    password = models.CharField(_('password'), max_length=30)
    # kelas = models.ForeignKey(Kelas, on_delete=models.CASCADE, default=1)
    # jurusan = models.ForeignKey(Jurusan, on_delete=models.CASCADE, default=1)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['password']

    