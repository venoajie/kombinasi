from sympy import *
from collections import OrderedDict
import os
import sys
import logging, math, random
import time
from time import sleep
from datetime import datetime, timedelta
from os.path import getmtime
import copy as cp
import argparse, logging, math, os, sys, time, traceback
import requests
import json
from api import RestClient
import openapi_client
from openapi_client.rest import ApiException
#import cfRestApiV3 as cfApi
import ssl
import pandas as pd  
#from pandas.io.json import json_normalize

try:
	_create_unverified_https_context = ssl._create_unverified_context
	
except AttributeError:
	# Legacy Python that doesn't verify HTTPS certificates by default
	pass
else:
	# Handle target environment that doesn't support HTTPS verification
	ssl._create_default_https_context = _create_unverified_https_context


#apiPath = "https://www.cryptofacilities.com/derivatives"
#apiPublicKey = "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
#apiPrivateKey ="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"# aeaE+g+JMQqXIRu5YhWTCrIldZBd6WZt95tlqiFynmRmFogpDcmZALUsmhLnkaGGx+DZ9ueG54YVIqjZFVDEPaaD"  # accessible on your Account page under Settings -> API Keys
timeout = 5
checkCertificate = True#False  # when using the test environment, this must be set to "False"
useNonce = False  # nonce is optional

#cfPublic = cfApi.cfApiMethods(apiPath, timeout=timeout, checkCertificate=checkCertificate)
#cfPrivate = cfApi.cfApiMethods(apiPath, timeout=timeout, apiPublicKey=apiPublicKey, apiPrivateKey=apiPrivateKey, checkCertificate=checkCertificate, useNonce=useNonce)

chck_key=str(int(openapi_client.PublicApi(openapi_client.ApiClient(openapi_client.Configuration())).public_get_time_get()['result']/1000))[8:9]*1
print('chck_key',chck_key)

#'mwa 4'
#if chck_key =='0'  or chck_key =='4' or chck_key=='2' or chck_key=='6'or chck_key=='9':
#	key = "D5FPr7zK"
#	secret = "2VFkx_DfvnkPeZgPhd2FSTYZ2iAuR8NneqG2rBYntys"
#'mwa 1'
#elif chck_key =='1' or chck_key =='6':
#	key = "5mAEYRe69y8NN"
#	secret = "YBVRYHBUMH2SGBJKHVIJIV7G6I3QPMV4"

#'mwa out'
#elif chck_key =='2' or chck_key =='7'  :
#	key = "5mA1Br7WAoRxM"
#	secret = "27HBSYJC5BY457QM62Y443JHV7NM5F7Z"
	
#'mwa 5'
#elif chck_key =='3' or chck_key =='1' or chck_key=='5' or chck_key=='7' or chck_key=='8':
#	key = "6BcNigZ1ifgkZ"
#	secret = "QU46YNAYWZQFQTV7JATJUO6M3FWUHIE2"

#mwa6
#elif  chck_key == '4'or chck_key=='9':
#	key = "wfq4ZJwV"
#	secret = "6U0_DyglAlrNpj1jeYw_W9RoQbNBtbpErumIX9gzBvA"


#mwa6
#elif  chck_key == '4'or chck_key=='9':
#	key = "wfq4ZJwV"
#	secret = "6U0_DyglAlrNpj1jeYw_W9RoQbNBtbpErumIX9gzBvA"


#mwa7
if  chck_key == '0'or chck_key=='2' or chck_key=='4' or chck_key=='6' or chck_key=='8':
	key = "LLqqeKzk"
	secret = "8GMFMYVSE-3lVFdAcc5IAYpE64MQW4BPDkVRW2eZsV4"

#mwa8
elif  chck_key == '1'or chck_key=='3' or chck_key=='5' or chck_key=='7' or chck_key=='9':

	key = "DhlgfdXo"
	secret ="PJCtPjbB8VphCpF2oSNV0DBb51hZJ0sLGpZ-21-96as"
#deribitauthurl = "https://test.deribit.com/api/v2/public/auth"

else  :
	key = ""
	secret = ""


#key = "6BcNigZ1ifgkZ"
#secret = "QU46YNAYWZQFQTV7JATJUO6M3FWUHIE2"

#deribitauthurl = "https://deribit.com/api/v2/public/auth"
URL = 'https://www.deribit.com'

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

#BTC_SYMBOL      = 'btc'
STOP_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 30, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(STOP_TIME.timetuple())*1000
LOG_LEVEL       = logging.INFO
MARGIN          = 1/100
WAIT_TIME       = 600 # 5 minutes, wait time in ms

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

##		instsB = client_public.public_get_instruments_get(
#					currency='BTC', kind='future', expired='false')['result']

#		instsE = client_public.public_get_instruments_get(
#					currency='ETH', kind='future', expired='false')['result']
		#instsB = client_market.public_get_book_summary_by_currency_get(currency='BTC', kind='future')['result']
#
#		instsE = client_market.public_get_book_summary_by_currency_get(currency='ETH', kind='future')['result']

#		self.futures = sort_by_key({i['instrument_name']: i for i in (instsB+instsE) })

	def telegram_bot_sendtext(self,bot_message):

		bot_token   = '1035682714:AAGea_Lk2ZH3X6BHJt3xAudQDSn5RHwYQJM'
		bot_chatID  = '148190671'
		send_text   = 'https://api.telegram.org/bot' + bot_token + (
								'/sendMessage?chat_id=') + bot_chatID + (
							'&parse_mode=Markdown&text=') + bot_message

		response    = requests.get(send_text)

		return response.json()

	def place_orders(self):

		
		RED   = '\033[1;31m'#Sell
		BLUE  = '\033[1;34m'#information
		CYAN  = '\033[1;36m'#execution (non-sell/buy)
		GREEN = '\033[0;32m'#blue
		RESET = '\033[0;0m'
		BOLD    = "\033[;1m"
		REVERSE = "\033[;7m"
		ENDC = '\033[m' # 


		instsB = client_market.public_get_book_summary_by_currency_get(currency='BTC', kind='future')['result']

		instsE = client_market.public_get_book_summary_by_currency_get(currency='ETH', kind='future')['result']

		self.futures = sort_by_key({i['instrument_name']: i for i in (instsB)})#+instsE) })

		deri                    = list(self.futures.keys())

#		instsCF                 = json.loads(cfPublic.getinstruments())['instruments']

