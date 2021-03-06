from django.shortcuts import render
from django.views.generic import TemplateView, ListView
from django.db.models import Q
from A_WEB.models import *

class HomePageView(TemplateView):
    template_name = 'home.html'

# def history_view(request):
#         his = History.objects.all()
#         context = {
#             "object_list": his
#         }
#         return render(request, "History.html", context)


# class SearchResultsView(ListView):
#     model = History
#     template_name = 'results.html'

#     def get_queryset(self):
#         query = self.request.GET.get('q')
#         object_list = History.objects.filter(
#             Q(nik__icontains=query) | Q(name__icontains=query)
#         )
#         return object_list

def registration(request):
    return render(request, 'registration.html')

# def profile_view(request):
#     his = History.objects.all()
#     context = {
#         "object_list": his
#     }
#     return render(request, 'profile.html', context)


def history(request):
    if request.method=="GET":
        return render(request, 'front2/searchCert.html', {"history": list(Certificate.objects.all().order_by("-date"))})
    elif request.method=="POST":
        form = request.POST
        name_nik = form.get("name_nik")
        users = list(CUser.objects.filter(Q(name__iregex=rf".*{name_nik}.*")|Q(nik__iregex=rf".*{name_nik}.*"))) 
        certs = []
        for u in users:
            certs += (list(Certificate.objects.filter(cuser=u)))

        return render(request, 'front2/searchCert.html', {"history": certs})
    else:
        print("Invalid method")
#
# def face(request):
#     if request.m
