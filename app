from collections import OrderedDict
import os
import sys
import logging, math
import time
from time import sleep
from datetime import datetime, timedelta
from os.path import getmtime
import argparse,  traceback
import requests
from api import RestClient
import openapi_client
from openapi_client.rest import ApiException
import cfRestApiV3 as cfApi
import ssl
import pandas as pd  
import numpy as np
import simplejson as json

#from pandas.io.json import json_normalize

#c0t8sxtj@futures-demo.com
#wpnjckpwaxacphzm78du

try:
	_create_unverified_https_context = ssl._create_unverified_context
	
except AttributeError:
	# Legacy Python that doesn't verify HTTPS certificates by default
	pass
else:
	# Handle target environment that doesn't support HTTPS verification
	ssl._create_default_https_context = _create_unverified_https_context

#FIXME:
TRAINING=False#True#
apiPath_training  = "https://conformance.cryptofacilities.com/derivatives"
apiPublicKey_training = "PlRnNMw9jpQw1Cnxel99eVqjAp00fCypDdc4zC4godZJa91Y4UXfMHMz"
apiPrivateKey_training ="3k8j0gangNZ/+B0Zxi8WNfpd+6ETXfJf+f/sD3H+K6dolQ5dlw4EtK6VzZxU7LqjktZVgHSdosdT7qxZKcU5sK/Q"

apiPath = "https://www.cryptofacilities.com/derivatives" if TRAINING==False else apiPath_training 
apiPrivateKey ="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg" if TRAINING==False else apiPrivateKey_training
apiPublicKey = "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec" if TRAINING==False else apiPublicKey_training
checkCertificate = True if TRAINING==False else False # False# # when using the test environment, this must be set to "False"
timeout = 5
useNonce = False  # nonce is optional

cfPublic = cfApi.cfApiMethods(apiPath, timeout=timeout, checkCertificate=checkCertificate)
cfPrivate = cfApi.cfApiMethods(apiPath, timeout=timeout, apiPublicKey=apiPublicKey, apiPrivateKey=apiPrivateKey, checkCertificate=checkCertificate, useNonce=useNonce)

chck_key=str(int(openapi_client.PublicApi(openapi_client.ApiClient(openapi_client.Configuration())).public_get_time_get()['result']/1000))[8:9]*1

#'mwa 4'
#if chck_key =='0'  or chck_key =='4' or chck_key=='2' or chck_key=='6'or chck_key=='9':
#	key = "D5FPr7zK"
#	secret = "2VFkx_DfvnkPeZgPhd2FSTYZ2iAuR8NneqG2rBYntys"

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

NOW_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 3, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(NOW_TIME.timetuple())*1000

MARGIN      = 1/100
DELTA_PRC	=  MARGIN/20
IDLE_TIME   = 600 #nggak jalan?
LOG_LEVEL   = logging.INFO
INTERVAL	= 5 #5 minutes
XRP_ROUND	=100000000
FREQ		= 5
RED   		= '\033[1;31m'#Sell
BLUE  		= '\033[1;34m'#information
CYAN 	 	= '\033[1;36m'#execution (non-sell/buy)
GREEN 		= '\033[0;32m'#blue
RESET 		= '\033[0;0m'
BOLD    	= "\033[;1m"
REVERSE 	= "\033[;7m"
ENDC 		= '\033[m' # 


def get_logger( name, log_level ):

	formatter = logging.Formatter( fmt = '%(asctime)s - %(levelname)s - %(message)s' )
	handler = logging.StreamHandler()
	handler.setFormatter( formatter )
	logger = logging.getLogger( name )
	logger.setLevel( log_level )
	logger.addHandler( handler )
	time_now        =	time.mktime(NOW_TIME.timetuple())

	return logger

def sort_by_key( dictarg ):
	return OrderedDict( sorted( dictarg.items(), key = lambda t: t[ 0 ] ))

