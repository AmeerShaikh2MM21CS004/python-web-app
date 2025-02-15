from django.shortcuts import render

def home(request):
    return render(request, 'index.html')  # Render index.html
