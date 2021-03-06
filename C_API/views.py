from django.core import serializers
from django.http.response import JsonResponse
from django.forms.models import model_to_dict

import json
import requests

from SETH import models
from User.views import cuser_login


@cuser_login
def test(request):
    data = json.loads(request.body)
    cauth = models.UserAuthentication.objects.filter(username=data['username'], password=data['password'])
    data = {**model_to_dict(cauth[0].cuser), **data}
    print(data)
    return {'data': data, 'auth': serializers.serialize('json', cauth), }

@cuser_login
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
    global not_require_certs
    
    require_certs = []
    not_require_certs = []

    def nr_cert(place_result):
        global not_require_certs
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

                        params1 = {"key": kevin_api, "place_id": place_id, "inputtype": "textquery", "language": "en"}
                        url1 = "https://maps.googleapis.com/maps/api/place/details/json"
                        gcp_result1 = requests.post(url1, params=params1)
                        json_result1 = json.loads(gcp_result1.content)
                        print(json_result1)
                        cid = json_result1['result']['url'].split('cid=')[1]
                        # rp1.insert(0, cid)

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

    params = {"key": kevin_api, "place_id": place_id, "inputtype": "textquery", "language": "en"}
    url = "https://maps.googleapis.com/maps/api/place/details/json"
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

    def _certificate_object(cert):
        cert_dict = model_to_dict(cert)
        cert_dict['a_place_id'] = cert.a_place.id
        cert_dict['a_place_name'] = cert.a_place.name
        return cert_dict

    # certs = [[c.id, c.cert_type, c.note, c.date, c.a_place.name] for c in models.Certificate.objects.filter(cuser__nik__contains=nik)]
    certs = [_certificate_object(c) for c in models.Certificate.objects.filter(cuser__nik__contains=nik)]
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

@cuser_login
def delete_cert(request):
    data = json.loads(request.body)
    cert_id = data['cert_id']
    cert = models.Certificate.objects.get(id=cert_id)
    cert_dict = model_to_dict(cert)
    cert.delete()
    return {'deleted cert':  cert_dict}

@cuser_login
def edit_profile(request):
    data = json.loads(request.body)
    
    new_profile = data['new_profile']
    new_auth = data['new_auth']

    cuser_auth = models.UserAuthentication.objects.get(username=data['username'], password=data['password'])
    cuser = cuser_auth.cuser

    for key, val in new_profile.items():
        setattr(cuser, key, val)
    cuser.save()

    for key, val in new_auth.items():
        setattr(cuser_auth, key, val)
    cuser_auth.save()

    return {'new profile user': model_to_dict(cuser), 'new auth user': model_to_dict(cuser_auth)}

@cuser_login
def get_profile(request):
    data = json.loads(request.body)
    cuser_auth = models.UserAuthentication.objects.get(username=data['username'], password=data['password'])
    cuser = cuser_auth.cuser
    return {'profile': model_to_dict(cuser)}

def register(request):
    to_return = dict()
    if request.method=='POST':
        user_data = json.loads(request.body)
        print(user_data)

        try:
            username = user_data['username']
            password = user_data['password']
            
            models.UserAuthentication(username=username, password=password).save()
            cuser = models.CUser(nik=user_data['nik'])
            cuser.save()

            to_return = {'success': True, 'msg': '', 'data': {**user_data}}
        except Exception as e:
            to_return = {'success': True, 'msg': str(e)}
    else:
        to_return = {'success': False, 'msg': 'Invalid Method'}
    print(to_return)
    return JsonResponse(to_return)