def time_conversion( waktu ):

	time_now        =	time.mktime(NOW_TIME.timetuple())
	conv_formula	=  	time.mktime (datetime.strptime(waktu,'%Y-%m-%dT%H:%M:%S.%fZ').timetuple() )
	konversi 		= 	time_now - conv_formula

	return konversi

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

	def DF(self):  # Get all current futures instruments

		INSTRUMENT_NAME = 'BTC-PERPETUAL'
		params = {
			'instrument_name': INSTRUMENT_NAME,
			'start_timestamp': int(start_unix),
			'end_timestamp': int(stop_unix),
			'resolution': INTERVAL
		}

		df = pd.DataFrame(requests.get('https://deribit.com/api/v2/public/get_tradingview_chart_data', params=params).json(

		)['result']).drop(columns=['status'])

		df['ticks']=pd.to_datetime(df['ticks'],unit='ms')

		return df

	def DF_XRP(self):  # Get all current futures instruments

		df_xrp			=pd.DataFrame((requests.get(
			'https://api.kraken.com/0/public/OHLC?pair=xxrpxxbt&interval=5').json(
			)['result']['XXRPXXBT']))
		df_xrp 			= df_xrp.rename(columns={0: 'ticks',1: 'open',2: 'high',3: 'low',4: 'close_fl',5: 'vwap',6: 'volume',7: 'count' })
		
		df_xrp['ticks']=pd.to_datetime(df_xrp['ticks'],unit='s')
		df_xrp['close']=pd.Series((df_xrp['close_fl'])).astype(float)*XRP_ROUND

		return df_xrp

	def WMA(self,df, n,column='close'):
    		
		ws = np.zeros(df.shape[0])
		t_sum = sum(range(1, n+1))
	
		for i in range(n-1, df.shape[0]):
			ws[i] = sum(df[i-n+1 : i+1] * np.linspace(1, n, n))/ t_sum
			
		return ws #https://github.com/LastAncientOne/Stock_Analysis_For_Quant/blob/master/Python_Stock/Technical_Indicators/WMA.ipynb

	def HMA(self,df, n):
    		
		hma = self.WMA(2 * self.WMA(df, int(n/2)) - self.WMA(df, n), int(np.sqrt(n)))
			
		return hma #https://github.com/kylejusticemagnuson/pyti/blob/master/pyti/hull_moving_average.py

	def place_orders(self):
				
		instsB = client_market.public_get_book_summary_by_currency_get(currency='BTC', kind='future')['result']
		instsE = client_market.public_get_book_summary_by_currency_get(currency='ETH', kind='future')['result']
        
		self.futures = sort_by_key({i['instrument_name']: i for i in (instsB)})		

		#deri                    = deribit
		#CF                   = crypto facilities

		deri           			= list(self.futures.keys())
		get_instruments_CF           = json.loads(cfPublic.getinstruments())['instruments']

		xbt_perp                 = ['pi_xbtusd']

		xbt_fut                 =[max( [ o['symbol'] for o in[
			o for o in get_instruments_CF if o[
				'symbol'][3:][:3]=='xbt' and len(o['symbol'])<=16 and o['symbol'
				][:1] == 'f'  ]]	)]

		xrp_perp                 = ['pv_xrpxbt']

		xrp_fut                 = [ o['symbol'] for o in[o for o in get_instruments_CF if (
				o['symbol'][3:][:3]=='xrp' and o['symbol'][3:][3:][:3] !='usd'and  (
					o['symbol'][:1] == 'f' ))  ]]

		instruments_list= (list((  xbt_fut + xbt_perp +  xrp_perp + xrp_fut)))#deri + xbt_CF + y) ))
        		
		for fut in instruments_list:
			#membagi deribit vs crypto facilities
			
			n			=10
			IDLE_TIME	=600
						
			nbids       =  1
			nasks       =  1 #if hold_avgPrcFut == 0 and instName [-10:] != '-PERPETUAL' else 1					
			place_bids 	= 'true'
			place_asks 	= 'true'			
			#waktu		= datetime.now()

			get_time	= client_public.public_get_time_get()['result']/1000
			deri_test	= 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1
			[instrument]	= ['symbol'] if deri_test ==0 else ['instrument_name']
			[unfilledSize]	= ['unfilledSize'] if deri_test ==0 else  ['size']		
			[filledSize]	=  ['filledSize']  if deri_test ==0 else ['size']	
			[size]			=  ['size']  
			[side]			= ['side'] if deri_test ==0 else ['direction']
			[price]			= ['price'] if deri_test ==0 else ['price']
			[limitPrice]	= ['limitPrice'] if deri_test ==0 else ['price']
			[stopPrice]		= ['stopPrice'] if deri_test ==0 else ['price']			
			[avgPrc]		= ['price'] if deri_test ==0 else ['avgPrc']	#CF?
			[fillTime]		=  ['fillTime'] if deri_test ==0 else   ['creation_timestamp']
			[last_update_timestamp]=  ['lastUpdateTime'] if deri_test ==0 else ['last_update_timestamp']	
			[orderType]		=  ['orderType'] if deri_test ==0 else ['orderType']	
			[order_id]		=  ['order_id'] if deri_test ==0 else ['order_id']	
			[order_status]	=  (['status']) if deri_test ==0 else ['order_status']
			buy         	=('buy' or 'buy')
			sell        	=('sell' or 'sell') 
			longs         	=('long'  if deri_test ==0 else 'buy')
			short         	=('short'  if deri_test ==0 else 'buy')
			limit    		=('lmt'  if deri_test ==0 else 'limit' ) 
			stop    		=('stop' if deri_test ==0 else 'stop') 
			curr    		= fut [3:][:3] #'xbt'/'xrp')
			TICK			= ([o['tickSize']  for o in [o for o in get_instruments_CF if  
								o['symbol']==fut]] [0]) if deri_test == 0 else (1/2)

			df				=	self.DF() if curr =='xbt' else self.DF_XRP()
			df['HMA']		= 	self.WMA(2 * self.WMA(df['close'], int(n/2)) - self.WMA(df['close'], n), int(np.sqrt(n)))
			df['up']		=	df['HMA'] .diff()

			hma_net			=int(df['up'].tail(1).values.tolist() [0])
			
			bid_oke			=True if hma_net > (1 if curr =='xbt' else  0) else False
			ask_oke			=True if hma_net < (-1 if curr =='xbt' else  0) else False
			hma_prc_buy		=	( abs(hma_net)  if curr =='xbt' else abs(hma_net)/XRP_ROUND )   if bid_oke==True else 0
			hma_prc_sell	= 	( abs(hma_net)   if curr =='xbt' else abs(hma_net)/XRP_ROUND )  if ask_oke==True else 0

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

			perp_test_xbt   =(1 if xbt_perp[0]==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)
			perp_test_xrp   =(1 if xrp_perp[0]==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)
			
			perp_test_CF    =perp_test_xbt if curr== 'xbt' else perp_test_xrp
			
			perp_test   =perp_test_CF if deri_test ==0 else (1 if fut [-10:] == '-PERPETUAL' else 0)

			fut_test_xbt =( 1 if ( xbt_fut[0] == fut   ) else 0 )
			fut_test_xrp =( 1 if ( xrp_fut[0] ==fut  ) else 0 ) 

			fut_test_CF    =fut_test_xbt if curr== 'xbt' else fut_test_xrp

			fut_test    =fut_test_CF if deri_test==0 else (1 if stamp_new == fut  else 0)

			QTY         = 20 if sub_name=='CF' else 50#
			QTY         = 20 if fut[3:][:3]=='xrp'else QTY#

			#mendapatkan isi ekuitas deribit vs crypto facilities (ada/tidak collateral)
			equity          = account_CF['balances']['xbt']>0
			
			equity          =   equity if deri_test == 0 else ( account['equity'
			] >0 and account ['currency']==fut [:3] )

			place_bids  =  equity==True  
			place_asks  =   equity==True  	

			#mendapatkan isi order book deribit vs crypto facilities 				
			ob              = json.loads(cfPublic.getorderbook(
				fut.upper()))['orderBook'
				] if deri_test==0 else  client_market.public_ticker_get(fut)['result']
	
			bid_prc         = ob['best_bid_price'] if deri_test == 1 else ob ['bids'][0][0]
			ask_prc         = ob ['best_ask_price'] if deri_test == 1 else ob ['asks'][0][0]

			bid_prc_fut         = (ask_prc - TICK) if deri_test==0 else (( [ o['ask_price'] for o in [o for o in instsB if o[instrument] == stamp_new and o[instrument] == fut   ] ] )[0])- TICK
		
			ask_prc_fut         =  (bid_prc + TICK) if deri_test==0 else (( [ o['bid_price'] for o in [o for o in instsB if o[instrument] == stamp_new  and o[instrument] == fut] ] )[0])+ TICK

			bid_prc_perp         =  (ask_prc - TICK) if deri_test==0 else ( [ o['bid_price'] for o in [
				o for o in instsB if o[instrument][-10:] == '-PERPETUAL' and o[instrument] == fut ] ] )[0]
			ask_prc_perp         = (bid_prc + TICK) if deri_test==0 else ( [ o['ask_price'] for o in [
				o for o in instsB if o[instrument] [-10:]== '-PERPETUAL' and o[instrument] == fut ] ] )[0]

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

			filledOrders_sell_lastTime_conv= 0 if filledOrders_sell_lastTime == 0 else (
				time_conversion ((filledOrders_sell_lastTime)) if deri_test == 0 else filledOrders_sell_lastTime)

			filledOrders_buy_lastTime_conv= 0 if filledOrders_buy_lastTime == 0 else (
				time_conversion ((filledOrders_buy_lastTime)) if deri_test == 0 else filledOrders_buy_lastTime)

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

			try:				
				open_limit=  [ o for o in[o for o in openOrders if o[
					orderType]== limit ]]
			except:
				open_limit  =0

			try:				
				open_stop=  [ o for o in[o for o in openOrders if o[
					orderType]== stop ]]
			except:
				open_stop  =0

			try:				
				open_stop_buy=  [ o for o in[o for o in open_stop if o[
					orderType]== 'buy' ]]
			except:
				open_stop_buy  =0

			try:				
				open_stop_sell=  [ o for o in[o for o in open_stop if o[
					orderType]== 'sell' ]]
			except:
				open_stop_sell  =0

			try:				
				open_limit_buy= [ o for o in[o for o in open_limit if o[
					side]== 'buy' ]]
			except:
				open_limit_buy  =0

			try:				
				open_limit_sell= [ o for o in[o for o in open_limit if o[
					side]== 'sell' ]]
			except:
				open_limit_sell  =0

			#menentukan kuantitas per  open order per instrumen

			openOrders_qty_buy 	=   sum([o[unfilledSize] for o in [
				o for o in openOrders if o[side] == 'buy'  ]])

			openOrders_qty_sell	=  sum([o[unfilledSize] for o in [
				o for o in openOrders if o[side] == 'sell'  ]])*-1

			openOrders_qty_Net	=  openOrders_qty_buy + openOrders_qty_sell

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

			print('openOrders_time_buy',openOrders_time_buy,'openOrders_time_sell',openOrders_time_sell)
			openOrders_time_buy_conv= 0 if openOrders_time_buy== 0 else ( 
				time_conversion( openOrders_time_buy) if deri_test == 0 else openOrders_time_buy)

			openOrders_time_sell_conv=  0 if openOrders_time_sell== 0 else (
				time_conversion( openOrders_time_sell) if deri_test == 0 else openOrders_time_sell)

			try:				
				open_limit_time_buy= [ o for o in[o for o in open_limit_buy if o[
					last_update_timestamp]== openOrders_time_buy ]]
			except:
				open_limit_time_buy  =0

			try:				
				open_limit_time_sell= [ o for o in[o for o in open_limit_sell if o[
					last_update_timestamp]== openOrders_time_sell ]]
			except:
				open_limit_time_sell  =0

			openOrders_prc_buy_limit= 0 if openOrders_time_buy== 0 else ([ o[limitPrice] for o in [
					o for o in open_limit_time_buy  ]])[0]

			openOrders_oid_buy_limit= 0 if openOrders_time_buy== 0 else ([ o[order_id] for o in [
					o for o in open_limit_time_buy  ]])[0]

			openOrders_oid_sell_limit=  0 if openOrders_time_sell== 0 else ([ o[order_id] for o in [
					o for o in open_limit_time_sell  ]])[0]		

			openOrders_oid_buy_stopLimit   = 0 if open_stop_buy==  []  else [ o[order_id] for o in [
					o for o in open_stop_buy if o[order_status] == 'untriggered'  ] ] [0]                          

			openOrders_prc_sell_limit= 0 if openOrders_time_sell==  0 else [ o[limitPrice] for o in [
					o for o in open_limit_time_sell  ]] [0]

			openOrders_oid_sell_stopLimit  = 0 if open_stop_sell== [] else [ o[order_id] for o in [
					o for o in open_stop_sell if  o[order_status] == 'untriggered'   ]] [0]

			#menghitung kuantitas stop order per instrumen
				#maks stop order 20
			openOrders_qty_buy_stop	= 0 if open_stop_buy== [] else sum([o[unfilledSize
			] for o in [o for o in open_stop_buy ]])

			openOrders_qty_sell_stop= 0 if open_stop_sell== []else sum([o[unfilledSize
			] for o in [o for o in open_stop_sell  ]])

			#menghitung kuantitas limit order per instrumen
