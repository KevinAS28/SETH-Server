from django.db import models
from django.utils.translation import ugettext_lazy as _
from SETH import models as SETHModels

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
#     face_data = models.CharField(max_length=25, blank=True)
#     fingerprint = models.CharField(max_length=25, blank=True)


# class CommonUser():
#     username = models.CharField(_('username'), blank=True, unique=True, max_length=30, )
#     password = models.CharField(_('password'), max_length=30)
#     aplace = models.ForeignKey(SETHModels.APlace, on_delete=models.CASCADE, related_name='CommonUser')
#     # bplace = models.ForeignKey(SETHModels.BPlace, on_delete=models.CASCADE, related_name='CommonUser')

#     USERNAME_FIELD = 'username'
#     REQUIRED_FIELDS = ['password']


# class CommonUser():
#     username = models.CharField(_('username'), blank=True, unique=True, max_length=30, )
#     password = models.CharField(_('password'), max_length=30)
#     bplace = models.ForeignKey(SETHModels.BPlace, on_delete=models.CASCADE, related_name='CommonUser')

#     USERNAME_FIELD = 'username'
#     REQUIRED_FIELDS = ['password']
    