#		non_xbt_CF              = min ([ o['symbol'] for o in [ o for o in instsCF if o[
#                                             'symbol'][10:][:1]== '2' or o['symbol']=='pv_xrpxbt']])

#		xbt_CF                  =  ([ o['symbol'] for o in [ o for o in instsCF if(o['symbol'
#                                              ][:1] == 'f' or o['symbol']=='pi_xbtusd')and o['symbol'
 #                                             ][:9][4]=='b' ]])

		deriCF= (list(( deri )))#xbt_CF + y) ))
		
		for fut in deriCF:
			#membagi deribit vs crypto facilities
			deri_test       = 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1
			#mendapatkan atribut isi akun deribit vs crypto facilities

			account_CF      =0#json.loads(cfPrivate.get_accounts())['accounts']['fi_xbtusd']		

			account         = account_CF if deri_test == 0 else (
                                client_account.private_get_account_summary_get(
                                        currency=(fut[:3]), extended='true')['result'])

			#mendapatkan nama akun deribit vs crypto facilities
			sub_name        = 'CF' if deri_test == 0 else account ['username']
			
			#summary
				#hold='hold position', ringkasan posisi open
				#filled='transaksi'
				#open='open order, posisi belum tereksekusi'
					#cl=CUTLOSS
			
			#transactions
				#Main
					#openOrder='open order'
					#filledOrder='filled order'
				
				#SubMain				
						#side=sell/buy
						
				#Attribute				
							#attr=time,prc,oid
								#subattr=api,manual
						#memisahkan instrumen berdasarkan urutan jatuh tempo:perp/fut
	
		#inst        = 0 if deri_test ==0 else  (client_public.public_get_instruments_get(
		#										currency=(fut[:3]), kind='future', expired='false')['result'])

		#	stamp       = 0 if deri_test==0 else  max([o['creation_timestamp'] for o in [o for o in instsB ]])

			#stamp       = 0 if deri_test==0 else  ([o['instrument_name'
             #                               ] for o in [o for o in instsB if o['instrument_name'] ==stamp
              #                                      ]])

		#	stamp_new   = 0 if deri_test==0 else ( [ o['instrument_name'] for o in [o for o in instsB if o[
		#										'creation_timestamp'] == stamp  ] ] )[0]

			stamp       = 0 if deri_test==0 else  [o['instrument_name'
                                            ]  for o in [o for o in instsB if  len(o[
											'instrument_name'])==11 
                                                    ]]
			stamp_new=(  min( (stamp)[0],(stamp)[1]))

			perp_test   =(1 if max(xbt_CF)==fut else 0) if deri_test ==0 else (1 if fut [-10:] == '-PERPETUAL' else 0)

			fut_test_CF =0#( 1 if ( max(xbt_CF) != fut and min(xbt_CF) != fut) else 0 )
			
			fut_test    =fut_test_CF if deri_test==0 else (1 if stamp_new == fut  else 0)
							
			waktu           = datetime.now()

			x = Symbol('x')
			time_now        =(time.mktime(datetime.now().timetuple())*1000)
			get_time        = client_public.public_get_time_get()['result']/1000
			prc         =0
			QTY         = 10 if fut [:3]=='BTC' else 1#
			QTY         = 10 if fut [:3]=='BTC'and fut_test==1 else QTY#
			QTY         = 10 if fut [:3]=='BTC'and fut_test==1 and  sub_name== 'MwaHaHa_5' else QTY#
			QTY         = 10 if sub_name=='CF' else QTY#
			QTY         = 10 if fut=='pv_xrpxb' else QTY#

			#tahun=[o['instrument_name'] for o in [o for o in instsB if o max[]  ] ] )
			
