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
import cfRestApiV3 as cfApi
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

#c0t8sxtj@futures-demo.com
#wpnjckpwaxacphzm78du

apiPath = "https://www.cryptofacilities.com/derivatives"
#apiPath = "https://conformance.cryptofacilities.com/derivatives"#"https://www.cryptofacilities.com/derivatives"
apiPublicKey = "PlRnNMw9jpQw1Cnxel99eVqjAp00fCypDdc4zC4godZJa91Y4UXfMHMz"#"lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
#apiPrivateKey ="3k8j0gangNZ/+B0Zxi8WNfpd+6ETXfJf+f/sD3H+K6dolQ5dlw4EtK6VzZxU7LqjktZVgHSdosdT7qxZKcU5sK/Q"#"ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"# aeaE+g+JMQqXIRu5YhWTCrIldZBd6WZt95tlqiFynmRmFogpDcmZALUsmhLnkaGGx+DZ9ueG54YVIqjZFVDEPaaD"  # accessible on your Account page under Settings -> API Keys
apiPrivateKey ="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"# aeaE+g+JMQqXIRu5YhWTCrIldZBd6WZt95tlqiFynmRmFogpDcmZALUsmhLnkaGGx+DZ9ueG54YVIqjZFVDEPaaD"  # accessible on your Account page under Settings -> API Keys
apiPublicKey = "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
timeout = 5
checkCertificate = True if apiPath == "https://www.cryptofacilities.com/derivatives" else False # False# # when using the test environment, this must be set to "False"
useNonce = False  # nonce is optional

cfPublic = cfApi.cfApiMethods(apiPath, timeout=timeout, checkCertificate=checkCertificate)
cfPrivate = cfApi.cfApiMethods(apiPath, timeout=timeout, apiPublicKey=apiPublicKey, apiPrivateKey=apiPrivateKey, checkCertificate=checkCertificate, useNonce=useNonce)

chck_key=str(int(openapi_client.PublicApi(openapi_client.ApiClient(openapi_client.Configuration())).public_get_time_get()['result']/1000))[8:9]*1

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


#mwa9
if  chck_key == '1'or chck_key=='3' or chck_key=='5' or chck_key=='7' or chck_key=='9':
	key = "_zEH40KQ"
	secret = "UJoBPSraxZvVzM42MMjiygTYUzKoSu3skyG2EE7wN90"

#mwa8
elif  chck_key == '0'or chck_key=='2' or chck_key=='4' or chck_key=='6' or chck_key=='8':
    
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

STOP_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 30, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(STOP_TIME.timetuple())*1000
MARGIN      = 1/100
IDLE_TIME   = 90000
LOG_LEVEL   = logging.INFO

# 5 minutes, wait time in ms


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

def time_conversion( waktu ):

	time_now        =	time.mktime(STOP_TIME.timetuple())
	conv_formula	=  	time.mktime (datetime.strptime(waktu,'%Y-%m-%dT%H:%M:%S.%fZ').timetuple() )
	konversi 		= 	time_now - conv_formula

	return konversi

def color(masukan):  

	RED   = '\033[1;31m'#Sell
	BLUE  = '\033[1;34m'#information
	CYAN  = '\033[1;36m'#execution (non-sell/buy)
	GREEN = '\033[0;32m'#blue
	RESET = '\033[0;0m'
	BOLD    = "\033[;1m"
	REVERSE = "\033[;7m"
	ENDC = '\033[m' #self.futures_prv = cp.deepcopy(self.futures)
	printblue=print (BLUE + str( (masukan)),ENDC)
	printred=print (RED + str( (masukan)),ENDC)
	printcyan=print (CYAN + str( (masukan)),ENDC)
	printgreen=print (GREEN + str( (masukan)),ENDC)
	printreset=print (RESET + str( (masukan)),ENDC)
	printbold=print (BOLD + str( (masukan)),ENDC)
	printreverse=print (REVERSE + str( (masukan)),ENDC)
	return { 'printblue': printblue, 'printred': printred }


def telegram_bot_sendtext(bot_message):

	bot_token   = '1035682714:AAGea_Lk2ZH3X6BHJt3xAudQDSn5RHwYQJM'
	bot_chatID  = '148190671'
	send_text   = 'https://api.telegram.org/bot' + bot_token + (
								'/sendMessage?chat_id=') + bot_chatID + (
							'&parse_mode=Markdown&text=') + bot_message

	response    = requests.get(send_text)

	return response.json()


