
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


apiPath ="https://conformance.cryptofacilities.com/derivatives"
#apiPath = "https://www.cryptofacilities.com/derivatives"# https://conformance.cryptofacilities.com/derivatives"
#apiPublicKey = "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"# xyyXQVbDy+RwqdK1/4lkL2XowM75/t7atsj8/WyGvk9WPBECO9XPLimX"  # accessible on your Account page under Settings -> API Keys
apiPublicKey ="xyyXQVbDy+RwqdK1/4lkL2XowM75/t7atsj8/WyGvk9WPBECO9XPLimX"  # accessible on your Account page under Settings -> API Keys
#apiPrivateKey ="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"# aeaE+g+JMQqXIRu5YhWTCrIldZBd6WZt95tlqiFynmRmFogpDcmZALUsmhLnkaGGx+DZ9ueG54YVIqjZFVDEPaaD"  # accessible on your Account page under Settings -> API Keys
apiPrivateKey ="aeaE+g+JMQqXIRu5YhWTCrIldZBd6WZt95tlqiFynmRmFogpDcmZALUsmhLnkaGGx+DZ9ueG54YVIqjZFVDEPaaD"  # accessible on your Account page under Settings -> API Keys
timeout = 20
checkCertificate = False#True#False  # when using the test environment, this must be set to "False"
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

deribitauthurl = "https://deribit.com/api/v2/public/auth"
URL = 'https://www.deribit.com'

#key = "Q6dC967TgxBK"
#secret = "AQ7XBQ2LGOTCM32J4LY5IYWPC6CZUBS5"

#deribitauthurl = "https://test.deribit.com/api/v2/public/auth"
#URL = 'https://test.deribit.com'
PARAMS = {'client_id': key, 'client_secret': secret, 'grant_type': 'client_credentials'}#, 'scope': 'session:trade:read_write' }

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