#			int(str((instsB['instrument_name'])[-2:]))+int(str((datetime.strptime( (instsB['instrument_name'])[-5:][:3], '%b' ).month)))
#			tahun=int(str((instsB['instrument_name'])[-2:]))+int(str((datetime.strptime( (instsB['instrument_name'])[-5:][:3], '%b' ).month)))

			#mendapatkan isi ekuitas deribit vs crypto facilities (ada/tidak collateral)
			equity          = 0# account_CF['balances']['xbt']>0
			
			equity          =   equity if deri_test == 0 else ( account['equity'
			] >0 and account ['currency']==fut [:3] )
			funding         = 0#account_CF['auxiliary']['funding'
								#            ]  if deri_test == 0 else account['session_funding']
			
			liqs_CF         =0# account_CF['triggerEstimates']['im']

			#mendapatkan isi order book deribit vs crypto facilities 
			
			ob              =   client_market.public_ticker_get(fut)['result']
			
			#ob              =   client_market.public_get_order_book_get(fut)['result']

			#json.loads(cfPublic.getorderbook(
			 #                               fut.upper()))['orderBook'
			  #                              ] if deri_test==0 else client_market.public_get_order_book_get(
			   #                             fut)['result']
	
			bid_prc         = ob['best_bid_price'] if deri_test == 1 else ob ['bids'][0][0]
			ask_prc         = ob ['best_ask_price'] if deri_test == 1 else ob ['asks'][0][0]

			#mendapatkan transaksi terakhir deribit vs crypto facilities 
			
			last_prc_CF     =0# json.loads(cfPrivate.get_fills())['fills']
		
			filledOrders_sell_prc   =0# ( [ o['price'] for o in [ o for o in last_prc_CF if o[
									 #       'side'] == 'sell' and  o['symbol']==fut  ] ] )

			filledOrders_sell_prc_CF= 0# if filledOrders_sell_prc == [] else filledOrders_sell_prc [0]

			filledOrders_buy_prc    =0# ( [ o['price'] for o in [ o for o in last_prc_CF if o[
									   #     'side'] == 'buy' and  o['symbol']==fut ] ] )

			filledOrders_buy_prc_CF = 0# if filledOrders_buy_prc == [] else filledOrders_buy_prc [0]

			try:
				symbol  =( 0 if position_CF == 0 else [ o['symbol'
				] for o in[o for o in position_CF if o['symbol'
				]==fut]] [0]) if deri_test == 0 else 0

			except:
				symbol=0

			#mendapatkan atribut posisi  deribit vs crypto facilities 
			try:
				position_CF=0# json.loads(cfPrivate.get_openpositions(
							  #      ))['openPositions']

			except:
				position_CF=0
	
			positions       = 0 if deri_test == 0 else  (
				client_account.private_get_positions_get(currency=(fut[:3]
				), kind='future')['result'])

			positions       = 0 if deri_test == 0 else  (
				client_account.private_get_positions_get(
					currency=(fut[:3]), kind='future')['result'])
			
			position        = 0 if deri_test == 0 else (
				client_account.private_get_position_get(fut)['result'])

			direction_CF    =0# ( 0 if symbol == 0 else [ o['side'
							   #             ] for o in[o for o in position_CF if o['symbol'
								#            ]==fut]] [0]) if deri_test == 0 else 0

			#mendapatkan kuantitas posisi open deribit vs crypto facilities 

						   #tes apakah ada saldonya
			try:
				hold_size    =0# account ['balances' ][fut ] 
			except:
				hold_size    = 0

			hold_size            =  hold_size if deri_test == 0 else abs(position['size']) 

			#menentukan arah 

			if hold_size > 0 and deri_test==0 :
				direction_CF = 'buy'
			elif hold_size < 0 and deri_test==0:
				direction_CF = 'sell'

			direction       = direction_CF if deri_test==0 else(
                            0 if hold_size==0 else position['direction'])

			#menentukan harga rata2 per posisi open 

			hold_avg_prc         = 0
			hold_avg_prc_buy         = 0
			hold_avg_prc_sell         = 0

			hold_avg_prc_CF      = 0# if direction_CF==0 else [o['price'
									 #       ] for o in[o for o in  position_CF if o['symbol']==fut]] [0]

			if direction    ==('buy' or 'long'):
				hold_avg_prc_buy = (hold_avg_prc_CF + hold_avg_prc
				) if deri_test==0 else position['average_price']   + hold_avg_prc

			elif direction  ==( 'sell' or 'short'):
				hold_avg_prc_sell =  (hold_avg_prc_CF + hold_avg_prc) if deri_test==0 else position[
											'average_price'] + hold_avg_prc
			else:
				hold_avg_prc == 0

			#menentukan kuantitas per posisi open per instrumen/total instrumen

			hold_longQtyAll_CF      = 0#sum( [ o['size'] for o in [
									   #3            o for o in position_CF if o['side'] == 'long' and  o[
														#           'symbol'][:9][4]=='b']])

			hold_shortQtyAll_CF     =0# sum( [ o['size'] for o in [
									   #              o for o in position_CF if o['side'] == 'short' and o[
										#             'symbol'][:9][4]=='b']])	

			hold_buy_qty	= 0 if deri_test ==0 else  sum([ o['size'] for o in [ o for o in positions if o['direction']== 'buy' and  o['instrument_name']==fut ] ])

			hold_sell_qty	= 0 if deri_test ==0 else  sum([o['size'] for o in [o for o in positions  if o['direction'] == 'sell' and  o['instrument_name']==fut]])
			hold_qty_net		= (hold_buy_qty + hold_sell_qty) if deri_test ==1 else (hold_longQtyAll_CF - hold_shortQtyAll_CF)
			hold_qty_total_net	= 0 if deri_test ==0 else  sum([o['size'
													] for o in [o for o in positions ]])

			#mendapatkan atribut riwayat transaksi deribit vs crypto facilities 
			filledOrder 		= 0 if deri_test == 0 else (
													client_trading.private_get_order_history_by_instrument_get (
													instrument_name=fut, count=10)['result'])									
			try:
				filledOrders_sell_lastTime_max  	= 0 if deri_test== 0 else max( [ o['last_update_timestamp'
													 ] for o in [ o for o in filledOrder if o[
													'direction'] == 'sell'  ] ] )
			except:
				filledOrders_sell_lastTime_max = 0

			try:
				filledOrders_buy_lastTime_max  	= 0 if deri_test== 0 else max( [ o['last_update_timestamp'
													 ] for o in [ o for o in filledOrder if o[
													'direction'] == 'buy'  ] ] )
			except:
				filledOrders_buy_lastTime_max = 0				

			filledOrders_sell_lastTime	= 0 if deri_test== 0 else (
				[o['last_update_timestamp'] for o in [
					o for o in filledOrder if o['direction'] == 'sell' ]])

			filledOrders_buy_lastTime	= 0 if deri_test== 0 else  (
				[o['last_update_timestamp'] for o in [
					o for o in filledOrder if o['direction'] == 'buy' ]])

			filledOrders_sell_openLastTime 	        = 0 if deri_test==0 else ( 0 if filledOrders_sell_lastTime ==[
													]else((time_now - filledOrders_sell_lastTime[0])/1000))

			filledOrders_buy_openLastTime	        = 0 if deri_test==0 else  (0 if filledOrders_buy_lastTime ==[
													]else((time_now - filledOrders_buy_lastTime[0])/1000))

			filledOrders_sell_prc	= []if deri_test== 0 else ([o['price'] for o in [
				o for o in filledOrder if o['direction'] == 'sell' ]])

			filledOrders_buy_prc	= [] if deri_test ==0 else  ([o['price'] for o in [
				o for o in filledOrder if o['direction'] == 'buy' ]])

			filledOrders_sell_prc 	= filledOrders_sell_prc_CF if deri_test ==0 else (
				0 if filledOrders_sell_prc ==[] else filledOrders_sell_prc [0])

			filledOrders_buy_prc    = filledOrders_buy_prc_CF if deri_test==0 else  (
													0 if filledOrders_buy_prc ==[] else filledOrders_buy_prc [0])
			
			#mendapatkan atribut open order deribit vs crypto facilities 

			openOrders_CF           =[]# ( [ o for o in json.loads(cfPrivate.get_openorders(
										#            ))['openOrders'] if   o['symbol']==fut ]  )

			openOrders_CF           = [] if openOrders_CF ==[] else openOrders_CF
			
			openOrders              = openOrders_CF if deri_test==0 else (
                            client_trading.private_get_open_orders_by_instrument_get (
                                instrument_name=fut)['result'])

			
			#menentukan kuantitas per  open order per instrumen

			openOrders_buy_qty 	= 0 if deri_test ==0 else  sum([o['amount'] for o in [
				o for o in openOrders if o['direction'] == 'buy'  ]])

			openOrders_sell_qty	= 0 if deri_test ==0 else  sum([o['amount'] for o in [
				o for o in openOrders if o['direction'] == 'sell'  ]])*-1
	
			openOrders_qty_Net	= 0 if deri_test ==0 else  openOrders_buy_qty + openOrders_sell_qty

			filledOpenOrders_buy_qty_total 	= 0 if deri_test ==0 else  (
											openOrders_buy_qty + hold_buy_qty)

			filledOpenOrders_sell_qty_total = 0 if deri_test ==0 else  (
											openOrders_sell_qty + hold_sell_qty)
			
			filledOpenOrders_qty_totalNet= filledOpenOrders_buy_qty_total + filledOpenOrders_sell_qty_total 

			try:
				openOrders_buy_time_api = max( [ o['creation_timestamp'
				] for o in [ o for o in openOrders if o[
					'direction'] == 'buy'  and  o['api']==True ] ] )
					
			except:
				openOrders_buy_time_api = 0

			try:
				openOrders_sell_time_api  = max( [ o['creation_timestamp'
				] for o in [ o for o in openOrders if o[
					'direction'] == 'sell'  and  o['api']==True ] ] )

			except:
				openOrders_sell_time_api  = 0


			try:
				openOrders_buy_prc_limit= 0 if openOrders_buy_time_api ==0 else ( [ o['price'
				] for o in [ o for o in openOrders if o[
					'creation_timestamp'] == openOrders_buy_time_api  and  o[
						'order_type']=='limit' ] ] [0])                           

			except:
				openOrders_buy_prc_limit = 0

			try:
				openOrders_buy_oid_limit   = [ o['order_id'
				] for o in [ o for o in openOrders if o[
					'creation_timestamp'] == openOrders_buy_time_api  and  o[
						'order_type']=='limit' ] ] [0]                           
			except:
				openOrders_buy_oid_limit  =0

			try:
				openOrders_sell_oid_limit  = [ o['order_id'] for o in [
					o for o in openOrders if o[
						'creation_timestamp'] ==openOrders_sell_time_api  and  o[
							'order_type']=='limit' ]] [0]
			except:
				openOrders_sell_oid_limit=0			

			try:
				openOrders_buy_oid_stopLimit   = [ o['order_id'] for o in [
					o for o in openOrders if o[
						'direction'] == 'buy'  and o['api']==True and o[
							'order_state'] == 'untriggered'  and  o[
								'order_type']=='stop_limit'  ] ] [0]                          
			except:
				openOrders_buy_oid_stopLimit = 0

			try:
				openOrders_sell_prc_limit  = [ o['price'] for o in [
					o for o in openOrders if o[
						'creation_timestamp'] ==openOrders_sell_time_api  and  o[
							'order_type']=='limit']] [0]
			except:
				openOrders_sell_prc_limit=0

			try:
				openOrders_sell_oid_stopLimit  = [ o['order_id'] for o in [
					o for o in openOrders if  o[
						'direction'] == 'sell'  and o['api']==True and o[
							'order_state'] == 'untriggered'  and  o[
								'order_type']=='stop_limit' ]] [0]

			except:
				openOrders_sell_oid_stopLimit	= 0		

			#menghitung kuantitas stop order per instrumen
				#maks stop order 20

			openOrders_buy_qty_stop	= 0 if deri_test ==0 else  sum([o['amount'
			] for o in [o for o in openOrders if o[
				'direction'] == 'buy' and  o['order_type']=='stop_limit' ]])

			openOrders_sell_qty_stop= 0 if deri_test ==0 else  sum([o['amount'
			] for o in [o for o in openOrders if o[
				'direction'] == 'sell' and  o[
					'order_type']=='stop_limit' ]])

			#menghitung kuantitas limit order per instrumen




			#qty individual
			try:
				openOrders_sell_qty_limit_fut  = [ o['amount'] for o in [
					o for o in openOrders if o[
						'creation_timestamp'] == openOrders_sell_time_api  and  o[
							'order_type']=='limit' and  o[
							'direction']=='sell'] ] [0]
			except:
				openOrders_sell_qty_limit_fut=0


			try:
				openOrders_buy_qty_limit_fut  = [ o['amount'] for o in [
					o for o in openOrders if o[
						'creation_timestamp'] == openOrders_buy_time_api  and  o[
							'order_type']=='limit' and  o[
							'direction']=='buy'] ] [0]
			except:
				openOrders_buy_qty_limit_fut=0
                
			openOrders_buy_qty_limit= 0 if deri_test ==0 else  sum([o[
			'amount'] for o in [o for o in openOrders if o[
			'direction'] == 'buy' and  o['order_type']=='limit' ]])

			openOrders_sell_qty_limit= 0 if deri_test ==0 else  sum([o[
			'amount'] for o in [o for o in openOrders if o[
			'direction'] == 'sell' and  o['order_type']=='limit' ]])*-1

			try:
				openOrders_buy_qty_limitLen= 0 if deri_test ==0 else  len ([o[
			'amount'] for o in [o for o in openOrders if o[
			'direction'] == 'buy' and  o['order_type']=='limit' ]]  )

			except:
				openOrders_buy_qty_limitLen  = 0

			try:
				openOrders_sell_qty_limitLen= 0 if deri_test ==0 else  len ([o[
			'amount'] for o in [o for o in openOrders if o[
			'direction'] == 'sell' and  o['order_type']=='limit' ]]  ) *-1

			except:
				openOrders_sell_qty_limitLen  = 0


			#balancing saldo
			try:
				openOrders_sell_oid_limitBal=   max([o['order_id'] for o in [o for o in openOrders if o[
			'direction'] == 'sell' and  o['order_type']=='limit' and  abs(o['amount']) > QTY ]]  )

			except:
				openOrders_sell_oid_limitBal  = 0	 	 

			try:
				openOrders_buy_oid_limitBal=   max([o['order_id'] for o in [o for o in openOrders if o[
			'direction'] == 'buy' and  o['order_type']=='limit' and  o['amount'] > QTY ]]  )

			except:
				openOrders_buy_oid_limitBal  = 0	 	 

			stop_total_qty_fut	= 0 if deri_test ==0 else  (openOrders_buy_qty_stop+ abs(openOrders_sell_qty_stop))

			#menghitung waktu stop order per instrumen ada di platform
				#maks stop order 20
			
			try:
				openOrders_buy_minTime_stopLimit	= 0 if deri_test ==0 else  min([o[
				'creation_timestamp'] for o in [o for o in openOrders if o[
				'direction'] == 'buy' and  o['order_type']=='stop_limit' ]])
			except:
				openOrders_buy_minTime_stopLimit	=0
	
			try:
				openOrders_sell_minTime_stopLimit= 0 if deri_test ==0 else  min([o[
				'creation_timestamp'] for o in [o for o in openOrders if o[
				'direction'] == 'sell' and  o['order_type']=='stop_limit' ]])

			except:
				openOrders_sell_minTime_stopLimit=0

			nbids           =  1
			nasks           =  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1


			bid_prc_fut         = 0 if deri_test==0 else ( [ o['bid_price'] for o in [o for o in instsB if o[
                            'instrument_name'] == stamp_new  ] ] )[0]
			ask_prc_fut         = 0 if deri_test==0 else ( [ o['ask_price'] for o in [o for o in instsB if o[
                            'instrument_name'] == stamp_new   ] ] )[0]

			bid_prc_perp         = 0 if deri_test==0 else ( [ o['bid_price'] for o in [o for o in instsB if o[
                            'instrument_name'][-10:] == '-PERPETUAL'  ] ] )[0]
			ask_prc_perp         = 0 if deri_test==0 else ( [ o['ask_price'] for o in [o for o in instsB if o[
                            'instrument_name'] [-10:]== '-PERPETUAL'  ] ] )[0]
			
			cutloss_prc_sell = 0
			cutloss_prc_buy = 0
			

			ob1              =   client_market.public_get_book_summary_by_currency_get(currency='BTC', kind='future')['result']

			#cutloss_ask_prc
			#hold_sell_qty	= 0 if deri_test ==0 else  sum([o['ask_price'] for o in [o for o in ob1   if o['direction'] == 'sell' and  o['instrument_name']==fut]])

			#QTY di tangan

			hold_buy_qty_cl	= 0 if deri_test ==0 else  sum([o['size'] for o in [
                            o for o in positions if o['direction'] == 'buy' ]])

			hold_sell_qty_cl    = 0 if deri_test ==0 else  sum([o['size'] for o in [
                            o for o in positions  if o['direction'] == 'sell' ]])

			#prc average
			hold_buy_avg_prc_cl	= 0 if deri_test ==0 else  sum([o['average_price'] for o in [
                            o for o in positions if o['direction'] == 'buy' ]])

			hold_sell_avg_prc_cl    = 0 if deri_test ==0 else  sum([o['average_price'] for o in [
                            o for o in positions  if o['direction'] == 'sell' ]]) 			
			
			for i in range(max(nbids, nasks)):
        
				#PILIHAN INSTRUMEN
				#perpetual= diarahkan posisi sell karena funding cenderung berada di sell
				#lawannya, future dengan tanggal jatuh tempo terlama (mengurangi resiko forced sell)-->1
				#future tersisa dipakai sebagai pengimbang/anti likuidasi-->0#menentukan kuantitas per transaksi

				if  perp_test== 1 or fut_test==1:

					#menghitung waktu open di order book
					open_time_buy = 0 if openOrders_buy_time_api ==0 else ((time_now)-  time.mktime(datetime.strptime(
						[o['receivedTime']for o in openOrders_CF][0
						],'%Y-%m-%dT%H:%M:%S.%fZ').timetuple())*1000
						) if deri_test==0 else (time_now/1000- (
							openOrders_buy_time_api)/1000)

					open_time_sell = 0 if openOrders_sell_time_api ==0 else ((time_now)-  time.mktime(datetime.strptime(
						[o['receivedTime']for o in openOrders_CF][0
						],'%Y-%m-%dT%H:%M:%S.%fZ').timetuple())*1000
						) if deri_test==0 else (time_now/1000- (
							openOrders_sell_time_api)/1000)

					#menghitung waktu terakhir kali order dieksekusi, openOrders_CF=dibenerin nanti
					filled_time_buy = 0 if filledOrders_buy_lastTime_max ==0 else  ((time_now)-  time.mktime(datetime.strptime(
						[o['receivedTime']for o in openOrders_CF][0
						],'%Y-%m-%dT%H:%M:%S.%fZ').timetuple())*1000
						) if deri_test==0 else (time_now/1000- (
						filledOrders_buy_lastTime_max)/1000)

					filled_time_sell = 0 if filledOrders_sell_lastTime_max ==0 else  ((time_now)-  time.mktime(datetime.strptime(
						[o['receivedTime']for o in openOrders_CF][0
						],'%Y-%m-%dT%H:%M:%S.%fZ').timetuple())*1000
						) if deri_test==0 else (time_now/1000- (
						filledOrders_sell_lastTime_max)/1000)