class MarketMaker(object):

	def __init__(self, monitor=True, output=True):

		self.client = None
		self.client_trading = None
		self.client_public = None
		self.client_private = None
		self.client_market = None
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
        
		self.futures = sort_by_key({i['instrument_name']: i for i in (instsB)})		

		#deri                    = deribit
		#CF                   = crypto facilities

		deri                    = list(self.futures.keys())
		get_instruments_CF           = json.loads(cfPublic.getinstruments())['instruments']
		instruments_all_CF                 = [ o['symbol'] for o in[o for o in get_instruments_CF if o[
			'symbol'][3:][:3]=='xbt' and len(o['symbol'])<=16 and o['symbol'
				][:1] == 'f' or o['symbol'] == 'pi_xbtusd' or (
				o['symbol'][3:][:3]=='xrp' and o['symbol'][3:][3:][:3] !='usd'and  (
					o['symbol'][:1] == 'f' or o['symbol'] == 'pv_xrpxbt'))  ]]
		
		instruments_xbt                 = [ o['symbol'] for o in[o for o in get_instruments_CF if o[
			'symbol'][3:][:3]=='xbt' and len(o['symbol'])<=16 and o['symbol'
				][:1] == 'f' or o['symbol'] == 'pi_xbtusd'   ]]			
		
		instruments_xrp                 = [ o['symbol'] for o in[o for o in get_instruments_CF if (
				o['symbol'][3:][:3]=='xrp' and o['symbol'][3:][3:][:3] !='usd'and  (
					o['symbol'][:1] == 'f' or o['symbol'] == 'pv_xrpxbt'))  ]]

		instruments_list= (list((  instruments_all_CF  )))#deri + xbt_CF + y) ))
		print('instruments_list',instruments_list)
        		
		for fut in instruments_list:
			#membagi deribit vs crypto facilities

			deri_test       = 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1
			[instrument]= ['symbol'] if deri_test ==0 else ['instrument_name']
			[unfilledSize]= ['unfilledSize'] if deri_test ==0 else  ['size']		
			[filledSize]=  ['filledSize']  if deri_test ==0 else ['size']	
			[size]=  ['size']  
			[side]= ['side'] if deri_test ==0 else ['direction']
			[price]= ['price'] if deri_test ==0 else ['price']
			[limitPrice]= ['limitPrice'] if deri_test ==0 else ['price']
			[stopPrice]= ['stopPrice'] if deri_test ==0 else ['price']			
			[avgPrc]= ['price'] if deri_test ==0 else ['avgPrc']	#CF?
			[fillTime]=  ['fillTime'] if deri_test ==0 else   ['creation_timestamp']
			[last_update_timestamp]=  ['lastUpdateTime'] if deri_test ==0 else ['last_update_timestamp']	
			[orderType]=  ['orderType'] if deri_test ==0 else ['orderType']	
			[order_id]=  ['order_id'] if deri_test ==0 else ['order_id']	
			[order_status]=  (['status']) if deri_test ==0 else ['order_status']
			buy         =('buy' or 'buy')
			sell        =('sell' or 'sell') 
			longs         =('long'  if deri_test ==0 else 'buy')
			short         =('short'  if deri_test ==0 else 'buy')
			limit    =('lmt'  if deri_test ==0 else 'limit' ) 
			stop    =('stop' if deri_test ==0 else 'stop') 
			curr    = fut [3:][:3] #'xbt'/'xrp')
			TICK= ([o['tickSize']  for o in [o for o in get_instruments_CF if  
				o['symbol']==fut]] [0]) if deri_test == 0 else (1/2)

			#mendapatkan atribut isi akun deribit vs crypto facilities
			account_CF      =json.loads(cfPrivate.get_accounts())['accounts']['fi_xbtusd']
			account         = account_CF if deri_test == 0 else (
                                client_account.private_get_account_summary_get(
                                        currency=(fut[:3]), extended='true')['result'])

			#mendapatkan nama akun deribit vs crypto facilities
			sub_name        = 'CF' if deri_test == 0 else account ['username']

			stamp       =[0] if deri_test==0 else  [o[instrument]  for o in [o for o in instsB if  len(o[instrument])==11 
                                                    ]]
			stamp_new= 0 if deri_test==0 else (  min( (stamp)[0],(stamp)[1]))

			perp_test_xbt   =(1 if max(instruments_xbt)==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)
			perp_test_xrp   =(1 if max(instruments_xrp)==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)
			
			perp_test_CF    =perp_test_xbt if curr== 'xbt' else perp_test_xrp
			
			perp_test   =perp_test_CF if deri_test ==0 else (1 if fut [-10:] == '-PERPETUAL' else 0)

			fut_test_xbt =( 1 if ( max(instruments_xbt) != fut and min(instruments_xbt) != fut  ) else 0 )
			fut_test_xrp =( 1 if ( min(instruments_xrp) == fut  ) else 0 ) 

			fut_test_CF    =fut_test_xbt if curr== 'xbt' else fut_test_xrp
			
			fut_test    =fut_test_CF if deri_test==0 else (1 if stamp_new == fut  else 0)

			waktu           = datetime.now()

			time_now        =(time.mktime(datetime.now().timetuple())*1000)
			get_time        = client_public.public_get_time_get()['result']/1000
			prc         =0
			QTY         = 10 if fut [:3]=='BTC' else 100#
			QTY         = 10 if fut [:3]=='BTC'and fut_test==1 else QTY#
			QTY         = 10 if fut [:3]=='BTC'and fut_test==1 and  sub_name== 'MwaHaHa_5' else QTY#
			QTY         = 10 if sub_name=='MwaHaHa_8' else QTY#
			QTY         = 50 if sub_name=='CF' else QTY#
			QTY         = 5 if fut[3:][:3]=='xrp'else QTY#

			#mendapatkan isi ekuitas deribit vs crypto facilities (ada/tidak collateral)
			equity          = account_CF['balances']['xbt']>0
			
			equity          =   equity if deri_test == 0 else ( account['equity'
			] >0 and account ['currency']==fut [:3] )
			
			#mendapatkan isi order book deribit vs crypto facilities 				
			ob              = json.loads(cfPublic.getorderbook(
				fut.upper()))['orderBook'
				] if deri_test==0 else  client_market.public_ticker_get(fut)['result']
	
			bid_prc         = ob['best_bid_price'] if deri_test == 1 else ob ['bids'][0][0]
			ask_prc         = ob ['best_ask_price'] if deri_test == 1 else ob ['asks'][0][0]

			bid_prc_fut         = (ask_prc - TICK) if deri_test==0 else (( [ o['ask_price'] for o in [
				o for o in instsB if o[instrument] == stamp_new and o[instrument] == fut   ] ] )[0])- TICK
		
			ask_prc_fut         =  (bid_prc + TICK) if deri_test==0 else (( [ o['bid_price'] for o in [
				o for o in instsB if o[instrument] == stamp_new  and o[instrument] == fut] ] )[0])+ TICK

			bid_prc_perp         =  (ask_prc - TICK) if deri_test==0 else ( [ o['bid_price'] for o in [
				o for o in instsB if o[instrument][-10:] == '-PERPETUAL' and o[instrument] == fut ] ] )[0]
			ask_prc_perp         = (bid_prc + TICK) if deri_test==0 else ( [ o['ask_price'] for o in [
				o for o in instsB if o[instrument] [-10:]== '-PERPETUAL' and o[instrument] == fut ] ] )[0]
			#mendapatkan transaksi terakhir deribit vs crypto facilities 

			last_prc_CF     = json.loads(cfPrivate.get_fills())['fills']

			#mendapatkan atribut posisi  deribit vs crypto facilities 
			try:
				position_CF= json.loads(cfPrivate.get_openpositions(
							        ))['openPositions']
			except:
				position_CF=0
			
			position_CF       = 0 if position_CF == 0 else [ o for o in[o for o in position_CF if o[
                    'symbol'][3:][:3]==fut [3:][:3]  ]]

			positions       = position_CF if deri_test == 0 else  (
				client_account.private_get_positions_get(currency=(fut[:3]
				), kind='future')['result'])
			
			position        = position_CF if deri_test == 0 else (
				client_account.private_get_position_get(fut)['result'])

			try:
				symbol  =( 0 if positions == 0 else [ o[instrument] for o in[o for o in position if o[
                    instrument]==fut]] [0]) if deri_test == 0 else 0

			except:
				symbol=0

			direction_CF    = ( 0 if symbol == 0 else [ o [size] for o in[o for o in positions if o[
				instrument]==fut]] [0]) 

			#mendapatkan kuantitas posisi open deribit vs crypto facilities 

						   #tes apakah ada saldonya
			try:
				hold_size    = account ['balances' ][fut ] 
			except:
				hold_size    = 0

			hold_size            =  hold_size if deri_test == 0 else abs(position['size']) 

			#menentukan arah 
    
			if hold_size > 0 and deri_test==0 :
    				direction_CF = buy
			elif hold_size < 0 and deri_test==0:
				direction_CF = sell

			direction       = direction_CF if deri_test==0 else(
                            0 if hold_size==0 else position[side])

			#menentukan harga rata2 per posisi open 

			hold_avgPrc_CF      = 0 if direction_CF==0 else [o[price] for o in[
				o for o in  positions if o[instrument]==fut]] [0]

			#prc average
			hold_avgPrc_buy	=  sum([o[avgPrc] for o in [o for o in positions if o[side] == longs and o[instrument]==fut ]])

			hold_avgPrc_sell    =  sum([o[avgPrc] for o in [o for o in positions  if o[side] == short and o[instrument]==fut ]]) 	

			#menentukan kuantitas per posisi open per instrumen/total instrumen

			hold_longQtyAll_CF      = sum( [ o[size] for o in [
				o for o in position_CF if o[side] == longs and  o[
					instrument][:9][4]=='b']])

			hold_shortQtyAll_CF     = sum( [ o[size]  for o in [
									                 o for o in position_CF if o[side] == short and o[
										             instrument][:9][4]=='b']])	

			hold_qty_buy	= sum([ o[size] for o in [o for o in positions if o[
				side]== longs and  o[instrument]==fut ] ])  
  
			hold_qty_sell	= sum([ o[size] for o in [o for o in positions if o[
				side]== short and  o[instrument]==fut ] ]) 

			hold_qty_net		= (hold_qty_buy + hold_qty_sell) if deri_test ==1 else (hold_longQtyAll_CF - hold_shortQtyAll_CF)
			hold_qty_total_net	= sum([o[size] for o in [o for o in positions ]])

			#mendapatkan atribut riwayat transaksi deribit vs crypto facilities 
			filledOrder 		=   [ o for o in [o for o in json.loads(cfPrivate.get_fills())[
				'fills'] if o[instrument]==fut   ]]  if deri_test == 0 else (
					client_trading.private_get_order_history_by_instrument_get (
						instrument_name=fut, count=10)['result'])									

			try:
				filledOrders_sell_lastTime=  (max([o[fillTime] for o in [
				o for o in filledOrder if o[side] == 'sell' ]]))

			except:
				filledOrders_sell_lastTime = 0

			try:
				filledOrders_buy_lastTime=  (max([o[fillTime] for o in [
				o for o in filledOrder if o[side] == 'buy' ]]))

			except:
				filledOrders_buy_lastTime = 0

			try:
				if deri_test == 0:
    					
					filledOrders_sell_lastTime_conv= time_conversion (max([o[fillTime] for o in [
				o for o in filledOrder if o[side] == 'sell' ]]))

				elif deri_test == 1:
    					
					filledOrders_sell_lastTime_conv=([o[fillTime] for o in [
				o for o in filledOrder if o[side] == 'sell' ]])

				else:
					filledOrders_sell_lastTime_conv= 0

			except:
				filledOrders_sell_lastTime_conv = 0
			try:

				if deri_test == 0:
    					
					filledOrders_buy_lastTime_conv= time_conversion (max([o[fillTime] for o in [
				o for o in filledOrder if o[side] == 'buy' ]]))

				elif deri_test == 1:
					
					filledOrders_buy_lastTime_conv=([o[fillTime] for o in [
				o for o in filledOrder if o[side] == 'buy' ]])

				else:
					filledOrders_buy_lastTime_conv= 0                    
			except:
				filledOrders_buy_lastTime_conv = 0				

			filledOrders_sell_openLastTime 	        = 0 if filledOrders_sell_lastTime ==[
													] else filledOrders_sell_lastTime

			filledOrders_buy_openLastTime	        = 0 if filledOrders_buy_lastTime ==[
													]else filledOrders_buy_lastTime

			filledOrders_prc_sell	=   ([ o[price] for o in [
					o for o in filledOrder if o[side]=='sell'  ]])

			filledOrders_prc_buy	=  [o[price] for o in [
				o for o in filledOrder if o[side] == 'buy'  ]]


			filledOrders_prc_sell 	=  0 if filledOrders_prc_sell ==[] else filledOrders_prc_sell [0]

			filledOrders_prc_buy    = 0 if filledOrders_prc_buy ==[] else filledOrders_prc_buy [0]


			filledOrders_qty_sell	=   ([ o[size] for o in [
					o for o in filledOrder if o[side]=='sell' and   ( o[
							fillTime]) == filledOrders_sell_lastTime ]])

			filledOrders_qty_buy	=  [o[size] for o in [
				o for o in filledOrder if o[side] == 'buy'  and   ( o[
							fillTime]) == filledOrders_buy_lastTime  ]]


			filledOrders_qty_sell 	=  0 if filledOrders_qty_sell ==[] else filledOrders_qty_sell  [0]

			filledOrders_qty_buy    = 0 if filledOrders_qty_buy ==[] else filledOrders_qty_buy   [0]

			#mendapatkan atribut open order deribit vs crypto facilities 	  

			openOrders_CF           = ( [ o for o in [o for o in (json.loads(
				cfPrivate.get_openorders())['openOrders']) if o[instrument]==fut   ]]  )
		
			openOrders_CF           = [] if openOrders_CF ==[] else openOrders_CF
			
			openOrders              = openOrders_CF if deri_test==0 else (
                            client_trading.private_get_open_orders_by_instrument_get (
                                instrument_name=fut)['result'])

			#menentukan kuantitas per  open order per instrumen

			openOrders_qty_buy 	=   sum([o[unfilledSize] for o in [
				o for o in openOrders if o[side] == 'buy'  ]])

			openOrders_qty_sell	=  sum([o[unfilledSize] for o in [
				o for o in openOrders if o[side] == 'sell'  ]])*-1

			openOrders_qty_Net	=  openOrders_qty_buy + openOrders_qty_sell

			filledopenOrders_qty_buy_total 	=  (openOrders_qty_buy + hold_qty_buy)

			filledopenOrders_qty_sell_total = (openOrders_qty_sell + hold_qty_sell)
			
			filledOpenOrders_qty_totalNet= filledopenOrders_qty_buy_total + filledopenOrders_qty_sell_total 
					
			try:

				if deri_test == 0:
					openOrders_time_buy_conv= time_conversion( (max([o[last_update_timestamp] for o in [
				o for o in openOrders if o[side] == 'buy' ]])))

				elif deri_test == 1:
					openOrders_time_buy_conv=  ( max(([o[last_update_timestamp] for o in [
				o for o in openOrders if o[side] == 'buy' ]])))

				else:
					openOrders_time_buy_conv= 0
 									
			except:
				openOrders_time_buy_conv = 0

			try:
#_conv=CONVERTED TO utc 
				if deri_test == 0:
					openOrders_time_sell_conv=  time_conversion( (max([o[last_update_timestamp] for o in [
				o for o in openOrders if o[side] == 'sell' ]])))
				elif deri_test == 1:
					openOrders_time_sell_conv=max(([o[last_update_timestamp] for o in [
				o for o in openOrders if o[side] == 'sell' ]]))

				else:
					openOrders_time_sell_conv= 0

			except:
				openOrders_time_sell_conv  = 0

			try:
				openOrders_time_buy=  (max([o[last_update_timestamp] for o in [
				o for o in openOrders if o[side] == 'buy' ]]))

			except:
				openOrders_time_buy = 0

			try:
				openOrders_time_sell=  (max([o[last_update_timestamp] for o in [
				o for o in openOrders if o[side] == 'sell' ]]))

			except:
				openOrders_time_sell  = 0

			try:				
				openOrders_prc_buy_limit=  ([ o[limitPrice] for o in [
					o for o in openOrders if o[orderType]==limit and   ( o[
							last_update_timestamp]) == openOrders_time_buy  ]])[0]
			except:
				openOrders_prc_buy_limit  =0

			try:
				openOrders_oid_buy_limit=  ([ o[order_id] for o in [
					o for o in openOrders if o[orderType]==limit and   ( o[
							last_update_timestamp]) == openOrders_time_buy  ]])[0]

			except:
				openOrders_oid_buy_limit=0			

			try:
				openOrders_oid_sell_limit=  ([ o[order_id] for o in [
					o for o in openOrders if o[orderType]==limit and   ( o[
							last_update_timestamp]) == openOrders_time_sell  ]])[0]

			except:
				openOrders_oid_sell_limit=0			
			
			try:
				openOrders_oid_buy_stopLimit   = [ o[order_id] for o in [
					o for o in openOrders if o[
						side] == 'buy'   and o[
							order_status] == 'untriggered'  and  o[
								orderType]==stop  ] ] [0]                          
			except:
				openOrders_oid_buy_stopLimit = 0

			try:
				openOrders_prc_sell_limit=[ o[limitPrice] for o in [
					o for o in openOrders if o[orderType]==limit and   ( o[
							last_update_timestamp]) == openOrders_time_sell  ]] [0]

			except:
				openOrders_prc_sell_limit=0

			try:
				openOrders_oid_sell_stopLimit  = [ o[order_id] for o in [
					o for o in openOrders if  o[
						side] == 'sell'  and o[
							order_status] == 'untriggered'  and  o[
								orderType]==stop ]] [0]

			except:
				openOrders_oid_sell_stopLimit	= 0		

			#menghitung kuantitas stop order per instrumen
				#maks stop order 20

			openOrders_qty_buy_stop	= sum([o[unfilledSize
			] for o in [o for o in openOrders if o[
				side] == 'buy' and  o[orderType]==stop ]])

			openOrders_qty_sell_stop=  sum([o[unfilledSize
			] for o in [o for o in openOrders if o[
				'side'] == 'sell' and  o[orderType]==stop ]])

			#menghitung kuantitas limit order per instrumen