BTC_SYMBOL = 'btc'
STOP_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 30, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(STOP_TIME.timetuple())*1000
LOG_LEVEL = logging.INFO


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

		insts = client_public.public_get_instruments_get(currency='BTC' or 'ETH', kind='future', expired='false')['result']

		self.futures = sort_by_key({i['instrument_name']: i for i in (insts) if i['kind'] == 'future'})

	def get_funding(self):
		return client_private.private_get_account_summary_get(currency='BTC', extended='true')['result']['session_funding']

	def output_status(self):

		if not self.output:
			return None

		print('')

	def telegram_bot_sendtext(self,bot_message):

		bot_token = '1035682714:AAGea_Lk2ZH3X6BHJt3xAudQDSn5RHwYQJM'
		bot_chatID = '148190671'
		send_text = 'https://api.telegram.org/bot' + bot_token + '/sendMessage?chat_id=' + bot_chatID + '&parse_mode=Markdown&text=' + bot_message

		response = requests.get(send_text)

		return response.json()

	def place_orders(self):

		if self.monitor:
			return None
 
		hold_longQtyAll_CF = sum( [ o['size'] for o in [ o for o in json.loads(cfPrivate.get_openpositions())[
            'openPositions']if o['side'] == 'long' and  o['symbol'][:9][4]=='b' ] ] )
		hold_shortQtyAll_CF = sum( [ o['size'] for o in [ o for o in json.loads(cfPrivate.get_openpositions())[
            'openPositions']if o['side'] == 'short' and  o['symbol'][:9][4]=='b' ] ] )
        
		y=list(self.futures.keys())

		fut_CF=([ o['symbol'] for o in [ o for o in json.loads(cfPublic.getinstruments())[
            'instruments'] if o['symbol'][10:][:1]== '2'  and  o['symbol'][:9][4]=='b' ] ])
        
		perp_CF=  ([ o['symbol'] for o in [ o for o in                json.loads(cfPublic.getinstruments())['instruments'] if(                        o['symbol'][:1] == 'f'  or    o['symbol']=='pi_xbtusd' )and                o['symbol'][:9][4]=='b' ]])#.split('.')

		deriCF= perp_CF + y
        
		for fut in deriCF:

			deri_test = 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1

			last_prc_CF = json.loads(cfPrivate.get_fills())['fills']
        
			last_sell_prc = ( [ o['price'] for o in [ o for o in last_prc_CF if o['side'] == 'sell' and  o['symbol']==fut  ] ] )
			last_sell_prc_CF = 0 if last_sell_prc == [] else last_sell_prc [0]
			last_buy_prc = ( [ o['price'] for o in [ o for o in last_prc_CF if o['side'] == 'buy' and  o['symbol']==fut ] ] )
			last_buy_prc_CF = 0 if last_buy_prc == [] else last_buy_prc [0]

			account_CF =json.loads(cfPrivate.get_accounts())['accounts']['fi_xbtusd']		
			liqs_CF=account_CF['triggerEstimates']['im']

			try:
				direction_CF= [o['side'] for o in[o for o in json.loads(cfPrivate.get_openpositions())['openPositions']if o['symbol']==fut]] [0]

			except:
				direction_CF=0
			positions =0 if deri_test == 0 else  client_account.private_get_positions_get(currency=(fut[:3]), kind='future')['result']#['instrument_name' == fut]
			size_CF=0 if direction_CF==0 else [o['size'] for o in[o for o in json.loads(cfPrivate.get_openpositions())['openPositions']if o['symbol']==fut]] [0]
			avg_prc_CF=0 if direction_CF==0 else [o['price'] for o in[o for o in json.loads(cfPrivate.get_openpositions())['openPositions']   if o['symbol']==fut]][0] 
			equity =  account_CF['balances']['xbt']>0

			account= account_CF if deri_test == 0 else client_account.private_get_account_summary_get(currency=(fut[:3]), extended='true')['result']
			equity =equity if deri_test == 0 else ( account['equity'] >0 and account ['currency']==fut [:3] )
			sub_name = 'CF' if deri_test == 0 else account ['username']
			funding = account_CF['auxiliary']['funding']  if deri_test == 0 else account['session_funding']
			waktu = datetime.now()
			
			ob = 0 if deri_test==0 else client_market.public_get_order_book_get(fut)['result']
	
			bid_prc = ob['best_bid_price'] if deri_test == 1 else json.loads(cfPublic.getorderbook(fut.upper()))['orderBook']['bids'][0][0]
			ask_prc = ob ['best_ask_price'] if deri_test == 1 else json.loads(cfPublic.getorderbook(fut.upper()))['orderBook']['asks'][0][0]

			try:
				size=account ['balances' ][fut ] 
			except:
				size=0
			positions =0 if deri_test == 0 else  client_account.private_get_positions_get(currency=(fut[:3]), kind='future')['result']#['instrument_name' == fut]
			position = 0 if deri_test == 0 else client_account.private_get_position_get(fut)['result']
			size=  size if deri_test == 0 else abs(position['size']) 

			inst = 0 if deri_test ==0 else  ( client_public.public_get_instruments_get(currency=(fut[:3]), kind='future', expired='false')['result'])

			hold_longQtyAll 	= 0 if deri_test ==0 else  sum([o['size'] for o in [o for o in positions if o['direction'] == 'buy' ]])

			hold_shortQtyAll 	= 0 if deri_test ==0 else  sum([o['size'] for o in [o for o in positions  if o['direction'] == 'sell' ]])
			hold_net		= (hold_longQtyAll+hold_shortQtyAll) if deri_test ==1 else (hold_longQtyAll_CF + hold_shortQtyAll_CF)

			ord_history 		= 0 if deri_test == 0 else client_trading.private_get_order_history_by_instrument_get (instrument_name=fut, count=2)['result']
			time_sell 		= 0 if deri_test== 0 else ([o['last_update_timestamp'] for o in [o for o in ord_history if o['direction'] == 'sell' ]])
			time_buy		= 0 if deri_test== 0 else  ([o['last_update_timestamp'] for o in [o for o in ord_history if o['direction'] == 'buy' ]])
			time_now 		=(time.mktime(datetime.now().timetuple())*1000)
			wait_sell 		=0 if deri_test==0 else ( 0 if time_sell ==[]else((time_now- time_sell[0])/1000))
			wait_buy		= 0 if deri_test==0 else  (0 if time_buy ==[]else((time_now-time_buy[0])/1000))

			last_sell_prc		=[]if deri_test== 0 else ([o['price'] for o in [o for o in ord_history if o['direction'] == 'sell' ]])
			last_buy_prc		= [] if deri_test ==0 else  ([o['price'] for o in [o for o in ord_history if o['direction'] == 'buy' ]])
			last_sell_prc =last_sell_prc_CF if deri_test ==0 else ( 0 if last_sell_prc ==[] else last_sell_prc [0])
			last_buy_prc =last_buy_prc_CF if deri_test==0 else  (0 if last_buy_prc ==[] else last_buy_prc [0])

			avg_prc = 0

			liqs_CF=account_CF['triggerEstimates']['im']

			liqs =liqs_CF if deri_test == 0 else (0 if self.positions[fut] ['size'] == 0 else self.positions[fut]['estLiqPrice'] )
			liqs_long = False if hold_net < 0 else(bid_prc-liqs)/bid_prc < 40/100
			liqs_short = False if hold_net >0 else abs(liqs-ask_prc)/ask_prc < 40/100

			if size>0 and deri_test==0 :
				direction_CF = 'buy'
			elif size<0 and deri_test==0:
				direction_CF = 'sell'

			direction= direction_CF if deri_test==0 else(0 if size==0 else position['direction'])
			if direction ==('buy' or 'long'):
				avg_prc = (avg_prc_CF + avg_prc) if deri_test==0 else   position['average_price']   + avg_prc
			elif direction ==( 'sell' or 'short'):
				avg_prc =  (avg_prc_CF + avg_prc) if deri_test==0 else   position['average_price'] + avg_prc
			else:
				avg_prc == 0
			margin = 1/100

			nbids 				=  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1
			nasks 				=  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1

			open_ord_CF = ( [   o for o in json.loads(cfPrivate.get_openorders())['openOrders'] if   o['symbol']==fut ]  )
			open_ord_CF = [] if open_ord_CF ==[] else open_ord_CF
			
			open_ord =open_ord_CF if deri_test==0 else client_trading.private_get_open_orders_by_instrument_get (instrument_name=fut)['result']
			open_ord = [] if open_ord ==[] else open_ord [0]
			open_qty= 0
			open_prc=0
			open_time=0
			open_api=0
			oid = 0

			if open_ord ==[] :
				open_qty = open_qty
				open_prc = open_prc
				open_time = open_time
				open_api = open_api
				oid=oid
			elif open_ord !=[]:
				open_qty = ( [ o['unfilledSize' ] for o in open_ord_CF ] [0])   if deri_test==0 else  open_ord['amount']
				open_prc =( [ o['limitPrice' ] for o in open_ord_CF]  [0]) if deri_test==0 else  open_ord['price']
				open_api =False if deri_test==0 else  open_ord['api']
				open_time = ((time_now)-  time.mktime(datetime.strptime([o['receivedTime']for   o in open_ord_CF][0], '%Y-%m-%dT%H:%M:%S.%fZ').timetuple())*1000 ) if deri_test==0 else  ((time_now- open_ord['last_update_timestamp'])/1000)
				oid =( [ o['order_id'] for o in open_ord_CF ] [0]   ) if deri_test==0 else open_ord['order_id']
			get_time=client_public.public_get_time_get()['result']/1000

			just_sell = 1 if time_sell > time_buy else 0
			just_buy = 1 if time_buy  >  time_sell else 0

			for i in range(max(nbids, nasks)):

				place_bids = 'true'
				place_asks = 'true'
				qty = 10 if fut [:3]=='BTC' else 1#
				qty = 100 if fut [:3]=='BTC'and sub_name=='MwaHaHa_5' else qty#
				qty = 100 if sub_name=='CF' else qty#
				stamp = 0 if deri_test==0 else  max([o['creation_timestamp'] for o in [o for o in inst ]])
				stamp_new = 0 if deri_test==0 else ( [ o['instrument_name'] for o in [ o for o in inst if o['creation_timestamp'] == stamp  ] ] )[0]

                           	#batasan transaksi
				#maintenance margin < 60%, lebih manual
				#print('MM',MM)
				place_bids  =  equity==True and open_qty < 1 
				place_asks =   equity==True and open_qty < 1 

				#PILIHAN INSTRUMEN
				#perpetual= diarahkan posisi sell karena funding cenderung berada di sell
				#lawannya, future dengan tanggal jatuh tempo terlama (mengurangi resiko forced sell)-->1
				#future tersisa dipakai sebagai pengimbang/anti likuidasi-->0

				perp_test=(1 if max(perp_CF)==fut else 0) if deri_test ==0 else ( 1 if fut [-10:] == '-PERPETUAL' else 0)
				fut_test_CF=( 1 if ( max(perp_CF) != fut and min(perp_CF) != fut) else 0 )
			
				fut_test=fut_test_CF if deri_test==0 else (1 if stamp_new == fut  else 0)
				prc=0
				if place_bids:

					#oustanding posisi buy hanya boleh 1 per instrumen
					#buka posisi
					if fut_test ==1 and  size == 0:
						prc = bid_prc
						print ('1',sub_name,fut,prc)
						
                    #anti liqs
					elif   liqs_short == True and ( direction == 'buy' or size  ==0) :
						prc =  bid_prc
						print ('4',sub_name,fut,prc,hold_net,direction)
                                        # misi average down
					elif bid_prc  < avg_prc and size !=0  and direction=='buy':

						if last_buy_prc==0 :
							prc = min(bid_prc,avg_prc- (avg_prc*margin * ( 1 if size==100 else 2) ))
							print ('15',sub_name,fut,prc,bid_prc  < avg_prc,size,hold_net,last_sell_prc,last_buy_prc)
						elif  last_buy_prc !=0 :
							prc = min(bid_prc,last_buy_prc - (last_buy_prc*margin  * (1 if size<100 else 2)) )
							print ('16',sub_name,fut,prc,bid_prc  < avg_prc,size,hold_net,last_buy_prc)
						else:
							prc = 0
							print ('17',sub_name,fut,prc,bid_prc  < avg_prc,size,hold_net)
                    
                    # sudah ada short, ambil laba/semua instrumen
					elif avg_prc > 0 and direction == 'sell' :

						if  perp_test == 1 or perp_test==0  :

							if time_sell>time_buy and wait_sell < 5000:
								prc  = min(bid_prc,last_sell_prc -  (last_sell_prc*margin/20))
								print ('8',sub_name,fut,prc,hold_net,time_sell>time_buy)

							elif last_sell_prc == 0:
								prc =  min(bid_prc,avg_prc-(1/2))
								print ('9',sub_name,fut,prc,hold_net,last_sell_prc)
								
							else :
								prc = avg_prc-(1/2)
								print ('10',sub_name,fut,hold_net,direction)
						else:
							prc = 0
							print ('14',sub_name,fut)

					else:
						prc = 0
						print ('18',sub_name,fut,prc)

				limit_order = {
				"orderType": "post",
				"symbol": fut.upper(),
				"side": "buy",
				"size": qty,
				"limitPrice": round(prc-(1/4),0),
				"reduceOnly": "false"
				}


				mod = open_qty%qty
				edit = {
				"limitPrice": bid_prc,
				"size": qty-mod,
				}
				if prc !=0 and place_bids==True:
					if deri_test == 1:

						client_trading.private_buy_get(instrument_name=fut, amount=qty, price=prc, post_only= 'true')

					elif deri_test == 0:
						cfPrivate.send_order_1(limit_order)

					else:
						sleep(1)

				if open_time > 100 :# and api ==True:

					if deri_test == 1 and open_api==True:

						client_trading.private_cancel_get( oid )
					elif deri_test == 0 and open_time>100000 and mod==0:

						cfPrivate.cancel_order(oid)

					elif deri_test==  0 and  mod !=0 and place_bids==True:

						cfPrivate.edit_order(edit)
						print(cfPrivate.edit_order(edit))
					else:
						sleep(1)

				# OFFERS

				if place_asks:

					# cek posisi awal
					#perpetual diutamakan short karena ada fundingnya, kebanyakan di posisi short
                                       #liqs offer BTC-27DEC19 False 0 True 2 True
					if  perp_test == 1 and   size == 0 :
						prc = ask_prc
						print ('A',sub_name,fut,prc)

                                            #anti liqs
					elif  liqs_long == True and ( size == 0 or direction == 'sell') :
						prc =  ask_prc
						print ('D',sub_name,fut,prc,hold_net,direction,size)
							
                     # misi average up
					elif ask_prc  > avg_prc and size !=0  and direction == 'sell':
						if  last_sell_prc== 0:#wait_buy > 1200
							prc = max(ask_prc,avg_prc+(avg_prc*margin  * (1 if size==100 else 2)))
							print ('O',sub_name,fut,prc,ask_prc  > avg_prc,size,hold_net,last_sell_prc,last_buy_prc)

						elif  last_sell_prc !=0 :#wait_buy > 1200
							prc =max(ask_prc,last_sell_prc +      (last_sell_prc*margin  * (1 if size<100 else 2)) )
							print ('P2',sub_name,fut,prc,bid_prc  < avg_prc,size,hold_net,last_sell_prc)
						else:
							prc = 0
							print ('Q',sub_name,fut,prc,ask_prc  > avg_prc,size,hold_net)
 				# sudah ada long, ambil labaabs(avg_prc))t
					elif avg_prc > 0 and direction == 'buy' :

						if   perp_test==0  or perp_test == 1:
							if time_buy>time_sell and wait_buy<5000:
								prc =max(ask_prc, last_buy_prc + (last_buy_prc*margin/20) )
								print ('H',sub_name,fut,prc,hold_net,time_buy>time_sell)
	
							elif last_buy_prc == 0:
								prc =max( ask_prc,avg_prc +(1/2)) 		
								print ('I',sub_name,fut,prc,hold_net,last_buy_prc)

							else:
								prc = max(ask_prc,avg_prc+(1/2)) 		
								print('J',sub_name,fut,prc,hold_net,direction,wait_buy)

						else:
							prc = 0
							print ('N',sub_name,fut,prc)

					else:
						prc = 0
						print ('R',sub_name,fut)

				limit_order = {
				"orderType": "post",
				"symbol": fut.upper(),
				"side": "sell",
				"size": qty,
				"limitPrice":round( prc+(1/4),0),
				"reduceOnly": "false"
				}

				mod = open_qty%qty
				edit = {
				"limitPrice": ask_prc,
				"size": qty-mod,
				}

				if prc !=0 and place_asks == True:
					if deri_test == 1:

						client_trading.private_sell_get(instrument_name=fut, amount=qty, price=prc, post_only= 'true')
					elif deri_test == 0:
						cfPrivate.send_order_1(limit_order)
					else:
						sleep(1)

				if open_time > 100 :# and api ==True:

					if deri_test == 1 and open_api==True:

						client_trading.private_cancel_get( oid )
					elif deri_test == 0 and open_time>100000 and mod==0:

						cfPrivate.cancel_order(oid)

					elif deri_test==  0 and  mod !=0 and place_asks==True:

						cfPrivate.edit_order(edit)
						print(cfPrivate.edit_order(edit))
					else:
						sleep(1)

				counter= get_time - (stop_unix/1000)
				if counter > (15):
					while True:
						self.restart_program()
						break

	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

	def report(self):

		waktu = datetime.now()
		akun=self.client.account ()['subaccount_name']
		my_message = "{}" "-" "{}" "-" "{}".format(waktu,akun,traceback.format_exc())
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
#		self.symbols.sort()

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
#		print(traceback.format_exc())
		sys.exit()
	except:
		mmbot.report()
#		print(traceback.format_exc())
		if args.restart:
			mmbot.restart()