#				print(sub_name,fut,'time_now/1000',time_now/1000,
#				'openOrders_buy_time_api',openOrders_buy_time_api,'openOrders_sell_time_api',openOrders_sell_time_api)
				WAIT_TIME=600
				if  abs (hold_sell_qty_cl) == QTY:
					WAIT_TIME = WAIT_TIME + (WAIT_TIME * MARGIN*10)
				elif  abs (hold_sell_qty_cl) <= QTY*2:
					WAIT_TIME = WAIT_TIME + (WAIT_TIME * MARGIN*20)
				elif  abs (hold_sell_qty_cl) <= QTY*4:
					WAIT_TIME = WAIT_TIME + (WAIT_TIME * MARGIN*40)
				elif  abs (hold_sell_qty_cl) <= QTY*8:
					WAIT_TIME = WAIT_TIME + (WAIT_TIME * MARGIN*80)
				elif  abs (hold_sell_qty_cl) <= QTY*16:
					WAIT_TIME = WAIT_TIME + (WAIT_TIME * MARGIN*160)
				elif  abs (hold_sell_qty_cl) <= QTY*32:
					WAIT_TIME = WAIT_TIME + (WAIT_TIME * MARGIN*320)
				else:
					WAIT_TIME = 0

							#batasan transaksi
				place_bids = 'true'
				place_asks = 'true'
				place_bids  =  equity==True  and (perp_test== 1 or fut_test==1)
				place_asks  =   equity==True  and (perp_test== 1 or fut_test==1)
				delta_prc=  MARGIN/20

				delta_time_buy= max (filled_time_buy,open_time_buy)  if (
					filled_time_buy == 0 or open_time_buy ==0) else min (filled_time_buy,open_time_buy)
				delta_time_sell= max (filled_time_sell,open_time_sell) if (
					filled_time_sell ==0 or open_time_sell==0) else min (filled_time_sell,open_time_sell)

				
				#order tidak dieksekusi >280 detik
				#seluruh stop limit yg belum ditrigger
				#limit, sesuai dengan lawan masing2 default

				#tujuan:
				#hanya ada satu pasangan stop-stop limit di satu waktu
			
				print(BLUE + str((fut,'CANCEL1','open_time_buy',open_time_buy,'open_time_sell',open_time_sell)),ENDC)
				print(BLUE + str((fut,'CANCEL2','open_time_buy',open_time_buy,'open_time_sell',open_time_sell)),ENDC)

				print(BLUE + str((fut,'cancel3','WAIT_TIME',WAIT_TIME,
								'open_time_buy',open_time_buy,'open_time_sell',open_time_sell,
								'openOrders_buy_qty_limit_fut',openOrders_buy_qty_limit_fut)),ENDC)
				print(BLUE + str((fut,'cancel4','WAIT_TIME',WAIT_TIME,'open_time_buy',
								open_time_buy,'open_time_sell',open_time_sell,
								'openOrders_sell_qty_limit_fut',openOrders_sell_qty_limit_fut)),ENDC)
				if open_time_buy >180 or open_time_sell >180:# and api ==True:
					if deri_test == 1 :
						#openOrders_sell_oid_limit  !=0 = mengecek open order sudah tereksekusi/belum							
						if  perp_test==1 and openOrders_buy_oid_stopLimit  !=0:                                                   
							client_trading.private_cancel_get(openOrders_buy_oid_stopLimit)
							client_trading.private_cancel_get(openOrders_sell_oid_limit)
							print(BLUE + str((fut,'cancel1','open_time_buy',open_time_buy,'open_time_sell',open_time_sell)),ENDC)
   
						elif  fut_test==1 and  openOrders_sell_oid_stopLimit !=0:                                                   
							client_trading.private_cancel_get(openOrders_sell_oid_stopLimit)
							client_trading.private_cancel_get(openOrders_buy_oid_limit)
							print(BLUE + str((fut,'cancel2','open_time_buy',open_time_buy,'open_time_sell',open_time_sell)),ENDC)

						if  open_time_buy > WAIT_TIME  or  open_time_sell > WAIT_TIME:													
							if openOrders_buy_qty_limit_fut == QTY :                                                   
								client_trading.private_cancel_get(openOrders_buy_oid_limit)
								print(BLUE + str((fut,'cancel3','WAIT_TIME',WAIT_TIME,
								'open_time_buy',open_time_buy,'open_time_sell',open_time_sell,
								'openOrders_buy_qty_limit_fut',openOrders_buy_qty_limit_fut)),ENDC)

							if abs(openOrders_sell_qty_limit_fut) == QTY:                                                   
								client_trading.private_cancel_get(openOrders_sell_oid_limit)
								print(BLUE + str((fut,'cancel4','WAIT_TIME',WAIT_TIME,'open_time_buy',
								open_time_buy,'open_time_sell',open_time_sell,
								'openOrders_sell_qty_limit_fut',openOrders_sell_qty_limit_fut)),ENDC)

					elif deri_test == 0:
						cfPrivate.cancel_order(oid)


				if  openOrders_buy_qty_limit > (QTY * 5):	
					client_trading.private_cancel_get(openOrders_buy_oid_limitBal)                                                   
					print(BLUE + str((fut,'cancel5','openOrders_buy_qty_limit',openOrders_buy_qty_limit)),ENDC )

				if  abs(openOrders_sell_qty_limit) > (QTY * 5):	
					client_trading.private_cancel_get(openOrders_sell_oid_limitBal)                                                   
					print(BLUE + str((fut,'cancel6','openOrders_sell_qty_limit',openOrders_sell_qty_limit)),ENDC )

				print(sub_name,fut,'open_time_buy',open_time_buy,'open_time_sell',open_time_sell,
				'filled_time_buy',filled_time_buy,'filled_time_sell',filled_time_sell)
						
	
				if place_bids:

					if deri_test == 1:
    						#perp_test/fut_test==1 =hanya perpetual/fut terlama yang bisa posisi short/long
							# #openOrders_sell_prc_limit !=0 = mencegah error akibat prc masih 0 pada saat memulai posisi
							# #openOrders_buy_qty_stop <10 = hanya boleh ada 1 posisi stop limit per 5 menit
							# #openenOrders_buy_qty==0
											
						prc=   openOrders_sell_prc_limit-(delta_prc * openOrders_sell_prc_limit)
						stop_prc_perp=   max( ask_prc,( float(openOrders_sell_prc_limit+(0.5 if fut [:3]=='BTC' else .05) ) ) )

						print(BLUE + str((fut, 'TEST STOP LIMIT PERP','openOrders_buy_qty_stop',openOrders_buy_qty_stop,
						'openOrders_sell_prc_limit',openOrders_sell_prc_limit,'openOrders_sell_qty_limit_fut',
						openOrders_sell_qty_limit_fut,openOrders_buy_qty_stop < QTY and (
							openOrders_sell_prc_limit !=0) and abs(openOrders_sell_qty_limit_fut) == QTY)),ENDC)
						
						print(fut, 'delta_time_buy',delta_time_buy,'delta_time_sell',delta_time_sell,
						'filled_time_buy',filled_time_buy,'open_time_buy',open_time_buy,'filled_time_sell',filled_time_sell,
						'open_time_sell',open_time_sell)
						
						print(GREEN + str((sub_name,fut,'TEST LIMIT FUT','openOrders_buy_qty_limit',openOrders_buy_qty_limit,'hold_buy_qty_cl',
								hold_buy_qty_cl,'WAIT_TIME',WAIT_TIME,'min(filled_time_sell,open_time_buy)',
								delta_time_buy,open_time_buy)),ENDC)

						if   perp_test==1 :

							#NORMAL, stop limit seketika setelah eksekusi order
							
							if  openOrders_buy_qty_stop < QTY and (#openOrders_buy_qty_stop < QTY : hanya ada 1 stoplimit
								openOrders_sell_prc_limit !=0) and abs(#openOrders_sell_prc_limit : open oredrnya ada
									openOrders_sell_qty_limit_fut) == QTY: #openOrders_sell_qty_limit_fut : terkait dg order baru, bkn avg down

								client_trading.private_buy_get(
									instrument_name =fut ,
									amount          = QTY,
									price           =prc,
									stop_price      =stop_prc_perp,
									type            ='stop_limit',
									trigger         ='last_price',
									post_only       ='true',
									reduce_only     ='false'
									)

								print(GREEN + str((sub_name,fut,'fut_test==1','AAA','openOrders_buy_qty_stop',openOrders_buy_qty_stop,
								'openOrders_sell_prc_limit',openOrders_sell_prc_limit,'openOrders_sell_qty_limit_fut',
								openOrders_sell_qty_limit_fut,'stop_prc_perp',stop_prc_perp,'ask_prc',ask_prc,(
									 float(openOrders_sell_prc_limit+(0.5 if fut [:3]=='BTC' else .05) )))) ,ENDC)

							#NORMAL, bila limit diekseskusi, tetapi stop_limit kesangkut.
								#Atau bila ada kesalahan eksekusi apa pun,
								#langsung dibuatkan lawan dari transaksi terakhir
								#filledOpenOrders_qty_totalNet = gabungan open + hold
							
							elif openOrders_buy_qty_limit < hold_sell_qty_cl and (
									openOrders_buy_qty_limitLen < (QTY*5)) and abs(hold_sell_qty_cl) > 0:   
								print(GREEN + str((sub_name,fut,'fut_test==1','BBB',
								'filledOpenOrders_qty_totalNet',filledOpenOrders_qty_totalNet,
								'openOrders_sell_qty_stop',openOrders_sell_qty_stop,'openOrders_buy_qty_limitLen',openOrders_buy_qty_limitLen)),ENDC)

								client_trading.private_buy_get(
									instrument_name =fut,
									 reduce_only     ='false',
									 type            ='limit',
									 price           =min(
										 filledOrders_sell_prc if abs(hold_avg_prc_sell) <1 else hold_avg_prc_sell ,abs(
										filledOrders_sell_prc)) -(delta_prc *abs( filledOrders_sell_prc)),
                                    post_only       ='true',
									amount          =QTY
									)	

							#memastikan hanya ada 1 order setiap waktu
							elif  openOrders_buy_qty_stop >QTY :
								print(BLUE + str(('1 order setiap waktu','openOrders_buy_qty_stop',openOrders_buy_qty_stop)),ENDC)
								client_trading.private_cancel_get(openOrders_buy_oid_stopLimit)

							#pengimbang AVG DOWN, 						
							elif  (abs(hold_sell_qty_cl)-abs(openOrders_buy_qty_limit)) > QTY and (
                                openOrders_buy_qty_limitLen) < 5:                                                   

								print(GREEN + str((sub_name,fut,'fut_test==1','CCC','(hold_sell_qty_cl-abs(openOrders_buy_qty_limit))',
								abs((hold_sell_qty_cl)-abs(openOrders_buy_qty_limit)),'openOrders_buy_qty_limitLen',openOrders_buy_qty_limitLen,
									'hold_avg_prc_sell-(hold_avg_prc_sell * MARGIN * .7)',
								hold_avg_prc_sell-(hold_avg_prc_sell * MARGIN * .7))),ENDC)
								