#openOrders_time_sell 
			#qty individual
			try:
				openOrders_qty_sell_limit  =  [ o[unfilledSize] for o in [
					o for o in openOrders if ( o[
					last_update_timestamp]) ==openOrders_time_sell  and  o[
							orderType]== limit  and o[
							'side']=='sell']] [0]
			except:
				openOrders_qty_sell_limit=0
#
			try:
				openOrders_qty_buy_limit  =   [ o[unfilledSize] for o in [
					o for o in openOrders if (o[
					last_update_timestamp]) ==openOrders_time_buy  and  o[
							orderType]== limit and  o[
							'side']=='buy']] [0]
			except:
				openOrders_qty_buy_limit=0

			try:
				openOrders_qty_sell_limit_sum  =  sum ([ o[unfilledSize] for o in [
					o for o in openOrders if  o[
							orderType]== limit and  o[
							'side']=='sell']] )
			except:
				openOrders_qty_sell_limit_sum=0
#
			try:
				openOrders_qty_buy_limit_sum  =  sum ([ o[unfilledSize] for o in [
					o for o in openOrders if  o[
							orderType]== limit and  o[
							'side']=='buy']] )
			except:
				openOrders_qty_buy_limit_sum=0

			try:
				openOrders_qty_buy_limitLen=   len ([o[
			unfilledSize] for o in [o for o in openOrders if o[
			'side'] == 'buy' and  o[orderType]==limit ]]  )

			except:
				openOrders_qty_buy_limitLen  = 0

			try:
				openOrders_qty_sell_limitLen=  len ([o[
			unfilledSize] for o in [o for o in openOrders if o[
			'side'] == 'sell' and  o[orderType]==limit ]]  ) *-1

			except:
				openOrders_qty_sell_limitLen  = 0

			#balancing saldo
			try:
				openOrders_oid_sell_limitBal=   max([o[order_id] for o in [o for o in openOrders if o[
			'side'] == 'sell' and  o[orderType]==limit and  abs(o[unfilledSize]) > QTY ]]  )

			except:
				openOrders_oid_sell_limitBal  = 0	 	 

			try:
				openOrders_oid_limit_buyBal=   max([o[order_id] for o in [o for o in openOrders if o[
			'side'] == 'buy' and  o[orderType]==limit and  o[unfilledSize] > QTY ]]  )

			except:
				openOrders_oid_limit_buyBal  = 0	 	 

			stop_total_qty_fut	=  (openOrders_qty_buy_stop+ abs(openOrders_qty_sell_stop))

			#menghitung waktu stop order per instrumen ada di platform
				#maks stop order 20
	
			try:
				openOrders_buy_minTime_stopLimit	= time_conversion (min( [ o[
					last_update_timestamp] if deri_test == 0 else min( o
				[last_update_timestamp])  for o in [o for o in openOrders if o[
				'side'] == 'buy' and  o[orderType]==stop ]] ))
			except:
				openOrders_buy_minTime_stopLimit	=0
	
			try:
				openOrders_sell_minTime_stopLimit=  time_conversion (min( [ o[
					last_update_timestamp] if deri_test == 0 else min( o
				[last_update_timestamp])  for o in [o for o in openOrders if o[
				'side'] == 'sell' and  o[orderType]==stop ]]))

			except:
				openOrders_sell_minTime_stopLimit=0

			try:
				openOrders_qty_sell_filled=   ([o[
			'filledSize'] for o in [o for o in openOrders if o[
			'side'] == 'sell' and  o[orderType]==limit ]]  )[0] *-1

			except:
				openOrders_qty_sell_filled  = 0

			try:
				openOrders_qty_buy_filled=   ([o[
			'filledSize'] for o in [o for o in openOrders if o[
			'side'] == 'buy' and  o[orderType]==limit ]]  ) [0]

			except:
				openOrders_qty_buy_filled  = 0

			nbids           =  1
			nasks           =  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1		
			
			for i in range(max(nbids, nasks)):
        
				#PILIHAN INSTRUMEN
				#perpetual= diarahkan posisi sell karena funding cenderung berada di sell
				#lawannya, future dengan tanggal jatuh tempo terlama (mengurangi resiko forced sell)-->1

					#menghitung waktu open di order book


				open_time_buy = 0 if openOrders_time_buy == 0 else (
						openOrders_time_buy_conv if deri_test == 0 else (time_now/1000- (
							openOrders_time_buy)/1000))

				open_time_sell = 0 if openOrders_time_sell == 0 else (
						openOrders_time_sell_conv if deri_test == 0 else (time_now/1000- (
							openOrders_time_sell)/1000))
			
					#menghitung waktu terakhir kali order dieksekusi
				filled_time_buy = 0 if filledOrders_buy_lastTime == 0 else (
						filledOrders_buy_lastTime_conv if deri_test == 0 else (time_now/1000- (
							filledOrders_buy_lastTime)/1000))


				filled_time_sell = 0 if filledOrders_sell_lastTime == 0 else (
						filledOrders_sell_lastTime_conv if deri_test == 0 else (time_now/1000- (
							filledOrders_sell_lastTime)/1000))

				IDLE_TIME=600
				if  abs (hold_qty_sell) == QTY:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*10)
				elif  abs (hold_qty_sell) <= QTY*2:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*20)
				elif  abs (hold_qty_sell) <= QTY*4:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*40)
				elif  abs (hold_qty_sell) <= QTY*8:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*80)
				elif  abs (hold_qty_sell) <= QTY*16:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*160)
				elif  abs (hold_qty_sell) <= QTY*32:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*320)
				else:
					IDLE_TIME = 0

				if  abs (hold_qty_buy) == QTY:
    					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*10)
				elif  abs (hold_qty_buy) <= QTY*2:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*20)
				elif  abs (hold_qty_buy) <= QTY*4:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*40)
				elif  abs (hold_qty_buy) <= QTY*8:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*80)
				elif  abs (hold_qty_buy) <= QTY*16:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*160)
				elif  abs (hold_qty_buy) <= QTY*32:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*320)
				else:
					IDLE_TIME = 0
							#batasan transaksi

	

				place_bids 	= 'true'
				place_asks 	= 'true'
				place_bids  =  equity==True  and (perp_test== 1 or fut_test==1)
				place_asks  =   equity==True  and (perp_test== 1 or fut_test==1)
				delta_prc	=  MARGIN/20
				mod_buy 	= (hold_qty_buy) % QTY
				mod_sell 	= abs(hold_qty_sell) % QTY


				print(fut, 'IDLE_TIME',IDLE_TIME,'datetime.now()',datetime.now())
				print(fut, 'filledOrders_buy_lastTime',filledOrders_buy_lastTime,
				'filledOrders_sell_lastTime',filledOrders_sell_lastTime)
								
				print(fut, 'openOrders_time_buy_conv',openOrders_time_buy_conv,
				'openOrders_time_sell_conv',openOrders_time_sell_conv)
				print(fut, 'open_time_buy',open_time_buy,
				'open_time_sell',open_time_sell,'filled_time_sell',
				filled_time_sell,'filled_time_buy',filled_time_buy)

				delta_time_buy= max (filled_time_buy,open_time_buy)  if (
					filled_time_buy == 0 or open_time_buy ==0) else min (
						filled_time_buy,open_time_buy)

				delta_time_sell= max (filled_time_sell,open_time_sell) if (
					filled_time_sell ==0 or open_time_sell==0) else min (
						filled_time_sell,open_time_sell)
				delta_time_buy= max (filled_time_buy,open_time_buy)  if (
					filled_time_buy == 0 or open_time_buy ==0) else min (
						filled_time_buy,open_time_buy)

				delta_time_sell= max (filled_time_sell,open_time_sell) if (
					filled_time_sell ==0 or open_time_sell==0) else min (
						filled_time_sell,open_time_sell)



				#order tidak dieksekusi >280 detik
				#seluruh stop limit yg belum ditrigger
				#limit, sesuai dengan lawan masing2 default

				if ((abs(openOrders_qty_sell_limit_sum) + abs(
					openOrders_qty_sell_stop)) > hold_qty_buy) and fut_test==1 and hold_qty_buy != 0:


					if openOrders_oid_sell_stopLimit  !=0:
						print(BLUE + str((fut,'222A','abs(openOrders_qty_sell_limit)',abs(openOrders_qty_sell_limit),
					  'openOrders_qty_sell_stop',openOrders_qty_sell_stop,'hold_qty_buy',
					  hold_qty_buy,fut_test)),ENDC)
	
	    												
						client_trading.private_cancel_get(openOrders_oid_sell_stopLimit)
					
					if openOrders_oid_sell_limit  !=0: #openOrders_oid_sell_limit  !=0 = mengecek open order sudah tereksekusi/belum	
  
						print(BLUE + str((fut,'222B','abs(openOrders_qty_sell_limit)',abs(openOrders_qty_sell_limit),
					  'openOrders_qty_sell_stop',openOrders_qty_sell_stop,'hold_qty_buy',
					  'openOrders_oid_sell_limit',openOrders_oid_sell_limit,
					  hold_qty_buy,fut_test)),ENDC)
	
						cfPrivate.cancel_order(openOrders_oid_sell_limit) if deri_test == 0 else (
							client_trading.private_cancel_get(openOrders_oid_sell_limit))     					
	
				if ((abs(openOrders_qty_buy_limit_sum) + abs(
					openOrders_qty_buy_stop)) > abs(hold_qty_sell)) and perp_test==1 and hold_qty_sell != 0:
					
					print(BLUE + str((fut,'333A','openOrders_qty_buy_limit',openOrders_qty_buy_limit,'openOrders_oid_buy_stopLimit',openOrders_oid_buy_stopLimit,
					'openOrders_qty_buy_stop','hold_qty_sell',hold_qty_sell,perp_test )),ENDC)

					if openOrders_oid_buy_stopLimit  !=0:#openOrders_oid_sell_limit  !=0 = mengecek open order sudah tereksekusi/belum							
						client_trading.private_cancel_get(openOrders_oid_buy_stopLimit)
					
					print(BLUE + str((fut,'333B','openOrders_qty_buy_limit',openOrders_qty_buy_limit,
					'openOrders_oid_buy_limit',openOrders_oid_buy_limit,
					'openOrders_qty_buy_stop','hold_qty_sell',hold_qty_sell,perp_test )),ENDC)

					if openOrders_oid_buy_limit  !=0:#openOrders_oid_sell_limit  !=0 = mengecek open order sudah tereksekusi/belum							
						cfPrivate.cancel_order(openOrders_oid_buy_limit) if deri_test == 0 else (
							client_trading.private_cancel_get(openOrders_oid_buy_limit) )    
    
				if open_time_buy >180 or open_time_sell >180:# and api ==True:
    
					if  max (open_time_buy,open_time_sell) > IDLE_TIME  : 													
						if openOrders_qty_buy_limit <= QTY and openOrders_oid_buy_limit != 0 and (
							openOrders_qty_buy_filled==0):     

							print(BLUE + str((fut,'444A','open_time_buy',open_time_buy,
					'open_time_sell',open_time_sell,'IDLE_TIME'
					,IDLE_TIME,'openOrders_qty_buy_limit',openOrders_qty_buy_limit,
					'openOrders_oid_buy_limit',openOrders_oid_buy_limit)),ENDC)

							cfPrivate.cancel_order(openOrders_oid_buy_limit) if deri_test == 0 else (
								client_trading.private_cancel_get(openOrders_oid_buy_limit))

						if abs(openOrders_qty_sell_limit) <= QTY and openOrders_oid_sell_limit !=0 and (
							openOrders_qty_sell_filled==0):                                                   
							print(BLUE + str((fut,'555A','open_time_buy',open_time_buy,
					'open_time_sell',open_time_sell,'IDLE_TIME'
					,IDLE_TIME,'openOrders_qty_sell_limit',openOrders_qty_sell_limit,
					'openOrders_oid_sell_limit',openOrders_oid_sell_limit)),ENDC)
							cfPrivate.cancel_order(openOrders_oid_sell_limit) if deri_test == 0 else client_trading.private_cancel_get(openOrders_oid_sell_limit)

				if  openOrders_qty_buy_limitLen > 2 and openOrders_oid_limit_buyBal != 0:	

					print(BLUE + str((fut,'666A','openOrders_qty_buy_limit',openOrders_qty_buy_limit,
					'openOrders_oid_limit_buyBal',openOrders_oid_limit_buyBal)),ENDC)
					cfPrivate.cancel_order(openOrders_oid_limit_buyBal) if deri_test == 0 else client_trading.private_cancel_get(openOrders_oid_limit_buyBal)                                                   

				if  abs(openOrders_qty_sell_limitLen) > 2 and openOrders_oid_sell_limitBal != 0:	
 					print(BLUE + str((fut,'777A','openOrders_qty_sell_limit',openOrders_qty_sell_limit,
					 'openOrders_oid_sell_limitBal',openOrders_oid_sell_limitBal)),ENDC)
 
 					cfPrivate.cancel_order(openOrders_oid_sell_limitBal) if deri_test == 0 else client_trading.private_cancel_get(openOrders_oid_sell_limitBal)                                                   
 			
				bid_prc_down = hold_avgPrc_buy-(hold_avgPrc_buy*(MARGIN/2*(
					1 if hold_avgPrc_buy < 5 else 1.5)*hold_qty_buy/QTY))
				ask_prc_up = abs(hold_avgPrc_sell) + abs((hold_avgPrc_sell*(
					MARGIN/2*(1 if hold_avgPrc_buy < 5 else 1.5))*hold_qty_sell/QTY))

				
				if place_bids:
 									
					default_order = {
									"orderType": "post",
									"side": "buy",
									"symbol": fut.upper(),
									"reduceOnly": "false"
									}
					
					stop_prc_perp=   max( ask_prc_perp,( float(openOrders_prc_sell_limit+TICK ) ) )

					if   perp_test==1 :

						test_qty_stop =openOrders_qty_buy_stop < QTY and abs(openOrders_qty_sell_limit) == QTY
						test_prc = openOrders_prc_sell_limit !=0 if deri_test == 1 else filledOrders_prc_sell !=0 

						test_qty_sum = openOrders_qty_buy_limit_sum < abs(hold_qty_sell) and abs(
									hold_qty_sell) > 0 
						test_qty_mod = (mod_sell ==0)
						test_qty_net=abs(hold_qty_sell)-abs(openOrders_qty_buy_limit) > 0
						test_qty_freq =  openOrders_qty_buy_limitLen < 2
						test_pct_sum =  False if abs(hold_qty_sell)==0 else (openOrders_qty_buy_limit_sum /abs(hold_qty_sell)) < 40/100

						prc_limit=min(bid_prc_perp,(int(filledOrders_prc_sell  - (delta_prc *abs(
								 filledOrders_prc_sell))) if curr== 'xbt' else float( (round(
									 filledOrders_prc_sell  - (delta_prc *abs(
								 filledOrders_prc_sell)),8)))))
						prc_stop=   int(openOrders_prc_sell_limit-(delta_prc * openOrders_prc_sell_limit)) if curr== 'xbt' else float(
							(round(openOrders_prc_sell_limit  - (delta_prc *abs(openOrders_prc_sell_limit)),8))
						)

						prc_net= min(bid_prc, int(hold_avgPrc_sell-(hold_avgPrc_sell * MARGIN * .7)) if curr=='xbt' else float(
								 (round(hold_avgPrc_sell-(hold_avgPrc_sell * MARGIN * .7),8))) )                                                   

						qty_net=((abs(hold_qty_sell) - abs(filledOrders_qty_sell)) ) if abs(
							hold_qty_sell) > QTY else abs(hold_qty_sell)			

						#pengimbang AVG DOWN, 						
						if  test_qty_net==True and test_qty_freq == True and (
								prc_net !=0 and qty_net !=0) and test_pct_sum == True:
											

							print(GREEN + str((fut,'#pengimbang AVG DOWN','hold_qty_sell',abs(hold_qty_sell),
							'(abs(hold_qty_sell)-abs(openOrders_qty_buy_limit)) >= 0',
							(abs(hold_qty_sell)-abs(openOrders_qty_buy_limit)) > 0,
							abs(openOrders_qty_buy_limit),'test_qty_freq',test_qty_freq,'qty',qty_net,
							'prc',prc_net,'(test_pct_sum',test_pct_sum)),ENDC)

							if deri_test == 1 :

