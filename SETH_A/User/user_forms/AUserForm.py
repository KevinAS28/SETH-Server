
#from ProgrammingClass.universal_models.AUser import AUser
from User.user_models.AUser import AUser
from django import forms  
class AUserForm(forms.Form):  
    usernaame = forms.CharField(max_length=30, required=True)
    password = forms.CharField(max_length=30, required=True)

    
    # class Meta:  
    #     model = AUser
    #     fields = "__all__"  