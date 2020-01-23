
from collections import OrderedDict
import os
import sys
from os.path import getmtime
import logging, math, random
from time import sleep
from datetime import datetime, timedelta
import copy as cp
import argparse, logging, math, os, sys, time, traceback
import requests
import json
import time
from api import RestClient
import openapi_client
from openapi_client.rest import ApiException
import cfRestApiV3 as cfApi


apiPath = "https://www.cryptofacilities.com/derivatives"
apiPublicKey = "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
apiPrivateKey ="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"# aeaE+g+JMQqXIRu5YhWTCrIldZBd6WZt95tlqiFynmRmFogpDcmZALUsmhLnkaGGx+DZ9ueG54YVIqjZFVDEPaaD"  # accessible on your Account page under Settings -> API Keys
timeout = 5
checkCertificate = True#False  # when using the test environment, this must be set to "False"
useNonce = False  # nonce is optional

cfPublic = cfApi.cfApiMethods(apiPath, timeout=timeout, checkCertificate=checkCertificate)
cfPrivate = cfApi.cfApiMethods(apiPath, timeout=timeout, apiPublicKey=apiPublicKey, apiPrivateKey=apiPrivateKey, checkCertificate=checkCertificate, useNonce=useNonce)

chck_key=str(int(openapi_client.PublicApi(openapi_client.ApiClient(openapi_client.Configuration())).public_get_time_get()['result']/1000))[8:9]*1

if chck_key =='0'  or chck_key =='4' or chck_key =='8' :
	key = "D5FPr7zK"
	secret = "2VFkx_DfvnkPeZgPhd2FSTYZ2iAuR8NneqG2rBYntys"
elif chck_key =='1' or chck_key =='5'  or chck_key =='9':
	key = "5mAEYRe69y8NN"
	secret = "YBVRYHBUMH2SGBJKHVIJIV7G6I3QPMV4"
elif chck_key =='2' or chck_key =='6'  :
	key = "5mA1Br7WAoRxM"
	secret = "27HBSYJC5BY457QM62Y443JHV7NM5F7Z"
elif chck_key =='3' or chck_key =='7' or chck_key =='8' :
	key = "4BX0qBFF"
	secret = "p63D7K2_8YE6rxR8P6aoi9Y0BY6rm3xen9dCrF4WfEM"
else  :
	key = ""
	secret = ""

'mwa 5'
key = "D5FPr7zK"
secret = "2VFkx_DfvnkPeZgPhd2FSTYZ2iAuR8NneqG2rBYntys"


deribitauthurl = "https://deribit.com/api/v2/public/auth"
URL = 'https://www.deribit.com'

#key = "Q6dC967TgxBK"
#secret = "AQ7XBQ2LGOTCM32J4LY5IYWPC6CZUBS5"

#deribitauthurl = "https://test.deribit.com/api/v2/public/auth"
#URL = 'https://test.deribit.com'
PARAMS = {'client_id': key, 'client_secret': secret, 'grant_type': 'client_credentials'}

data = requests.get(url=deribitauthurl, params=PARAMS).json()
accesstoken = data['result']['access_token']

configuration = openapi_client.Configuration()
configuration.access_token = accesstoken
api=openapi_client

client_account = api.AccountManagementApi(api.ApiClient(configuration))
client_trading = api.TradingApi(api.ApiClient(configuration))
client_public = api.PublicApi(api.ApiClient(configuration))
client_private = api.PrivateApi(api.ApiClient(configuration))
client_market = api.MarketDataApi(api.ApiClient(configuration))

# Add command line switches
parser = argparse.ArgumentParser(description='Bot')

# Use production platform/account
parser.add_argument('-p',
                    dest='use_prod',
                    action='store_true')

# Do not display regular status updates to terminal
parser.add_argument('--no-output',
                    dest='output',
                    action='store_false')

# Monitor account only, do not send trades
parser.add_argument('-m',
                    dest='monitor',
                    action='store_true')

