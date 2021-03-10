from django.core.management.base import BaseCommand, CommandError
from django.db.models.deletion import SET
from SETH import models as SETHModels
import datetime
import random
import sys

class Command(BaseCommand):
    help = 'Genrate dummy data'

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.to_generate = {
            'common': self.generate_common,
            'genA': self.generateA,
            'genB': self.generateB,
            'genC': self.generateC,
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
        
        #Certificates
        aplace_list = list(SETHModels.APlace.objects.all())
        print(len(aplace_list))
        index = 0
        for cuser in list(SETHModels.CUser.objects.all()):
            print(index)
            SETHModels.Certificate(cuser=cuser, cert_type='PCR', note='No Problems', date=datetime.date.today(), a_place=random.choice(aplace_list), result=False).save()
            index += 1
        
        self.stdout.write(self.style.SUCCESS('generateA'))

    def generateB(self):
        self.stdout.write(self.style.NOTICE("Generate B..."))
        cert_list = list(SETHModels.Certificate.objects.all())

        #BPlace CommonUser
        cities = 'Bogor Jakarta Bandung Jogja Tangerang Depok Bali Semarang'.split()
        index = 0
        for city in cities:
            print(index)
            bplace = SETHModels.BPlace(name=f"{city} Hospital Center" , supported_certs=random.choice(cert_list))
            bplace.save()
            buser = SETHModels.BUser(bplace=bplace)
            buser.save()
            SETHModels.UserAuthentication(username=f'buser{index}', password=f'12345{index}', buser=buser, usertype=SETHModels.UserAuthentication.B_TYPE).save()            
            index += 1            

        #History
        print(len(cert_list))
        index = 0
        for cert in cert_list:
            print(index)
            SETHModels.History(cert=cert, datetime=datetime.datetime.now(), passed=True).save()
            index += 1

        self.stdout.write(self.style.SUCCESS('generateB'))

    def generateC(self):
        self.stdout.write(self.style.NOTICE("Generate C..."))

        for i in range(10):
            print(i)
            cuser = SETHModels.CUser(
                nik = f'{i}',
                name = f'cuser{i}',
                email = f'a{i}@a.com',
                phone = f'000{i}',
                bday = '1997-02-02',
                address = f'street {i}',
                country = 'Indonesia',
                postalcode = f'{i}',
            )
            cuser.save()
            SETHModels.UserAuthentication(username=f'cuser{i}', password=f'12345{i}', cuser=cuser, usertype=SETHModels.UserAuthentication.C_TYPE).save()           

        self.stdout.write(self.style.SUCCESS('generateC'))

