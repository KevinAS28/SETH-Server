# Create your models here.
from django.db import models 
from django.utils import timezone 
  
class State(models.Model): 
    name = models.CharField(max_length = 50) 
    is_active = models.IntegerField(default = 1, 
                                   blank = True, 
                                    null = True, 
                                    help_text ='1->Active, 0->Inactive',  
                                    choices =( 
                                    (1, 'Active'), (0, 'Inactive') 
                                    )) 
    created_on = models.DateTimeField(default = timezone.now) 
    updated_on = models.DateTimeField(default = timezone.now, 
                                    null = True,  
                                    blank = True
                                    )

    def __str__(self): 
        return self.name 
  
    class Meta: 
        db_table = 'state'

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