#pesan 2 x? openOrders_sell_qty_limitMax
								client_trading.private_buy_get(
									instrument_name =fut,
									reduce_only     ='false',
									type            ='limit',
									price           =int(hold_avg_prc_sell-(hold_avg_prc_sell * MARGIN * .7)) ,
									post_only       ='true',
									amount          =(abs(hold_sell_qty_cl)-abs(openOrders_buy_qty_limit))
									)	

								print(GREEN + str((sub_name,fut,'fut_test==1','CCC','(hold_sell_qty_cl-abs(openOrders_buy_qty_limit))',
								abs((hold_sell_qty_cl)-abs(openOrders_buy_qty_limit)),'openOrders_buy_qty_limitLen',openOrders_buy_qty_limitLen,
									'hold_avg_prc_sell-(hold_avg_prc_sell * MARGIN * .7)',
								hold_avg_prc_sell-(hold_avg_prc_sell * MARGIN * .7))),ENDC)
								

						elif  fut_test==1 and openOrders_buy_qty == 0:#or open_time ==0

							#NORMAL,, pasang posisi beli pada QTY =0  					                                                    							
							if  (abs(openOrders_buy_qty_limit) < (QTY * 6) and (
								delta_time_buy > WAIT_TIME)) or hold_buy_qty_cl ==0:
								client_trading.private_buy_get(
									instrument_name=fut,
									amount=QTY,
									price=bid_prc ,
									type='limit',
									reduce_only='false',
									post_only='true'
									)		
								print(GREEN + str((sub_name,fut,'fut_test==1',
								'EEE','openOrders_buy_qty_limit',openOrders_buy_qty_limit,'hold_buy_qty_cl',
								hold_buy_qty_cl,'WAIT_TIME',WAIT_TIME,'delta_time',
								delta_time_buy)),ENDC)


					elif deri_test == 0:
						cfPrivate.send_order_1(limit_order)
	
				# OFFERS

				if place_asks:

					if deri_test == 1:
	  
						stop_prc_fut=   min( bid_prc,float (openOrders_buy_prc_limit-(
							0.5 if fut [:3]=='BTC' else .05) ) )
						print(sub_name,fut,'stop_prc_fut',stop_prc_fut,
						'openOrders_buy_prc_limit',openOrders_buy_prc_limit,'bid_prc',bid_prc,(openOrders_buy_prc_limit-(
							0.5 if fut [:3]=='BTC' else .05) ))
						prc=   openOrders_buy_prc_limit+(delta_prc * openOrders_buy_prc_limit)

						print(BLUE + str((fut, 'TEST STOP LIMIT FUT','openOrders_sell_qty_stop',openOrders_sell_qty_stop,
						'openOrders_buy_prc_limit',openOrders_buy_prc_limit,'openOrders_buy_qty_limit_fut',
						openOrders_buy_qty_limit_fut,abs(openOrders_sell_qty_stop) < QTY and (
							openOrders_buy_prc_limit !=0) and abs(openOrders_buy_qty_limit_fut) == QTY)),ENDC)

						print(RED + str((sub_name,fut,'TEST  LIMIT PERP','abs(openOrders_sell_qty_limit)',
								abs(openOrders_sell_qty_limit),'delta_time',
								delta_time_sell,'WAIT_TIME',WAIT_TIME,'hold_sell_qty_cl',abs(hold_sell_qty_cl))),ENDC)

						if   fut_test==1 : 
							#NORMAL, stop limit seketika setelah eksekusi order
							
							if abs(openOrders_sell_qty_stop) < QTY and (#abs(openOrders_sell_qty_stop) < QTY : hanya ada 1 stoplimit
								openOrders_buy_prc_limit !=0) and abs(#openOrders_buy_prc_limit : open oredrnya ada
									openOrders_buy_qty_limit_fut) == QTY: #openOrders_buy_qty_limit_fut : terkait dg order baru, bkn avg down

								print(RED + str((sub_name,fut,'fut_test==1','111','abs(openOrders_sell_qty_stop)',abs(openOrders_sell_qty_stop),
								'openOrders_buy_qty_limit_fut',openOrders_buy_qty_limit_fut,'stop_prc_fut',
								stop_prc_fut,float (openOrders_buy_prc_limit-(
							0.5 if fut [:3]=='BTC' else .05) ))),ENDC)

								client_trading.private_sell_get(
									instrument_name=fut,
									amount=QTY,
									price=prc,
									stop_price=stop_prc_fut,
									type            ='stop_limit',
									trigger         ='last_price',
									post_only       ='true',
									reduce_only     ='false'
									)
									
							#normal, bila limit diekseskusi, tetapi stop_limit kesangkut.
								#Atau bila ada kesalahan eksekusi apa pun,
								#langsung dibuatkan lawan dari transaksi terakhir

							elif  abs(openOrders_sell_qty_limit) < hold_buy_qty_cl and abs(
								openOrders_sell_qty_limitLen ) < QTY*5 and hold_buy_qty_cl >0:													

								client_trading.private_sell_get(
									instrument_name=fut,
									reduce_only='false',
									type='limit',
									price=max(hold_avg_prc_buy,filledOrders_buy_prc)+(
										delta_prc*filledOrders_buy_prc),
									post_only='true',
									amount=QTY)	

								print(RED + str((sub_name,fut,'fut_test==1','222','openOrders_sell_qty_limit',
								openOrders_sell_qty_limit,'hold_buy_qty_cl',hold_buy_qty_cl,
								abs(openOrders_sell_qty_limitLen),'hold_avg_prc_buy',hold_avg_prc_buy,'filledOrders_buy_prc',filledOrders_buy_prc,
								'max(hold_avg_prc,filledOrders_buy_prc)+(delta_prc*filledOrders_buy_prc)',max(hold_avg_prc_buy,filledOrders_buy_prc),
								max(hold_avg_prc_buy,filledOrders_buy_prc)+(
										delta_prc*filledOrders_buy_prc))),ENDC)

							#memastikan hanya ada 1 order setiap waktu
							elif  abs(openOrders_sell_qty_stop) > QTY :
								print(BLUE + str(('1 order setiap waktu','openOrders_sell_qty_stop',openOrders_sell_qty_stop)),ENDC)

								client_trading.private_cancel_get(openOrders_sell_oid_stopLimit)

							#pengimbang AVG UP
							elif  hold_buy_qty_cl - abs(openOrders_sell_qty_limit) > QTY and abs(
                                openOrders_sell_qty_limitLen) < 5:
