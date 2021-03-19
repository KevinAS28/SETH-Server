
from django.shortcuts import render, redirect
from django.urls import reverse
from django.contrib import messages 
from django.contrib.auth import login, logout
from User.backends.AuthenticationBackend import AuthenticationBackend


def common_user_login(request): 
    if request.method == 'POST': 
        print(request.POST)
        username = request.POST['username']
        password = request.POST['password']
        print(username)
        print(password)
        user = AuthenticationBackend().authenticate(request=request, username = username, password = password) 
        if user is not None: 
            result = login(request, user, backend='User.backends.AuthenticationBackend.AuthenticationBackend') 
            messages.success(request, f' wecome {username} {str(result)}!!') 
            print(f'from common_user_login next: {request.POST["next"]}')
            return redirect(request.POST['next']) 
        else: 
            messages.info(request, f'account done not exit plz sign in') 
            return redirect(request.POST['login_origin'])

def auser_login(request):
    next = ''
    try:
        next += request.GET['next']
    except:
        next += '/a_web/dashboard'
    print(f'auser_login next: {next}')
    request.session['login_origin'] = '/a_web/login'
    return render(request, 'front1/login.html', {'title':'log in', 'login_origin': '/a_web/login', 'next': next}) 

def buser_login(request):
    next = ''
    try:
        next += request.GET['next']
    except:
        next += '/a_web/dashboard'
    print(f'auser_login next: {next}')
    request.session['login_origin'] = '/a_web/login'
    return render(request, 'front1/login.html', {'title':'log in', 'login_origin': '/a_web/login', 'next': next}) 


def auser_logout(request):
    logout(request)
    return redirect('a_web:dashboard')