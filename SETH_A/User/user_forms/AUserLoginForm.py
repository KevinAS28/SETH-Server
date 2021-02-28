from django import forms  

class AUserLoginForm(forms.Form):  
    username = forms.CharField(max_length=30, required=True)
    password = forms.CharField(max_length=30, required=True, widget=forms.PasswordInput())