# Do not restart bot on errors
parser.add_argument('--no-restart',
                    dest='restart',
                    action='store_false')

args = parser.parse_args()

BTC_SYMBOL      = 'btc'
STOP_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 30, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(STOP_TIME.timetuple())*1000
LOG_LEVEL       = logging.INFO


def get_logger( name, log_level ):

	formatter = logging.Formatter( fmt = '%(asctime)s - %(levelname)s - %(message)s' )
	handler = logging.StreamHandler()
	handler.setFormatter( formatter )
	logger = logging.getLogger( name )
	logger.setLevel( log_level )
	logger.addHandler( handler )

	return logger

def sort_by_key( dictarg ):
	return OrderedDict( sorted( dictarg.items(), key = lambda t: t[ 0 ] ))

class MarketMaker(object):

	def __init__(self, monitor=True, output=True):

		self.client = None
		self.client_trading = None
		self.client_account = None
		self.client_public = None
		self.client_private = None
		self.client_market = None
		self.futures = OrderedDict()
		self.futures_prv = OrderedDict()
		self.logger = None
		self.monitor = monitor
		self.output = output or monitor
		self.position = OrderedDict()
		self.positions = OrderedDict()
		self.getsummary = OrderedDict()

	def create_client(self):

		self.client = RestClient(key, secret, URL)

	def create_client_public(self):
		self.client_public = client_public

	def create_client_private(self):
		self.client_private =  client_private

	def create_client_account(self):
		self.client_account = client_account

	def create_client_trading(self):
		self.client_trading =  client_trading

	def create_client_market(self):
		self.client_trading =  client_market

	def get_futures(self):  # Get all current futures instruments

		self.futures_prv = cp.deepcopy(self.futures)

		instsB = client_public.public_get_instruments_get(
                    currency='BTC', kind='future', expired='false')['result']

		instsE = client_public.public_get_instruments_get(
                    currency='ETH', kind='future', expired='false')['result']

		self.futures = sort_by_key({i['instrument_name']: i for i in (
                    instsB) if i['kind'] == 'future'})

	def get_funding(self):
		return client_private.private_get_account_summary_get(
                    currency='BTC', extended='true')['result']['session_funding']

	def output_status(self):

		if not self.output:
			return None

		print('')

	def telegram_bot_sendtext(self,bot_message):

		bot_token   = '1035682714:AAGea_Lk2ZH3X6BHJt3xAudQDSn5RHwYQJM'
		bot_chatID  = '148190671'
		send_text   = 'https://api.telegram.org/bot' + bot_token + (
                                '/sendMessage?chat_id=') + bot_chatID + (
                            '&parse_mode=Markdown&text=') + bot_message

		response    = requests.get(send_text)

		return response.json()

	def place_orders(self):

		if self.monitor:
			return None

		try:
			position_CF= json.loads(cfPrivate.get_openpositions(
                            ))['openPositions']

		except:
			position_CF=0

		hold_longQtyAll_CF      = sum( [ o['size'] for o in [
                                            o for o in position_CF if o['side'] == 'long' and  o[
                                            'symbol'][:9][4]=='b']])

		hold_shortQtyAll_CF     = sum( [ o['size'] for o in [
                                             o for o in position_CF if o['side'] == 'short' and o[
                                             'symbol'][:9][4]=='b']])
        
		deri                    = list(self.futures.keys())

		non_xbt_CF              = min ([ o['symbol'] for o in [ o for o in json.loads(
                                              cfPublic.getinstruments())['instruments'] if o[
                                             'symbol'][10:][:1]== '2' or o['symbol']=='pv_xrpxbt']])

		xbt_CF                  =  ([ o['symbol'] for o in [ o for o in json.loads(
                                              cfPublic.getinstruments())['instruments']if(o['symbol'
                                              ][:1] == 'f' or o['symbol']=='pi_xbtusd')and o['symbol'
                                              ][:9][4]=='b' ]])

		deriCF= (list(reversed( deri )))#xbt_CF + y) ))
        
		for fut in deriCF:

			waktu           = datetime.now()
			time_now        =(time.mktime(datetime.now().timetuple())*1000)
			get_time        = client_public.public_get_time_get()['result']/1000

			#membagi deribit vs crypto facilities
			deri_test       = 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1

			#mendapatkan atribut isi akun deribit vs crypto facilities
			account_CF      =json.loads(cfPrivate.get_accounts())['accounts']['fi_xbtusd']		

			account         = account_CF if deri_test == 0 else (
                                            client_account.private_get_account_summary_get(
                                            currency=(fut[:3]), extended='true')['result'])

			#mendapatkan nama akun deribit vs crypto facilities
			sub_name        = 'CF' if deri_test == 0 else account ['username']

			#mendapatkan isi ekuitas deribit vs crypto facilities (ada/tidak collateral)
			equity          =  account_CF['balances']['xbt']>0
			
			equity          =   equity if deri_test == 0 else ( account['equity'
                                            ] >0 and account ['currency']==fut [:3] )

			funding         = account_CF['auxiliary']['funding'
                                            ]  if deri_test == 0 else account['session_funding']
			
			liqs_CF         = account_CF['triggerEstimates']['im']

			#mendapatkan isi order book deribit vs crypto facilities 
			ob              =  json.loads(cfPublic.getorderbook(
                                            fut.upper()))['orderBook'
                                            ] if deri_test==0 else client_market.public_get_order_book_get(
                                            fut)['result']
	
			bid_prc         = ob['best_bid_price'] if deri_test == 1 else ob ['bids'][0][0]
			ask_prc         = ob ['best_ask_price'] if deri_test == 1 else ob ['asks'][0][0]

			#mendapatkan transaksi terakhir deribit vs crypto facilities 
			
			last_prc_CF     = json.loads(cfPrivate.get_fills())['fills']
        
			last_sell_prc   = ( [ o['price'] for o in [ o for o in last_prc_CF if o[
                                            'side'] == 'sell' and  o['symbol']==fut  ] ] )

			last_sell_prc_CF= 0 if last_sell_prc == [] else last_sell_prc [0]

			last_buy_prc    = ( [ o['price'] for o in [ o for o in last_prc_CF if o[
                                            'side'] == 'buy' and  o['symbol']==fut ] ] )

			last_buy_prc_CF = 0 if last_buy_prc == [] else last_buy_prc [0]


			try:
				symbol  =( 0 if position_CF == 0 else [ o['symbol'
                                            ] for o in[o for o in position_CF if o['symbol'
                                            ]==fut]] [0]) if deri_test == 0 else 0

			except:
				symbol=0

			#mendapatkan atribut posisi  deribit vs crypto facilities 
		
			positions       = 0 if deri_test == 0 else  (
                                            client_account.private_get_positions_get(currency=(fut[:3]
                                            ), kind='future')['result'])

			positions       = 0 if deri_test == 0 else  (
                                            client_account.private_get_positions_get(
                                            currency=(fut[:3]), kind='future')['result'])
			
			position        = 0 if deri_test == 0 else (
                                            client_account.private_get_position_get(fut)['result'])

			direction_CF    = ( 0 if symbol == 0 else [ o['side'
                                            ] for o in[o for o in position_CF if o['symbol'
                                            ]==fut]] [0]) if deri_test == 0 else 0

			#mendapatkan kuantitas posisi open deribit vs crypto facilities 

                           #tes apakah ada saldonya
			try:
				size    = account ['balances' ][fut ] 
			except:
				size    = 0

			size            =  size if deri_test == 0 else abs(position['size']) 

			#menentukan arah 

			if size>0 and deri_test==0 :
				direction_CF = 'buy'
			elif size<0 and deri_test==0:
				direction_CF = 'sell'

			direction       = direction_CF if deri_test==0 else(
                                            0 if size==0 else position['direction'])

			#menentukan harga rata2 per posisi open 

			avg_prc         = 0

			avg_prc_CF      = 0 if direction_CF==0 else [o['price'
                                            ] for o in[o for o in  position_CF if o['symbol']==fut]] [0]

			if direction    ==('buy' or 'long'):
				avg_prc = (avg_prc_CF + avg_prc) if deri_test==0 else position[
                                            'average_price']   + avg_prc

			elif direction  ==( 'sell' or 'short'):
				avg_prc =  (avg_prc_CF + avg_prc) if deri_test==0 else position[
                                            'average_price'] + avg_prc
			else:
				avg_prc == 0

			#menentukan kuantitas per posisi open per instrumen

			hold_long_qty_fut= 0 if deri_test ==0 else  sum([o['size'
                                            ] for o in [o for o in positions if o['direction'
                                            ] == 'buy' and  o['instrument_name']==fut]])

			hold_short_qty_fut= 0 if deri_test ==0 else  sum([o['size'
                                            ] for o in [o for o in positions  if o['direction'
                                            ] == 'sell' and  o['instrument_name']==fut]])
			
			hold_net	= (hold_long_qty_fut+hold_short_qty_fut
                                            ) if deri_test ==1 else (
                                            hold_longQtyAll_CF - hold_shortQtyAll_CF)

			#mendapatkan atribut riwayat transaksi deribit vs crypto facilities 
			ord_history 	= 0 if deri_test == 0 else (
                                            client_trading.private_get_order_history_by_instrument_get (
                                            instrument_name=fut, count=2)['result'])

			time_sell	= 0 if deri_test== 0 else (
                                            [o['last_update_timestamp'] for o in [
                                            o for o in ord_history if o['direction'] == 'sell' ]])

			time_buy	= 0 if deri_test== 0 else  (
                                            [o['last_update_timestamp'] for o in [
                                            o for o in ord_history if o['direction'] == 'buy' ]])

			wait_sell 	= 0 if deri_test==0 else ( 0 if time_sell ==[
                                            ]else((time_now- time_sell[0])/1000))

			wait_buy	= 0 if deri_test==0 else  (0 if time_buy ==[
                                            ]else((time_now-time_buy[0])/1000))

			last_sell_prc	= []if deri_test== 0 else ([o['price'] for o in [
                                            o for o in ord_history if o['direction'] == 'sell' ]])

			last_buy_prc	= [] if deri_test ==0 else  ([o['price'] for o in [
                                            o for o in ord_history if o['direction'] == 'buy' ]])

			last_sell_prc   = last_sell_prc_CF if deri_test ==0 else (
                                            0 if last_sell_prc ==[] else last_sell_prc [0])

			last_buy_prc    = last_buy_prc_CF if deri_test==0 else  (
                                            0 if last_buy_prc ==[] else last_buy_prc [0])


			liqs_CF         = account_CF['triggerEstimates']['im']

			liqs            = liqs_CF if deri_test == 0 else (
                                            0 if self.positions[fut] ['size'
                                            ] == 0 else self.positions[fut]['estLiqPrice'] )

			liqs_long       = False if hold_net < 0 else(bid_prc-liqs)/bid_prc < 40/100
			liqs_short      = False if hold_net >0 else abs(liqs-ask_prc)/ask_prc < 40/100

			#mendapatkan atribut open order deribit vs crypto facilities 

			open_ord_CF     = ( [ o for o in json.loads(cfPrivate.get_openorders(
                                            ))['openOrders'] if   o['symbol']==fut ]  )

			open_ord_CF     = [] if open_ord_CF ==[] else open_ord_CF
			
			open_ord        = open_ord_CF if deri_test==0 else (
                                            client_trading.private_get_open_orders_by_instrument_get (
                                            instrument_name=fut)['result'])

