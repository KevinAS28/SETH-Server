from django.shortcuts import render
from django.views.generic import TemplateView, ListView
from .models import history
from django.db.models import Q

class HomePageView(TemplateView):
    template_name = 'home.html'

def history_view(request):
        his = history.objects.all()
        context = {
            "object_list": his
        }
        return render(request, "history.html", context)


class SearchResultsView(ListView):
    model = history
    template_name = 'results.html'

    def get_queryset(self):
        query = self.request.GET.get('q')
        object_list = history.objects.filter(
            Q(nik__icontains=query) | Q(name__icontains=query)
        )
        return object_list

def registration(request):
    return render(request, 'registration.html')

def profile_view(request):
    his = history.objects.all()
    context = {
        "object_list": his
    }
    return render(request, 'profile.html', context)
