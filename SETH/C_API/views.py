from django.core import serializers

from django.http.response import JsonResponse

import json
import requests

from SETH import models
from User.views import cuser_login



@cuser_login
def test(request):
    data = json.loads(request.body)
    cauth = models.UserAuthentication.objects.filter(username=data['username'], password=data['password'])
    cuser = cauth[0].cuser
    print(data)
    return {'data': data, 'auth': serializers.serialize('json', cauth), }


@cuser_login
def find_place(request):
    with open("kevin_api_key", "r+") as kevin_api:
        kevin_api = kevin_api.read()

    data = json.loads(request.body)
    place = data['place']

    params = {"key": kevin_api, "input": place, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    gcp_result = requests.post(url, params=params)
    return {'result': (json.loads(gcp_result.content))}

@cuser_login
def get_place_by_id(request):
    with open("kevin_api_key", "r+") as kevin_api:
        kevin_api = kevin_api.read()

    data = json.loads(request.body)
    place_id = data['place_id']

    params = {"key": kevin_api, "place_id": place_id, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    gcp_result = requests.post(url, params=params)
    return {'result': (json.loads(gcp_result.content))}

@cuser_login
def get_transit(request):
    with open("kevin_api_key", "r+") as kevin_api:
        kevin_api = kevin_api.read()

    data = json.loads(request.body)
    params = {'key': kevin_api}
    
    default_params = {
        'origin': 'Gadjah Mada University',
        'destination': 'Soekarno-Hatta International Airport',
        # 'mode': 'transit'
    }

    for dp in default_params:
        if not (dp in data):
            print(f'"{dp}" not provided, replacing with "{default_params[dp]}"')
            params[dp] = default_params[dp]
        else:
            params[dp] = data[dp]


    # params = {"key": kevin_api, "input": place, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    
    url = "https://maps.googleapis.com/maps/api/directions/json"
    gcp_result = requests.post(url, params=params)
    return {'result': (json.loads(gcp_result.content))}

def register(request):
    if request.method=='POST':
        data = json.loads(request.body)
        user_data = data['user_data']
        try:
            models.CUser(**user_data).save()
            return JsonResponse({'success': True, 'msg': ''})
        except Exception as e:
            return JsonResponse({'success': True, 'msg': str(e)})
    else:
        return JsonResponse({'success': False, 'msg': 'Invalid Method'})

