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


def find_place_core(request):
    with open("kevin_api_key", "r") as kevin_api:
        kevin_api = kevin_api.read()

    data = json.loads(request.body)
    place = data['place']

    params = {"key": kevin_api, "input": place, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    gcp_result = requests.post(url, params=params)
    return {'result': (json.loads(gcp_result.content))}

@cuser_login
def find_place(request):
    return find_place_core(request)

@cuser_login
def find_places_model(request):
    def nr_cert(place_result):
        gcp_name = place_result['name']
        place_id = place_result['place_id']
        print(f'NR place {gcp_name}')
        formatted_address = place_result['formatted_address']

        bplaces = models.BPlace.objects.filter(name__contains=gcp_name)
        aplaces = models.APlace.objects.filter(name__contains=gcp_name)
        
        is_bplace=True if bplaces.exists() else False
        is_aplace=True if aplaces.exists() else False

        print(f'New place registered: {gcp_name}')

        model_place = models.Place(name=gcp_name, place_gcp_id=place_id, formatted_address=formatted_address, is_aplace=is_aplace, is_bplace=is_bplace, aplace=aplaces[0] if is_aplace else None, bplace=bplaces[0] if is_bplace else None)
        model_place.save()

        not_require_certs.append(gcp_name)        

    with open("kevin_api_key", "r") as kevin_api:
        kevin_api = kevin_api.read()

    data = json.loads(request.body)
    place = data['place']    

    params = {"key": kevin_api, "input": place, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    gcp_result = requests.post(url, params=params)
    json_result = json.loads(gcp_result.content)
    # print('len:', len(json_result['results']))
    status = json_result['status']

    require_certs = []
    not_require_certs = []

    if status=='OK':
        for place_result in json_result['results']:  
            place_id = place_result['place_id']  
            gcp_name = place_result['name']

            registered_places = models.Place.objects.filter(place_gcp_id=place_id)
            
            # print(f'place: {gcp_name}')
            
            if len(registered_places)>0:
                for rp in registered_places:
                    
                    rp0 = rp.name#serializers.serialize('json', [rp])
                    rp1 = list(set([i.cert_type for i in rp.supported_certificates.all()]))#serializers.serialize('json', rp.supported_certificates.all())
                    if len(rp1) > 0:
                        print(f'RP place {gcp_name}')
                        require_certs.append({rp0: rp1})
                    else:
                        print(f'RP  00 place {gcp_name}')
                        nr_cert(place_result)
            else:
                print(f'NR place {gcp_name}')
                not_require_certs.append(gcp_name)
            
        return {'require_certs': require_certs, 'not_required_certs': not_require_certs}
    else:
        return {'message': 'Status not ok', 'result': json_result}

@cuser_login
def place_input(request):
    with open("kevin_api_key", "r") as kevin_api:
        kevin_api = kevin_api.read()
    # print(kevin_api)
    data = json.loads(request.body)

    params = {"key": kevin_api, "input": data["place"], "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    gcp_result = requests.post(url, params=params)
    json_result = json.loads(gcp_result.content)
    
    return json_result

@cuser_login
def get_place_by_id(request):
    with open("kevin_api_key", "r") as kevin_api:
        kevin_api = kevin_api.read()

    data = json.loads(request.body)
    place_id = data['place_id']

    params = {"key": kevin_api, "place_id": place_id, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    gcp_result = requests.post(url, params=params)
    return {'result': (json.loads(gcp_result.content))}

@cuser_login
def get_transit(request):
    with open("kevin_api_key", "r") as kevin_api:
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

@cuser_login
def get_history(request):
    data = json.loads(request.body)
    username = data['username']

@cuser_login
def get_certificates(request):
    data = json.loads(request.body)
    nik = data['nik']
    certs = [[c.cert_type, c.note, c.date, c.a_place.name] for c in models.Certificate.objects.filter(cuser__nik__contains=nik)]
    return {'certs': certs}

@cuser_login
def cert_aplaces(request):
    data = json.loads(request.body)
    cert_name = data['cert_name']
    aplaces = [i.name for i in list(models.APlace.objects.all()[:3])]
    return {'aplaces': aplaces}

@cuser_login
def find_aplaces(request):
    data = json.loads(request.body)
    aplace_name = data['aplace_name']
    aplaces = [i.name for i in list(models.APlace.objects.filter(name__contains=aplace_name))]
    return {'aplaces': aplaces}

@cuser_login
def history_a(request):
    data = json.loads(request.body)
    nik = data['nik']
    history = [[i.b_place.name, i.datetime, 'Passed' if i.passed else 'Not Passed'] for i in models.History.objects.filter(cuser__nik__contains=nik)]
    return {'history': history}

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

