
from django.shortcuts import render, redirect 
from django.contrib import messages 
from django.contrib.auth import login 
from User.backends.AuthenticationBackend import AuthenticationBackend
from django.contrib.auth.decorators import login_required 
from django.contrib.auth.forms import AuthenticationForm 
from django.core.mail import send_mail 
# from django.core.mail import usernameMultiAlternatives 
from django.template.loader import get_template 
from django.template import Context 
from User.user_forms.AUserForm import AUserForm
from User.user_forms.AUserLoginForm import AUserLoginForm
from django.db.utils import IntegrityError
from User.user_models.AUser import AUser
from User.user_models.Kelas import Kelas
from User.user_models.Jurusan import Jurusan
#################### index#######################################  
def index(request): 
    return render(request, 'index.html', {'title':'index'}) 
   
########### register here #####################################  
def register(request): 

    if request.method == 'POST': 
        form = AUserForm(request.POST)#UserRegisterForm(request.POST) 
        
        if form.is_valid():             
            try:
                kelas = Kelas.objects.all().filter(tingkat=int(form.cleaned_data["kelas"]))[0]
                jurusan = Jurusan.objects.all().filter(nama_jurusan=form.cleaned_data["jurusan"])[0]
                name = form.cleaned_data["name"]
                password = form.cleaned_data["password"]
                username = form.cleaned_data["username"]

                AUser = AUser(name=name, password=password, username=username, kelas=kelas, jurusan=jurusan)
                AUser.save()

                return login_form(request)
            except (IntegrityError):
                #username already exist
                print("username already exist")
                pass
            
            
        else:
            print('form not valid')
            # username = form.cleaned_data.get('username') 
            # username = form.cleaned_data.get('username') 
            ######################### mail system ####################################  
            # htmly = get_template('user / username.html') 
            # d = { 'username': username } 
            # subject, from_username, to = 'welcome', 'your_username@gmail.com', username 
            # html_content = htmly.render(d) 
            # msg = usernameMultiAlternatives(subject, html_content, from_username, [to]) 
            # msg.attach_alternative(html_content, "text / html") 
            # msg.send() 
            #messages.success(request, f'Your account has been created ! You are now able to log in') 
            ##################################################################  
            
                
    return render(request, 'register1.html', )#{'form': form, 'title':'reqister here'}) 
    
   
################ login forms###################################################  

def login_form(request): 
    if request.method == 'POST': 
        # AuthenticationForm_can_also_be_used__ 
        print(request.POST)
        username = request.POST['username']
        password = request.POST['password']
        print(username)
        print(password)
        user = AuthenticationBackend().authenticate(request=request, username = username, password = password) 
        if user is not None: 
            form = login(request, user, backend='User.backends.AuthenticationBackend.AuthenticationBackend') 
            messages.success(request, f' wecome {username} !!') 
            return redirect('a_web:home') 
        else: 
            messages.info(request, f'account done not exit plz sign in') 
    form = AUserLoginForm() 
    return render(request, 'front1/login.html', {'form':form, 'title':'log in'}) 
