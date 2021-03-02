
from django.shortcuts import render, redirect 
from django.contrib import messages 
from django.contrib.auth import login 
from User.backends.AuthenticationBackend import AuthenticationBackend


def auser_login(request): 
    if request.method == 'POST': 
        print(request.POST)
        username = request.POST['username']
        password = request.POST['password']
        print(username)
        print(password)
        user = AuthenticationBackend().authenticate(request=request, username = username, password = password) 
        if user is not None: 
            login(request, user, backend='User.backends.AuthenticationBackend.AuthenticationBackend') 
            messages.success(request, f' wecome {username} !!') 
            return redirect('a_web:dashboard') 
        else: 
            messages.info(request, f'account done not exit plz sign in') 

    return render(request, 'front1/login.html', {'title':'log in'}) 