#openOrders_time_sell 
			#qty individual
			openOrders_qty_sell_limit  = 0 if open_limit_time_sell== [] else [ o[unfilledSize] for o in [
					o for o in open_limit_time_sell  ]] [0]

			openOrders_qty_buy_limit  =  0 if openOrders_time_buy== 0 else [ o[unfilledSize] for o in [
					o for o in open_limit_time_buy ]] [0]

			openOrders_qty_sell_limit_sum  = 0 if open_limit_sell== [] else sum ([ o[unfilledSize] for o in [
					o for o in open_limit_sell]] )

			openOrders_qty_buy_limit_sum  = 0 if open_limit_buy== []else sum ([ o[unfilledSize] for o in [
					o for o in open_limit_buy]] )

			openOrders_qty_buy_limitLen=  0 if open_limit_buy== [] else len ([o[
			unfilledSize] for o in [o for o in open_limit_buy]]  )

			openOrders_qty_sell_limitLen= 0 if open_limit_sell== [] else len ([o[
			unfilledSize] for o in [o for o in open_limit_sell ]]  ) *-1
			#balancing saldo

			openOrders_oid_sell_limitBal=  0 if open_limit_sell== [] else max([o[unfilledSize] for o in [o for o in open_limit_sell   ]]  )

			openOrders_oid_sell_limitBal=  0 if openOrders_oid_sell_limitBal== 0 else ([o[order_id] for o in [o for o in open_limit_sell if  (
				o[unfilledSize])  ==openOrders_oid_sell_limitBal ]]  )

			openOrders_buy_oid_limitBal=  0 if open_limit_buy== []  else max([o[unfilledSize] for o in [o for o in open_limit_buy   ]]  )

			openOrders_oid_sell_limitBal=  0 if openOrders_buy_oid_limitBal== 0 else ([o[order_id] for o in [o for o in open_limit_buy if  (
				o[unfilledSize])  ==openOrders_buy_oid_limitBal ]]  )

			stop_total_qty_fut	=  (openOrders_qty_buy_stop+ abs(openOrders_qty_sell_stop))

			#menghitung waktu stop order per instrumen ada di platform
				#maks stop order 20
	
			openOrders_buy_minTime_stopLimit	= 0 if open_stop_buy== [] else (time_conversion (min( [ o[
					last_update_timestamp] if deri_test == 0 else min( o
				[last_update_timestamp])  for o in [o for o in open_stop_buy  ]] )) )
	
			openOrders_sell_minTime_stopLimit= 0 if open_stop_sell== [] else (time_conversion (min( [ o[
					last_update_timestamp] if deri_test == 0 else min( o
				[last_update_timestamp])  for o in [o for o in open_stop_sell  ]])) )

			openOrders_qty_sell_filled=   0 if open_limit_sell== [] else ([o[
			'filledSize'] for o in [o for o in open_limit_sell  ]]  )[0] *-1

			openOrders_qty_buy_filled=  0 if open_limit_buy== [] else ([o[
			'filledSize'] for o in [o for o in open_limit_buy]]  ) [0]

			net_perp= abs(hold_qty_sell) - (openOrders_qty_buy)
			net_fut= abs(hold_qty_buy) -  abs(openOrders_qty_sell)

			filledOpenOrders_qty_totalNet= max(net_perp,net_fut) 

			for i in range(max(nbids, nasks)):
        
				#PILIHAN INSTRUMEN
				#perpetual= diarahkan posisi sell karena funding cenderung berada di sell
				#lawannya, future dengan tanggal jatuh tempo terlama (mengurangi resiko forced sell)-->1

					#menghitung waktu open di order book

				open_time_buy = 0 if openOrders_time_buy == 0 else (
						openOrders_time_buy_conv if deri_test == 0 else (start_unix/1000- (
							openOrders_time_buy)/1000))

				open_time_sell = 0 if openOrders_time_sell == 0 else (
						openOrders_time_sell_conv if deri_test == 0 else (start_unix/1000- (
							openOrders_time_sell)/1000))
			
					#menghitung waktu terakhir kali order dieksekusi
				filled_time_buy = 0 if filledOrders_buy_lastTime == 0 else (
						filledOrders_buy_lastTime_conv if deri_test == 0 else (start_unix/1000- (
							filledOrders_buy_lastTime)/1000))

				filled_time_sell = 0 if filledOrders_sell_lastTime == 0 else (
						filledOrders_sell_lastTime_conv if deri_test == 0 else (start_unix/1000- (
							filledOrders_sell_lastTime)/1000))

				if  abs (hold_qty_sell) == QTY:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*20)
				elif  abs (hold_qty_sell) <= QTY*20:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*40)
				elif  abs (hold_qty_sell) <= QTY*40:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*80)
				elif  abs (hold_qty_sell) <= QTY*80:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*160)
				elif  abs (hold_qty_sell) <= QTY*160:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*320)
				elif  abs (hold_qty_sell) <= QTY*320:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*640)
				else:
					IDLE_TIME = 0

				if  abs (hold_qty_buy) == QTY:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*20)
				elif  abs (hold_qty_buy) <= QTY*20:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*40)
				elif  abs (hold_qty_buy) <= QTY*40:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*80)
				elif  abs (hold_qty_buy) <= QTY*80:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*160)
				elif  abs (hold_qty_buy) <= QTY*160:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*320)
				elif  abs (hold_qty_buy) <= QTY*320:
					IDLE_TIME = IDLE_TIME + (IDLE_TIME * MARGIN*640)
				else:
					IDLE_TIME = 0
							#batasan transaksi


				IDLE_TIME=720

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

