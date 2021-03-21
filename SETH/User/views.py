
from django.http.response import JsonResponse
from django.shortcuts import render, redirect
from django.urls import reverse
from django.contrib import messages 
from django.contrib.auth import login, logout
from django.core import serializers


from User.backends.AuthenticationBackend import AuthenticationBackend
from SETH import models

import json

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
        next += '/b_web/qr_page'
    print(f'buser_login next: {next}')
    request.session['login_origin'] = '/b_web/login'
    return render(request, 'front2/login.html', {'title':'log in', 'login_origin': '/b_web/login', 'next': next}) 

def auser_logout(request):
    logout(request)
    return redirect('a_web:dashboard')

def buser_logout(request):
    logout(request)
    return redirect('b_web:buser_login')

def cuser_login(func):
    def wrapper(*args, **kwargs):
        request = args[0]
        if request.method == 'GET':
            username = request.GET['username']
            password = request.GET['password']
        elif request.method == 'POST':
            data = json.loads(request.body)
            username = data['username']
            password = data['password']   
        else:
            response = {'success': False, 'message': 'Invalid method'}
            print('Response:', response)
            return JsonResponse(response)

        user = models.UserAuthentication.objects.filter(username=username, password=password)
        if user.exists():
            print(f"Login success: {user[0].username} -> {request.build_absolute_uri()}")
            result = func(*args, **kwargs)
            auth_success = {'success': True, 'message': 'OK', 'user': serializers.serialize('json', user)}
            response = {**result, **auth_success}
            print('Response:', response)
            return JsonResponse(response)

        else:
            print("Invalid authentication")
            response = {'success': False, 'message': 'Invalid Authentication'}
            print('Response:', response)
            return JsonResponse(response)
    return wrapper

