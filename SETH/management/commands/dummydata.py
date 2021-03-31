from django.core.management.base import BaseCommand, CommandError
from django.db.models.deletion import SET
from SETH import models as SETHModels
import datetime
import random
import sys
import json
import requests

class Command(BaseCommand):
    help = 'Genrate dummy data'

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.to_generate = {
            'common': self.generate_common,
            'genA': self.generateA,
            'genB': self.generateB,
            'genC': self.generateC,
            'genPlace': self.generatePlace
        }


    def add_arguments(self, parser):
        # parser.add_argument('togen', nargs='*')
        parser.add_argument('togen',
                    nargs='*',
                    choices=list(self.to_generate.keys()),
                    help='List of functions to generate data'
        )

    def handle(self, *args, **options):
        # self.stdout.write(self.style.SUCCESS(str(options)))

        togen = options['togen']
        tocalled = []
        if len(togen)==0:
            tocalled = list(self.to_generat.keys())
        else:
            tocalled = togen
        
        tocalled = ['common'] + tocalled

        for f in tocalled:
            self.to_generate[f]()
            
        self.stdout.write(self.style.SUCCESS('Done'))


    def generate_common(self):
        pass
        # self.stdout.write(self.style.NOTICE("Generate common..."))
        # for i in SETHModels.UserType.USER_TYPES:
        #     SETHModels.UserType(i[0]).save()
        
    

    def generateA(self):
        self.stdout.write(self.style.NOTICE("Generate A..."))
        
        #APlace CommonUser
        cities = 'Bogor Jakarta Bandung Jogja Tangerang Depok Bali Semarang'.split()
        index = 0
        for city in cities:
            print(city)
            aplace = SETHModels.APlace(name=f"{city} Hospital Center")
            aplace.save()
            auser = SETHModels.AUser(aplace=aplace)
            auser.save()
            SETHModels.UserAuthentication(username=f'auser{index}', password=f'12345{index}', auser=auser, usertype=SETHModels.UserAuthentication.A_TYPE).save()            
            index += 1            
        
        self.stdout.write(self.style.SUCCESS('generateA'))

    def generateB(self):
        self.stdout.write(self.style.NOTICE("Generate B..."))
        cert_types = ['PCR', 'Genose', 'Swab', 'Rapid']#list(SETHModels.Certificate.objects.all())

        #BPlace CommonUser
        cities = ['Gambir', 'Pasar Senen', 'Cirebon', 'Solo Balapan', 'Purwokerto']
        index = 0
        for city in cities:
            for ct in cert_types:
                print(f'{city} - {ct}')
                bplace = SETHModels.BPlace(name=f"{city} Station" , supported_certs=ct)
                bplace.save()
                buser = SETHModels.BUser(bplace=bplace)
                buser.save()
                SETHModels.UserAuthentication(username=f'buser{index}', password=f'12345{index}', buser=buser, usertype=SETHModels.UserAuthentication.B_TYPE).save()            
                index += 1            

        #History
        cert_list = SETHModels.Certificate.objects.all()
        b_places = SETHModels.BPlace.objects.all()
        cusers = SETHModels.CUser.objects.all()
        print(len(cert_list))
        index = 0
        for c in cusers:
            for b in b_places:
                print(index)
                SETHModels.History(cuser=c, datetime=datetime.datetime.now(), passed=True, b_place=b).save()
                index += 1

        self.stdout.write(self.style.SUCCESS('generateB'))

    def generateC(self):
        self.stdout.write(self.style.NOTICE("Generate C..."))
        names = open('names.txt', 'r').read().split('\n')
        for i in range(len(names)):
            print(i)
            cuser = SETHModels.CUser(
                nik = f'30129012887{i}',
                name = f'{names[i]}',
                email = f'a{i}@a.com',
                phone = f'000{i}',
                bday = '1997-02-02',
                address = f'street {i}',
                country = 'Indonesia',
                postalcode = f'{i}',
            )
            cuser.save()
            SETHModels.UserAuthentication(username=f'cuser{i}', password=f'12345{i}', cuser=cuser, usertype=SETHModels.UserAuthentication.C_TYPE).save()           


        #Certificates
        aplace_list = list(SETHModels.APlace.objects.all())
        print(len(aplace_list))
        index = 0
        for cuser in list(SETHModels.CUser.objects.all()):
            print(index)
            SETHModels.Certificate(cuser=cuser, cert_type='PCR', note='No Problems', date=datetime.date.today(), a_place=random.choice(aplace_list), result=False).save()
            index += 1

        self.stdout.write(self.style.SUCCESS('generateC'))

    def generatePlace(self):
        self.stdout.write(self.style.NOTICE("Generate Places..."))
        with open("kevin_api_key", "r+") as kevin_api:
            kevin_api = kevin_api.read()

        stations = [i+' Station' for i in ['Gambir', 'Pasar Senen', 'Cirebon', 'Solo Balapan', 'Purwokerto']]
        place_names = stations+['Gadjah Mada University', 'National Monument', 'Taman Safari Bogor']
        certs = list(SETHModels.Certificate.objects.all())
        
        for place in place_names:
            params = {"key": kevin_api, "input": place, "inputtype": "textquery", "placeid": "ChIJ0xkTTRlx0i0Re3sZsgY3Olw", "language": "en"}
            url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
            gcp_result = requests.post(url, params=params)
            json_result = json.loads(gcp_result.content)

            status = json_result['status']
            if status=='OK':
                for place_result in json_result['results']:
                    gcp_name = place_result['name']
                    place_id = place_result['place_id']
                    formatted_address = place_result['formatted_address']

                    bplaces = SETHModels.BPlace.objects.filter(name__contains=gcp_name)
                    aplaces = SETHModels.APlace.objects.filter(name__contains=gcp_name)
                    
                    is_bplace=True if bplaces.exists() else False
                    is_aplace=True if aplaces.exists() else False

                    print(gcp_name)
                    model_place = SETHModels.Place(name=gcp_name, place_gcp_id=place_id, formatted_address=formatted_address, is_aplace=is_aplace, is_bplace=is_bplace, aplace=aplaces[0] if is_aplace else None, bplace=bplaces[0] if is_bplace else None)
                    model_place.save()

                    rn = random.randrange(0, len(certs)-1)
                    model_place.supported_certificates.add(certs[rn])
                    model_place.supported_certificates.add(certs[rn+1])
                    model_place.save()
            else:
                print(f'ERROR on {place}')
                print(json_result)
                print(f'ERROR on {place}')
                exit()
        self.stdout.write(self.style.SUCCESS('generate Places'))

            

        