#TODO:
				print (CYAN + str((fut,'hma_net',hma_net,'bid_oke',bid_oke,'ask_oke',ask_oke)),ENDC)
				print (BLUE + str((fut,'IDLE_TIME',IDLE_TIME,'delta_time_sell',delta_time_sell,'delta_time_buy',delta_time_buy)),ENDC)

#				print(fut, 'filledOrders_buy_lastTime',filledOrders_buy_lastTime,
#				'filledOrders_sell_lastTime',filledOrders_sell_lastTime)
								
#				print(fut, 'openOrders_time_buy_conv',openOrders_time_buy_conv,
#				'openOrders_time_sell_conv',openOrders_time_sell_conv,
#				'filledOrders_buy_lastTime_conv',filledOrders_buy_lastTime_conv,
#				'filledOrders_sell_lastTime_conv',filledOrders_sell_lastTime_conv)
#				print(fut, 'open_time_buy',open_time_buy,
#				'open_time_sell',open_time_sell,'filled_time_sell',
#				filled_time_sell,'filled_time_buy',filled_time_buy)
#TODO:

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
    
				if  (fut_test==1 and open_time_buy >90) or (perp_test==1 and open_time_sell >90) :# hanya berlaku bagi beli/jual, bukan lawan transaksi
					
					print(BLUE + str((fut,'444','open_time_buy',open_time_buy,'open_time_sell',open_time_sell,
					'max (open_time_buy,open_time_sell)',max (open_time_buy,open_time_sell) )),ENDC)

					if perp_test==1 and openOrders_oid_sell_limit != 0  : 													
						cfPrivate.cancel_order(openOrders_oid_sell_limit) if deri_test == 0 else (
								client_trading.private_cancel_get(openOrders_oid_sell_limit))

					if fut_test==1  and openOrders_oid_buy_limit !=0:                                                   
						cfPrivate.cancel_order(openOrders_oid_buy_limit) if deri_test == 0 else (
							client_trading.private_cancel_get(openOrders_oid_buy_limit))

				if  max(openOrders_qty_buy_limitLen,openOrders_qty_sell_limitLen) > FREQ   :	
					
					print(BLUE + str((fut,'555','openOrders_qty_buy_limitLen',openOrders_qty_buy_limitLen,'openOrders_qty_sell_limitLen',openOrders_qty_sell_limitLen,
					'max(openOrders_qty_buy_limitLen,openOrders_qty_sell_limitLen)',max(openOrders_qty_buy_limitLen,openOrders_qty_sell_limitLen) )),ENDC)

					if perp_test==1 : 													

						if  openOrders_oid_buy_limit != 0:
    							
							cfPrivate.cancel_order(openOrders_oid_buy_limit) if deri_test == 0 else (
							client_trading.private_cancel_get(openOrders_oid_buy_limit)   )  

						if  openOrders_oid_sell_limitBal != 0:
    							
							cfPrivate.cancel_order(openOrders_oid_sell_limitBal) if deri_test == 0 else (
							client_trading.private_cancel_get(openOrders_oid_sell_limitBal)   )  

					if fut_test==1 : 													

						if  openOrders_oid_sell_limit != 0 :
    							
							cfPrivate.cancel_order(openOrders_oid_sell_limit) if deri_test == 0 else (
							 client_trading.private_cancel_get(openOrders_oid_sell_limit) )                                                  
 			                                                	
						if  openOrders_oid_sell_limitBal != 0 :
    							
							cfPrivate.cancel_order(openOrders_oid_sell_limitBal) if deri_test == 0 else (
							 client_trading.private_cancel_get(openOrders_oid_sell_limitBal) )                                                  
 
 
				mod_buy 	= (hold_qty_buy) % QTY
				mod_sell 	= abs(hold_qty_sell) % QTY

				default_order_limit = {
									"orderType": "post",
									"symbol": fut.upper(),
									"reduceOnly": "false"
									}
				

				stop_order = {
					"orderType": "stp",
					"symbol": fut.upper(),
					"limitPrice": 1.00,
					"stopPrice": 2.00,
					"cliOrdId": "my_stop_client_id"
					}