#pesan 2 x/pakai len??																		
								client_trading.private_sell_get(
									instrument_name=fut,
									reduce_only='false',
									type='limit',
									price=int(hold_avg_prc_buy+(hold_avg_prc_buy*MARGIN * .7)),
									post_only='true',
									amount=(hold_buy_qty_cl-abs(openOrders_sell_qty_limit))
									)	

								print(RED + str((sub_name,fut,'fut_test==1','333','hold_buy_qty_cl',
								hold_buy_qty_cl,'hold_buy_qty_cl - abs(openOrders_sell_qty_limit)',hold_buy_qty_cl - abs(openOrders_sell_qty_limit),
								'(hold_buy_qty_cl-abs(openOrders_sell_qty_limit))',(hold_buy_qty_cl-abs(openOrders_sell_qty_limit)),
								hold_avg_prc_buy+(hold_avg_prc_buy*MARGIN * .7))),ENDC)

						elif   perp_test==1 and openOrders_sell_qty == 0 :
                        
							#NORMAL,, pasang posisi beli pada QTY =0  					                                                    							
							if (abs(openOrders_sell_qty_limit) < (QTY * 6) and (
								delta_time_sell > WAIT_TIME)) or abs(hold_sell_qty_cl) ==0 :

								print(RED + str((sub_name,fut,'555','abs(openOrders_sell_qty_limit)',
								abs(openOrders_sell_qty_limit),'min(filled_time_sell,open_time_buy)',
								delta_time_sell,'WAIT_TIME',WAIT_TIME,'hold_sell_qty_cl',abs(hold_sell_qty_cl))),ENDC)

								client_trading.private_sell_get(
									instrument_name=fut,
									reduce_only='false',
									type='limit',
									price=ask_prc ,
									post_only='true',
									amount=QTY
									)	


	
					elif deri_test == 0:
						cfPrivate.send_order_1(limit_order)

				counter= get_time - (stop_unix/1000)
                
				if counter > (12 if equity !=0 else 0):# if deri_test ==1 else 10:
					while True:
						self.restart_program()
						break
				
				#print(sub_name,fut,'counter',counter)