#			print('open_ord','\n',open_ord)

			#menentukan kuantitas per  open order per instrumen

			open_ord_long_qty_fut 	= 0 if deri_test ==0 else  sum([o['amount'
                                                    ] for o in [o for o in open_ord if o[
                                                    'direction'] == 'buy'  ]])

			open_ord_short_qty_fut	= 0 if deri_test ==0 else  sum([o['amount'
                                                    ] for o in [o for o in open_ord if o[
                                                    'direction'] == 'sell'  ]])*-1

			open_ord_net_qty_fut	= 0 if deri_test ==0 else  open_ord_long_qty_fut + open_ord_short_qty_fut

			print(fut,'open_ord_longQty ',open_ord_long_qty_fut ,'open_ord_shortQty ',open_ord_short_qty_fut,'open_ord_net_qty_fut',open_ord_net_qty_fut)
			
			#menggabungkan kuantitas per open order  vs per open position
			#per instrumen

			total_long_qty 	= 0 if deri_test ==0 else  (
                                            open_ord_long_qty_fut + hold_long_qty_fut)

			total_short_qty = 0 if deri_test ==0 else  (
                                            open_ord_short_qty_fut + hold_short_qty_fut)
			
			total_net       = total_long_qty + total_short_qty 

			print(fut,'total_long_qty',total_long_qty,'total_short_qty',total_short_qty,total_net)
			
			try:

				limit_buy_time  = max( [ o['creation_timestamp'
                                                     ] for o in [ o for o in open_ord if o[
                                                    'direction'] == 'buy'  and  o['api']==True ] ] )
		

				limit_buy_prc   = 0 if limit_buy_time ==0 else ( [ o['price'
                                                    ] for o in [ o for o in open_ord if o[
                                                    'creation_timestamp'] == limit_buy_time  and  o[
                                                        'order_type']=='limit' ] ] [0])
                           
			except:
				limit_buy_prc   = 0
				limit_buy_time  =0

			try:
				limit_sell_time = max( [ o['creation_timestamp'
                                                   ] for o in [ o for o in open_ord if o[
                                                'direction'] == 'sell'  and  o['api']==True ] ] )

				limit_sell_prc  = 0 if limit_sell_time ==0 else( [ o['price'
                                                 ] for o in [ o for o in open_ord if o[
                                                'creation_timestamp'] ==limit_sell_time  and  o[
                                                    'order_type']=='limit']] [0])
				
			except:
				limit_sell_prc=0
				limit_sell_time=0			

			open_ord        = [] if open_ord ==[] else open_ord [0]

			just_sell       = 1 if time_sell > time_buy else 0
			just_buy        = 1 if time_buy  >  time_sell else 0
			margin          = 1/100

			nbids           =  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1
			nasks           =  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1

			for i in range(max(nbids, nasks)):

                           	#batasan transaksi
				place_bids = 'true'
				place_asks = 'true'
				place_bids  =  equity==True  
				place_asks  =   equity==True  

                           	#memisahkan instrumen berdasarkan urutan jatuh tempo:perp/fut
	
				inst        = 0 if deri_test ==0 else  (
                                                client_public.public_get_instruments_get(
                                                currency=(fut[:3]), kind='future', expired='false')['result'])

				stamp       = 0 if deri_test==0 else  max([o[
                                                'creation_timestamp'] for o in [o for o in inst ]])

				stamp_new   = 0 if deri_test==0 else ( [ o[
                                                'instrument_name'] for o in [o for o in inst if o[
                                                'creation_timestamp'] == stamp  ] ] )[0]

				perp_test   =(1 if max(xbt_CF)==fut else 0) if deri_test ==0 else (
                                                1 if fut [-10:] == '-PERPETUAL' else 0)

				fut_test_CF =( 1 if ( max(xbt_CF) != fut and min(xbt_CF) != fut) else 0 )
			
				fut_test    =fut_test_CF if deri_test==0 else (1 if stamp_new == fut  else 0)
		
				#PILIHAN INSTRUMEN
				#perpetual= diarahkan posisi sell karena funding cenderung berada di sell
				#lawannya, future dengan tanggal jatuh tempo terlama (mengurangi resiko forced sell)-->1
				#future tersisa dipakai sebagai pengimbang/anti likuidasi-->0
		
                           	#menentukan kuantitas per transaksi
				prc         =0
				qty         = 10 if fut [:3]=='BTC' else 1#
				qty         = 10 if fut [:3]=='BTC'and sub_name=='MwaHaHa_5' else qty#
				qty         = 10 if sub_name=='CF' else qty#
				qty         = 10 if fut=='pv_xrpxb' else qty#

				if  perp_test== 1 or fut_test==1:

					open_time = ((time_now)-  time.mktime(datetime.strptime(
                                        [o['receivedTime']for o in open_ord_CF][0
                                        ],'%Y-%m-%dT%H:%M:%S.%fZ').timetuple())*1000
                                        ) if deri_test==0 else (time_now/1000- max(
                                        limit_buy_time,limit_sell_time)/1000)

				print('limit prc',fut,waktu,'open',open_time ,'now',time_now,'max',max(
                                    limit_buy_time,limit_sell_time),'diff max',time_now-max(
                                                limit_buy_time,limit_sell_time),limit_buy_prc,limit_sell_prc)

				margin_down = margin * ( 1 if (fut_test ==1 and perp_test==1
                                            ) else (2 if direction=='buy' else 1))
				margin_up = margin * ( 1 if (fut_test ==1 and perp_test==1
                                            ) else (2 if direction=='sell' else 1))                                      

				if place_bids:

					#buka posisi
					if fut_test ==1 and  size == 0 :
						prc = bid_prc
						print ('1',sub_name,fut,prc)
						
                                        #anti liqs
					elif   liqs_short == True and (
                                            direction == 'buy' or size  ==0) :
						prc =  bid_prc
						print ('4',sub_name,fut,prc,hold_net,direction)

                                        # misi average down
					elif size !=0  and direction=='buy'  :

						if open_time >300 or open_time ==0:
                                                    
							prc = bid_prc
							print (
                                                        '15',sub_name,fut,prc,'open_time',open_time)
						else:
							prc = 0
							print ('17',sub_name,fut,wait_buy,size,hold_net)
                    						
					else:
						prc = 0
						print ('18',sub_name,fut,prc)

				limit_order = {
				"orderType": "post",
				"symbol": fut.upper(),
				"side": "buy",
				"size": qty,
				"limitPrice": round(prc-(1/2),0),
				"reduceOnly": "false"
				}

				print (fut,waktu,'total_net',total_net,'ask',ask_prc,'limit_sell_prc',limit_sell_prc,'price',prc)               
				if place_bids==True :
					if deri_test == 1:

						if   perp_test==1 and (
                                                    total_net<0 and limit_sell_prc !=0):

							client_trading.private_buy_get(
                                                            instrument_name=fut ,
                                                            amount=qty,
                                                            price=limit_sell_prc-0.5,
                                                            stop_price=float(limit_sell_prc+0.5),
                                                            type='stop_limit',
                                                            trigger='last_price',
                                                            post_only='true',
                                                            reduce_only='false',
                                                            label='stop')

						elif total_net==0 and prc !=0 :						

							client_trading.private_buy_get(
                                                            instrument_name=fut,
                                                            amount=qty,
                                                            price=prc,
                                                            type='limit',
                                                            label='',
                                                            reduce_only='false',
                                                            post_only='true')						
						else:							

							print('')
							
					elif deri_test == 0:
						cfPrivate.send_order_1(limit_order)

					else:
						print('')

				# OFFERS

				if place_asks:

					# cek posisi awal
					#perpetual diutamakan short karena ada fundingnya, kebanyakan di posisi short

					if  perp_test == 1 and   size == 0 :
						prc = ask_prc
						print ('A',sub_name,fut,prc)

                                            #anti liqs
					elif  liqs_long == True and ( size == 0 or direction == 'sell') :
						prc =  ask_prc
						print ('D',sub_name,fut,prc,hold_net,direction,size)
							
                     # misi average up
					elif  size !=0  and direction == 'sell' :
                            
						if  open_time >300 or open_time ==0:  
							prc = ask_prc
							print ('O',sub_name,fut,prc,'open_time',open_time)
						else:
							prc = 0
							print    ('Q',sub_name,fut,prc,'qty',qty,'wait',wait_sell,'size',size)
 
					else:
						prc = 0
						print ('R',sub_name,fut)

				limit_order = {
				"orderType": "post",
				"symbol": fut.upper(),
				"side": "sell",
				"size": qty,
				"limitPrice":round( prc+(1/2),0),
				"reduceOnly": "false"
				}

				print (fut,waktu,'total_net',total_net,'bid',bid_prc,'limit_buy_prc',limit_buy_prc,'price',prc)               
				if  place_asks == True :
					if deri_test == 1:

						if fut_test==1 and (
                                                    total_net >0 and limit_buy_prc !=0):

							client_trading.private_sell_get(
                                                            instrument_name=fut ,
                                                            amount=qty,
                                                            price=limit_buy_prc+0.5,
                                                            stop_price=float(limit_buy_prc-0.5),
                                                            type='stop_limit',
                                                            trigger='last_price',
                                                            post_only='true',
                                                            reduce_only='false',
                                                            label='stop')
				
						elif  total_net==0 and prc !=0:
							
							client_trading.private_sell_get(
                                                            instrument_name=fut,
                                                            reduce_only='false',
                                                            type='limit',
                                                            post_only='true',
                                                            label='',
                                                            amount=qty,
                                                            price= prc)
	
						else:
							
							print('')

					elif deri_test == 0:
						cfPrivate.send_order_1(limit_order)
					else:
						print('')

				counter= get_time - (stop_unix/1000)
				if counter >35:# if deri_test ==1 else 10:
					while True:
						self.restart_program()
						break

	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

	def report(self):

		waktu = datetime.now()
		akun=self.client.account ()['subaccount_name']
		my_message = "{}" "-" "{}" "-" "{}".format(
                    waktu,akun,traceback.format_exc())
		self.telegram_bot_sendtext(my_message)

	def restart(self):
		try:
			strMsg = 'RESTARTING'
			self.restart_program()

		except:
			pass
		finally:
			self.run_first()

	def run(self):

		self.run_first()

		while True:

			self.get_futures()
			self.update_positions()
			self.place_orders()

	def run_first(self):

		self.create_client()
		self.create_client_account()
		self.create_client_trading()
		self.create_client_public()
		self.create_client_private()
		self.create_client_market()
		self.logger = get_logger('root', LOG_LEVEL)

		# Get all futures contracts
		self.get_futures()
		self.symbols = [BTC_SYMBOL] + list(self.futures.keys())

	def update_positions(self):

		self.positions = OrderedDict({f: {
			'size': 0,
			'sizeBtc': 0,
			'indexPrice': None,
			'markPrice': None
		} for f in self.futures.keys()})
		positions = self.client.positions()

		for pos in positions:
			if pos['instrument'] in self.futures:
				self.positions[pos['instrument']] = pos

if __name__ == '__main__':

	try:
		mmbot = MarketMaker(monitor=args.monitor, output=args.output)
		mmbot.run()
	except(KeyboardInterrupt, SystemExit):
		mmbot.report()
		print(traceback.format_exc())
		sys.exit()
	except:
		mmbot.report()
		print(traceback.format_exc())
		if args.restart:
			mmbot.restart()