#TODO:'place_bids'
				if place_bids:

					default_order_limit= (dict(default_order_limit,**{"side": "buy"}))
					default_order_stop= (dict(default_order_limit,**{"side": "buy"}))

					stop_prc_perp=   max( ask_prc_perp,( float(openOrders_prc_sell_limit+TICK ) ) )
					
					if   perp_test==1 :

						test_time		=	(filledOrders_sell_lastTime_conv < openOrders_time_buy_conv or openOrders_time_buy_conv ==0) and (
							filledOrders_sell_lastTime_conv < 3600
						)
						
						test_qty_stop 	=	False
						
						test_qty_sum 	=	abs(hold_qty_sell) >  openOrders_qty_buy_limit_sum and abs(
											hold_qty_sell) > 0 #4 menjamin order sell maks = order buy

						test_qty_mod 	=	mod_sell ==0
						
						test_qty_freq 	=  openOrders_qty_buy_limitLen < FREQ#3 boleh sampai 5 misalnnya

						test_pct_sum 	=  False if abs(hold_qty_sell)==0 else (openOrders_qty_buy_limit_sum /abs(hold_qty_sell)) < 40/100#ini buat apa ya ? kayaknya nggak perlu deh

						prc_limit		=	min(bid_prc_perp,(int(filledOrders_prc_sell  - (hma_prc_sell)) if curr== 'xbt' else float( (round(
									 		filledOrders_prc_sell  - (hma_prc_sell),8)))))-TICK

						prc_stop		=   int(openOrders_prc_sell_limit-(DELTA_PRC * openOrders_prc_sell_limit)) if curr== 'xbt' else float(
							(round(openOrders_prc_sell_limit  - (DELTA_PRC *abs(openOrders_prc_sell_limit)),8)))

						prc_net			= 	min(bid_prc, int(hold_avgPrc_sell-(hold_avgPrc_sell * MARGIN * .7)) if curr=='xbt' else float(
								 			(round(hold_avgPrc_sell-(hold_avgPrc_sell * MARGIN * .7),8))) )   #.7 hitungan kasar rata2 untuk BEP                                                

						qty_net			=	((abs(hold_qty_sell) - abs(filledOrders_qty_sell)) ) if abs(
											hold_qty_sell) > QTY else abs(hold_qty_sell)
													
		#FIXME: kalau stop dah jalan
							#NORMAL, stop limit seketika setelah eksekusi order ABAIKAN DULU

						if  (test_qty_stop == True ) :
    							
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

		#FIXME: kalau stop dah jalan

							#NORMAL,  limit seketika setelah eksekusi order

						if (test_time == True and test_qty_sum == True ):													

							qty=abs(filledOrders_qty_sell)

							print(GREEN + str((fut,'#NORMAL, bila limit diekseskusi','test_qty_stop',
							test_qty_stop,'test_qty_mod',test_qty_mod,
							'test_time',test_time,'filledOrders_buy_lastTime_conv', filledOrders_buy_lastTime_conv,
                            'openOrders_time_sell_conv',  openOrders_time_sell_conv,'qty',qty,'prc_limit',prc_limit)),ENDC)
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
    									
								cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty,"limitPrice":prc_limit}))

		#FIXME: dipikirin lagi buat prc net, prc_limit < 0 biar salah aja

						#pengimbang saldo sell, sisa apa pun, dimasukkan ke average 						
						elif  test_qty_sum==True  and (prc_net !=0 and qty_net !=0) and prc_limit < 0  :											

							qty=abs(filledOrders_qty_sell)
							print(GREEN + str((fut,'#pengimbang AVG DOWN','hold_qty_sell',abs(hold_qty_sell),
							'(abs(hold_qty_sell)-abs(openOrders_qty_buy_limit)) >= 0',
							(abs(hold_qty_sell)-abs(openOrders_qty_buy_limit)) > 0,
							abs(openOrders_qty_buy_limit),'test_qty_freq',test_qty_freq,'qty',qty_net,
							'prc',prc_net,'(test_pct_sum',test_pct_sum,'prc_limit',prc_limit)),ENDC)

							if deri_test == 1 :

								client_trading.private_buy_get(
								instrument_name =fut,
								reduce_only     ='false',
								type            =limit,
								price           =prc_limit,#seharusnya prc_net ,
								post_only       ='true',
								amount          =QTY#seharusnya qty_net ,
								)	

							if deri_test == 0 :

								cfPrivate.send_order_1(dict(default_order_limit,**{"size": QTY,"limitPrice":prc_limit}))

		#FIXME: dipikirin lagi buat prc net

						#memastikan hanya ada 1 order setiap waktu
						elif  openOrders_qty_buy_stop >QTY :			

							cfPrivate.cancel_order(openOrders_oid_buy_stopLimit) if deri_test == 0 else client_trading.private_cancel_get(openOrders_oid_buy_stopLimit) 			

						#NORMAL,, pasang posisi beli pada QTY =0/avg down  					                                                    							
					elif  fut_test==1 and (openOrders_qty_buy == 0 or  openOrders_qty_buy_filled !=0) and bid_oke==True:#or open_time ==0

						test_qty =True# (( abs(openOrders_qty_buy_limit_sum))< (QTY )  and hold_qty_buy !=0 ) 
						test_qty_zero =  ((hold_qty_buy ==0 and openOrders_qty_buy_limit == 0))
						#test_qty_mod = mod_buy !=0  
						test_time = delta_time_buy > IDLE_TIME
						#test_prc = bid_prc_fut < bid_prc_down

						print(GREEN + str((fut,'#NORMAL AAA, pasang posisi beli pada QTY =0/avg down','test_time', delta_time_buy > IDLE_TIME,
							'test_qty_zero',((hold_qty_buy ==0 and openOrders_qty_buy_limit == 0)),'test_qty_mod',mod_buy !=0 ,
                            'delta_time_buy',delta_time_buy,'IDLE_TIME',IDLE_TIME,'prc',bid_prc_fut,
							'QTY',QTY,'openOrders_qty_buy',openOrders_qty_buy,'openOrders_qty_buy_filled',openOrders_qty_buy_filled
							)),ENDC)			
										
						if  test_time == True   or (
							test_qty_zero ==True ):
    							
							prc= bid_prc_fut
							qty= QTY

							if deri_test == 1 :

								client_trading.private_buy_get(
								instrument_name=fut,
								amount=QTY,
								price=prc,
								type=limit,
								reduce_only='false',
								post_only='true'
								)		

							if deri_test == 0  :
								cfPrivate.send_order_1(dict(default_order_limit,**{"size": QTY,"limitPrice":prc}))

	