#pesan 2 x? openOrders_qty_sell_limitMax
								client_trading.private_buy_get(
								instrument_name =fut,
								reduce_only     ='false',
								type            =limit,
								price           =prc_net ,
								post_only       ='true',
								amount          =qty_net
								)	

							if deri_test == 0 :

								cfPrivate.send_order_1(dict(default_order,**{"size": qty_net,"limitPrice":prc_net}))


						elif  (test_qty_stop == True and  test_prc==True) :
    							
							if deri_test == 1 and prc !=0:

								client_trading.private_buy_get(
								instrument_name =fut ,
								amount          = QTY,
								price           =prc_stop,
								stop_price      =stop_prc_perp,
								type            =stop,
								trigger         ='last_price',
								post_only       ='true',
								reduce_only     ='false'
								)
									
						#NORMAL, bila limit diekseskusi, tetapi stop_limit kesangkut.
							#Atau bila ada kesalahan eksekusi apa pun,
							#langsung dibuatkan lawan dari transaksi terakhir
							#filledOpenOrders_qty_totalNet = gabungan open + hold

						elif  (test_qty_sum == True and test_qty_freq == True and test_qty_mod ==True and test_prc==True ):   

							qty=abs(filledOrders_qty_sell)

							print(GREEN + str((fut,'#NORMAL, bila limit diekseskusi','test_qty_sum',
							test_qty_sum,'test_qty_freq',test_qty_freq,'test_qty_mod',test_qty_mod,
							'test_prc',test_prc,'qty',qty,'prc_limit',prc_limit)),ENDC)
							if deri_test == 1 and prc !=0:
	
								client_trading.private_buy_get(
								instrument_name =fut,
									reduce_only	='false',
									type		=limit,
									price		=prc_limit,
								post_only		='true',
								amount			=qty
								)	

							if deri_test == 0 and prc_limit !=0:
    									
								cfPrivate.send_order_1(dict(default_order,**{"size": qty,"limitPrice":prc_limit}))

						#memastikan hanya ada 1 order setiap waktu
						elif  openOrders_qty_buy_stop >QTY :			

							cfPrivate.cancel_order(openOrders_oid_buy_stopLimit) if deri_test == 0 else client_trading.private_cancel_get(openOrders_oid_buy_stopLimit) 			

						#NORMAL,, pasang posisi beli pada QTY =0/avg down  					                                                    							
					elif  fut_test==1 and(openOrders_qty_buy == 0 or  openOrders_qty_buy_filled !=0 or mod_buy !=0):#or open_time ==0

						test_qty = (( abs(openOrders_qty_buy_limit_sum))< (QTY )  and hold_qty_buy !=0 ) 
						test_qty_zero =  ((hold_qty_buy ==0 and openOrders_qty_buy_limit == 0))
						test_qty_mod = mod_buy !=0  
						test_time = delta_time_buy > IDLE_TIME
						test_prc = bid_prc_fut < bid_prc_down

						print(GREEN + str((fut,'#NORMAL, pasang posisi beli pada QTY =0/avg down','test_qty',test_qty,'test_time',test_time,
							'test_prc',test_prc,'test_qty_zero',test_qty_zero,'test_qty_mod',test_qty_mod)),ENDC)			
										
						if  (test_qty == True and test_time == True and test_prc==True)  or (
							test_qty_zero ==True ):
    							
							prc= bid_prc_fut
							qty= QTY if mod_buy == 0 else (QTY-mod_buy)

							if deri_test == 1 and prc !=0:

								client_trading.private_buy_get(
								instrument_name=fut,
								amount=qty,
								price=prc,
								type=limit,
								reduce_only='false',
								post_only='true'
								)		

							if deri_test == 0  and prc !=0:
								cfPrivate.send_order_1(dict(default_order,**{"size": qty,"limitPrice":prc}))


				# OFFERS

				if place_asks:

					default_order = {
									"orderType": "post",
									"side": "sell",
									"symbol": fut.upper(),
									"reduceOnly": "false"
									}

					stop_prc_fut=   min( bid_prc_fut,float (openOrders_prc_buy_limit-(
						TICK ) ) )

					

					if   fut_test==1 : 

  	
						test_qty_stop =abs(openOrders_qty_sell_stop) < QTY and abs(openOrders_qty_buy_limit) == QTY
						test_prc = openOrders_prc_buy_limit !=0 if deri_test == 1 else filledOrders_prc_buy !=0 

						test_qty_sum = abs(openOrders_qty_sell_limit_sum) < hold_qty_buy and abs(
							abs(hold_qty_buy) ) > 0 
						test_qty_mod = (mod_buy ==0)
						test_qty_freq =  abs(openOrders_qty_sell_limitLen ) < 2
						test_pct_sum =  False if abs(hold_qty_buy)==0 else (
							openOrders_qty_sell_limit_sum /abs(hold_qty_buy)) < 40/100

						prc_stop=   int(openOrders_prc_buy_limit+(delta_prc * openOrders_prc_buy_limit)) if curr== 'xbt' else float(
							(round(openOrders_prc_buy_limit  + (delta_prc *abs(openOrders_prc_buy_limit)),8))
						)
						prc_net=max(ask_prc, int(hold_avgPrc_buy+(hold_avgPrc_buy*MARGIN * .7)) if curr=='xbt' else float(round(
								hold_avgPrc_buy+(hold_avgPrc_buy*MARGIN * .7),8)) )
							
						qty_net= ((abs(hold_qty_buy) - abs(filledOrders_qty_buy)) ) if abs(
							hold_qty_buy) > QTY else abs(hold_qty_buy)


						print(GREEN + str((fut,'#pengimbang UP TEST','hold_qty_sell',abs(hold_qty_buy),
							'hold_qty_buy - abs(openOrders_qty_sell_limit)',
							hold_qty_buy - abs(openOrders_qty_sell_limit) > 0,
							abs(openOrders_qty_buy_limit),'test_qty_freq',test_qty_freq,'qty',qty_net,
							'prc',prc_net,' abs(filledOrders_qty_buy)', abs(filledOrders_qty_buy))),ENDC)
	

						#pengimbang AVG UP
						if  hold_qty_buy - abs(openOrders_qty_sell_limit) > 0 and test_qty_freq ==True and (
							prc_net !=0 or qty_net !=0) and test_pct_sum == True:
					
							if deri_test == 1 :																		
								client_trading.private_sell_get(
								instrument_name=fut,
								reduce_only='false',
								type=limit,
								price=prc_net,
								post_only='true',
								amount=qty_net
								)	

							if deri_test == 0 :

								cfPrivate.send_order_1(dict(default_order,**{"size": qty_net,"limitPrice":prc_net}))


						#NORMAL, stop limit seketika setelah eksekusi order

						elif (test_qty_stop == True and  test_prc==True): 

							print(RED + str((fut,'#NORMAL, bila limit diekseskusi','test_qty',test_qty,'test_time',test_time,
							'test_prc',test_prc,'test_qty_zero',test_qty_zero,'test_qty_mod',test_qty_mod)),ENDC)			
			

							if deri_test == 1 and prc !=0:

								client_trading.private_sell_get(
								instrument_name=fut,
								amount=QTY,
								price=prc_stop,
								stop_price=stop_prc_fut,
								type            =stop,
								trigger         ='last_price',
								post_only       ='true',
								reduce_only     ='false'
								)

						#normal, bila limit diekseskusi, tetapi stop_limit kesangkut.
							#Atau bila ada kesalahan eksekusi apa pun,
							#langsung dibuatkan lawan dari transaksi terakhir


						elif  (test_qty_sum == True and test_qty_freq == True and test_qty_mod ==True and test_prc==True ):													
							qty= abs(filledOrders_qty_buy)

							prc_limit=max(ask_prc_fut,int(filledOrders_prc_buy+(delta_prc*filledOrders_prc_buy)) if curr== 'xbt' else float( (round(
						filledOrders_prc_buy+(delta_prc*filledOrders_prc_buy),8))))
							
							if deri_test == 1 and prc !=0:

								client_trading.private_sell_get(
								instrument_name=fut,
								reduce_only='false',
								type=limit,
								price=prc_limit,
								post_only='true',
								amount=qty)	

							if deri_test == 0 and prc !=0:

								cfPrivate.send_order_1(dict(default_order,**{"size": qty,"limitPrice":prc_limit}))

						#memastikan hanya ada 1 order setiap waktu
						elif  abs(openOrders_qty_sell_stop) > QTY :
							cfPrivate.cancel_order(openOrders_oid_sell_stopLimit) if deri_test == 0 else (
								client_trading.private_cancel_get(openOrders_oid_sell_stopLimit))

						#NORMAL,, pasang posisi beli pada QTY =0/avg up  					                                                    							
					elif   perp_test==1 and (openOrders_qty_sell == 0 or  openOrders_qty_sell_filled !=0 or mod_sell !=0):

						test_qty = ( abs(openOrders_qty_sell_limit_sum)  < (QTY ) and abs(hold_qty_sell) !=0 ) 
						test_qty_zero =  hold_qty_sell ==0 and abs(openOrders_qty_sell_limit) ==0
						test_qty_mod = mod_sell !=0  
						test_time = delta_time_sell > IDLE_TIME
						test_prc = ask_prc_perp < ask_prc_up


						print(RED + str((fut,'#NORMAL,pasang posisi beli pada QTY =0/avg up','test_qty',test_qty,'test_time',test_time,
							'test_prc',test_prc,'test_qty_zero',test_qty_zero,
							'test_qty_mod',test_qty_mod,'delta_time_sell',delta_time_sell)),ENDC)			
										

						if  (test_qty == True and test_time == True and test_prc==True)  or (
							test_qty_zero ==True):

							prc= ask_prc_perp
							qty= QTY if mod_sell == 0 else (QTY-mod_sell)
							
							if deri_test == 1 and prc !=0:
								client_trading.private_sell_get(
								instrument_name=fut,
								reduce_only='false',
								type=limit,
								price=max(prc,ask_prc) ,
								post_only='true',
								amount=QTY
								)	

							if deri_test == 0 and  prc !=0:
								cfPrivate.send_order_1(dict(default_order,**{"size": qty,"limitPrice":prc}))
				
				
				counter= get_time - (stop_unix/1000)
				qty= max (hold_qty_buy,abs(hold_qty_sell))
				waktu = datetime.now()
				my_message = " {} " " - " " {} " '\n' " {} ".format(waktu,fut,qty)#.round(0).astype(int))
				
				print('my_message', fut, my_message)
				print('counter', fut, counter,qty)
		
				if counter > (8 if equity !=0 else 0):# if deri_test ==1 else 10:
					while True:
						self.restart_program()
					break

				if hold_qty_buy >200 or abs(hold_qty_sell) >200  :
					print('my_message2', fut, my_message)
					telegram_bot_sendtext(my_message)
                    
				print('my_message', fut, my_message)

				
				#print(sub_name,fut,'counter',counter)
	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

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
#PR
#konsistecdcfnsi tanda minus
#buat def/fungsi: konversi done, telegram done
#circuit breaker
#TODO:
#FIXME:formula ambila laba masih salah. Qty 400, jual 100, jual berikutnya masih pakai hatga terakhir (harusnya dah avg)