#	positions       =client_account.private_get_positions_get(currency='BTC', kind='future')['result']
	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

	def report(self):

#		positions       =client_account.private_get_positions_get(currency='BTC', kind='future')['result']
#		df=pd.DataFrame(positions).drop(columns=['maintenance_MARGIN','realized_funding','initial_MARGIN','kind','leverage','index_price','settlement_price','total_profit_loss','size_currency','delta','floating_profit_loss','open_orders_MARGIN','realized_profit_loss'])
#		df = df.rename(columns =   {'direction':'dir','mark_price':'market','average_price':'avg_prc','estimated_liquidation_price':'liq_prc','instrument_name':'instrument'})
#		df = df['avg_prc'].round(decimals=0)
#		df = int(df.round())
#		df.astype(int, errors='ignore')
#		pd.to_numeric(pd.Series(df), errors='coerce')
#
#		account         = (client_account.private_get_account_summary_get(currency='BTC', extended='true')['result'])

			#mendapatkan nama akun deribit vs crypto facilities
#		sub_name        =  account ['username']
#		waktu = datetime.now()
		#df.round(0).astype(int)

#		my_message = "{}" "-" "{}" '\n' "{}".format(
#					waktu,sub_name,df)#.round(0).astype(int))
		#		self.telegram_bot_sendtext(my_message)
		self.telegram_bot_sendtext(my_message)

	def run(self):

		self.run_first()

		while True:

			self.get_futures()
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
		#self.symbols = [BTC_SYMBOL] + list(self.futures.keys())

if __name__ == '__main__':

	try:
		mmbot = MarketMaker(monitor=args.monitor, output=args.output)
		mmbot.run()
	except(KeyboardInterrupt, SystemExit):
#		mmbot.report()
		print(traceback.format_exc())
		sys.exit()
	except:
#		mmbot.report()
		print(traceback.format_exc())
		if args.restart:
			mmbot.run()