#TODO:'place_asks'

				# OFFERS

				if place_asks:

					default_order_limit= (dict(default_order_limit,**{"side": "sell"}))

					stop_prc_fut=   min( bid_prc_fut,float (openOrders_prc_buy_limit-(
						TICK ) ) )					

					if   fut_test==1 : 
 	
						test_time		= 	(filledOrders_buy_lastTime_conv < openOrders_time_sell_conv or openOrders_time_sell_conv ==0) and (
							filledOrders_buy_lastTime_conv < 3600
						)
												
						test_qty_stop 	=	False
						
						test_qty_sum 	= 	abs(openOrders_qty_sell_limit_sum) < hold_qty_buy and abs(
											abs(hold_qty_buy) ) > 0 
						test_qty_mod 	= 	mod_buy ==0
						test_qty_freq 	=  abs(openOrders_qty_sell_limitLen ) < FREQ
						test_pct_sum 	=  False if abs(hold_qty_buy)==0 else (
											openOrders_qty_sell_limit_sum /abs(hold_qty_buy)) < 40/100

						prc_stop		=   int(openOrders_prc_buy_limit+(DELTA_PRC * openOrders_prc_buy_limit)) if curr== 'xbt' else float(
											(round(openOrders_prc_buy_limit  + (DELTA_PRC *abs(openOrders_prc_buy_limit)),8))
						)
						prc_net			=	max(ask_prc, int(hold_avgPrc_buy+(hold_avgPrc_buy*MARGIN * .7)) if curr=='xbt' else float(round(
											hold_avgPrc_buy+(hold_avgPrc_buy*MARGIN * .7),8)) )
						
						prc_limit		=	max(ask_prc_fut,int(filledOrders_prc_buy+(hma_prc_buy)) if curr== 'xbt' else float( (round(
										filledOrders_prc_buy+(hma_prc_buy),8)))) + TICK
					
						qty_net= ((abs(hold_qty_buy) - abs(filledOrders_qty_buy)) ) if abs(
							hold_qty_buy) > QTY else abs(hold_qty_buy)

						#NORMAL,  limit seketika setelah eksekusi order

						if (test_time == True and test_qty_sum == True ):													
							qty= abs(filledOrders_qty_buy)
							print(RED + str((fut,'#NORMAL, bila limit diekseskusi','test_time',test_time,
                            'filledOrders_buy_lastTime_conv', filledOrders_buy_lastTime_conv,'openOrders_time_sell_conv',  openOrders_time_sell_conv,
							'test_qty_sum',test_qty_sum,'test_qty_mod',test_qty_mod,'prc_limit',prc_limit,'filledOrders_qty_buy',filledOrders_qty_buy
							)),ENDC)	
														
							if deri_test == 1 and prc_limit !=0:

								client_trading.private_sell_get(
								instrument_name=fut,
								reduce_only='false',
								type=limit,
								price=prc_limit,
								post_only='true',
								amount=qty)	

							if deri_test == 0 and prc_limit !=0:

								cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty,"limitPrice":prc_limit}))

						#pengimbang saldo sell, sisa apa pun, dimasukkan ke average 						
						if  test_qty_sum==True  and (prc_net !=0 and qty_net !=0) and prc_limit < 0:
		#FIXME: dipikirin lagi buat prc net, prc_limit < 0 biar salah aja
					
							if deri_test == 1 :																		
								client_trading.private_sell_get(
								instrument_name=fut,
								reduce_only='false',
								type=limit,
								price=prc_limit,#seharusnya prc_net,
								post_only='true',
								amount=QTY#seharusnya qty_net ,
								)	

							if deri_test == 0 :

								cfPrivate.send_order_1(dict(default_order_limit,**{"size": QTY,"limitPrice":prc_limit}))
		#FIXME: dipikirin lagi buat prc net

		#FIXME: kalau stop dah jalan

						#NORMAL, stop limit seketika setelah eksekusi order

						elif (test_qty_stop == True and  test_prc==True): 

							qty= abs(filledOrders_qty_buy)
							print(RED + str((fut,'#NORMAL, bila limit diekseskusi','test_qty',test_qty,'test_time',test_time,
                            'filledOrders_buy_lastTime_conv', filledOrders_buy_lastTime_conv,'openOrders_time_sell_conv',  openOrders_time_sell_conv,
							'test_prc',test_prc,'test_qty_mod',test_qty_mod)),ENDC)			
			
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

		#FIXME: kalau stop dah jalan

						#memastikan hanya ada 1 order setiap waktu
						elif  abs(openOrders_qty_sell_stop) > QTY :
							cfPrivate.cancel_order(openOrders_oid_sell_stopLimit) if deri_test == 0 else (
								client_trading.private_cancel_get(openOrders_oid_sell_stopLimit))

						#NORMAL,, pasang posisi beli pada QTY =0/avg up  					                                                    							
					elif   perp_test==1 and (openOrders_qty_sell == 0 or  openOrders_qty_sell_filled !=0 ) and ask_oke==True:

						test_qty =True# ( abs(openOrders_qty_sell_limit_sum)  < (QTY ) and abs(hold_qty_sell) !=0 ) 
						test_qty_zero =  hold_qty_sell ==0 and abs(openOrders_qty_sell_limit) ==0
						#test_qty_mod = mod_sell !=0  
						test_time = delta_time_sell > IDLE_TIME
						#test_prc = True

						print(RED + str((fut,'#NORMAL,pasang posisi beli pada QTY =0/avg up','test_time', delta_time_sell > IDLE_TIME,
						'test_qty_zero',test_qty_zero,
							'test_qty_mod',test_qty_mod,'delta_time_sell',delta_time_sell,'IDLE_TIME',IDLE_TIME)),ENDC)			
										
						if  (test_qty == True and test_time == True )  or (
							test_qty_zero ==True):

							prc= ask_prc_perp
							qty= QTY 
							
							if deri_test == 1 :
								client_trading.private_sell_get(
								instrument_name=fut,
								reduce_only='false',
								type=limit,
								price=max(prc,ask_prc) ,
								post_only='true',
								amount=QTY
								)	

							if deri_test == 0:
								cfPrivate.send_order_1(dict(default_order_limit,**{"size": QTY,"limitPrice":prc}))
								
				counter= get_time - (stop_unix/1000)
				qty= max (hold_qty_buy,abs(hold_qty_sell))
				waktu = NOW_TIME
				my_message= (f"  {waktu}  {fut}  {filledOpenOrders_qty_totalNet}")

				if filledOpenOrders_qty_totalNet !=0   and filledOrders_buy_lastTime_conv > IDLE_TIME:
					telegram_bot_sendtext(my_message)
		
				if counter > (12 if equity !=0 else 0):# if deri_test ==1 else 10:
					while True:
						self.restart_program()
					break
									
				print(BOLD + str((fut,'counter',counter,'bid_oke==False and fut_test==1 A',bid_oke==False and 
				fut_test==1,'ask_oke==False and perp_test==1',ask_oke==False and perp_test==1)),ENDC)

				if counter > (9 if equity !=0 else 0) and (
					(bid_oke==False and fut_test==1) or (ask_oke==False and perp_test==1)):

					while True:
						print(BOLD + str((fut,'counter',counter,'test_time',test_time)),ENDC)
						sys.exit()
					break


	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

	def run(self):

		self.run_first()

		while True:

			self.place_orders()

	def run_first(self):

		self.create_client()
		self.create_client_account()
		self.create_client_trading()
		self.create_client_public()
		self.create_client_private()
		self.create_client_market()
		self.logger = get_logger('root', LOG_LEVEL)



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
#TODO:
#FIXME:
# formula ambila laba masih salah. Qty 400, jual 100, jual berikutnya masih pakai hatga terakhir (harusnya dah avg)
