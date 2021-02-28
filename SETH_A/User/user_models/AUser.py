from django.db import models
from .Jurusan import Jurusan
from .Kelas import Kelas
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _

class AUser(AbstractUser):
    username = models.CharField(_('username'), blank=True, unique=True, max_length=30)
    password = models.CharField(_('password'), max_length=30)
    # kelas = models.ForeignKey(Kelas, on_delete=models.CASCADE, default=1)
    # jurusan = models.ForeignKey(Jurusan, on_delete=models.CASCADE, default=1)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['password']

    