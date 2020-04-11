
from collections import OrderedDict

import os
import sys
import logging, math
import time
from time import sleep
from datetime import datetime, timedelta
print((f"  AA  {datetime.now()} "))

from os.path import getmtime
import argparse,  traceback
import requests
print((f"  AAB  {datetime.now()} "))

from api import RestClient
import openapi_client
print((f"  AAC {datetime.now()} "))

from openapi_client.rest import ApiException
import cfRestApiV3 as cfApi
print((f"  AAD  {datetime.now()} "))

import ssl
print((f"  AAD1  {datetime.now()} "))

import pandas as pd  
print((f"  AAD2  {datetime.now()} "))

import numpy as np
print((f"  AAD3  {datetime.now()} "))

import  json
print((f"  AAD4  {datetime.now()} "))

from functools import lru_cache


TEST=0

TEST=TEST+1

print((f"  AB {TEST} {datetime.now()} "))


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

print((f"  AC {TEST} {datetime.now()} "))


NOW_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 1, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(NOW_TIME.timetuple())*1000

print((f"  A {TEST} {datetime.now()} "))


chck_key=str(int(start_unix/1000))[8:9]#memperkenalkan random untuk multi akun

#FIXME:
TRAINING=False#True#
endpoint_training  = "https://conformance.cryptofacilities.com/derivatives"
endpoint_production="https://www.cryptofacilities.com/derivatives"
apiPublicKey_training = "PlRnNMw9jpQw1Cnxel99eVqjAp00fCypDdc4zC4godZJa91Y4UXfMHMz"
apiPublicKey_production = "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
apiPrivateKey_training ="3k8j0gangNZ/+B0Zxi8WNfpd+6ETXfJf+f/sD3H+K6dolQ5dlw4EtK6VzZxU7LqjktZVgHSdosdT7qxZKcU5sK/Q"
apiPrivateKey_production ="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"
print((f"  B {TEST} {datetime.now()} "))

apiPath = endpoint_production if TRAINING==False else endpoint_training 
apiPrivateKey =apiPrivateKey_production if TRAINING==False else apiPrivateKey_training
apiPublicKey = apiPublicKey_production if TRAINING==False else apiPublicKey_training
checkCertificate = True if TRAINING==False else False # False# # when using the test environment, this must be set to "False"
timeout = 5
useNonce = False  # nonce is optional

cfPublic = cfApi.cfApiMethods(apiPath, timeout=timeout, checkCertificate=checkCertificate)
cfPrivate = cfApi.cfApiMethods(apiPath, timeout=timeout, apiPublicKey=apiPublicKey, apiPrivateKey=apiPrivateKey, checkCertificate=checkCertificate, useNonce=useNonce)
print((f"  C{TEST} {datetime.now()} "))

key = "_zEH40KQ"
secret = "UJoBPSraxZvVzM42MMjiygTYUzKoSu3skyG2EE7wN90"
#mwa9
#if  chck_key == '1'or chck_key=='3' or chck_key=='5' or chck_key=='7' or chck_key=='9':
#	key = "_zEH40KQ"
#	secret = "UJoBPSraxZvVzM42MMjiygTYUzKoSu3skyG2EE7wN90"

#mwa8
#elif  chck_key == '0'or chck_key=='2' or chck_key=='4' or chck_key=='6' or chck_key=='8':
    
#	key = "DhlgfdXo"
#	secret ="PJCtPjbB8VphCpF2oSNV0DBb51hZJ0sLGpZ-21-96as"

#else  :
#	key = ""
#	secret = ""

deribitauthurl = "https://deribit.com/api/v2/public/auth"

#PARAMS = {'client_id': key, 'client_secret': secret, 'grant_type': 'client_credentials'}

#data = requests.get(url=deribitauthurl, params=PARAMS).json()

#accesstoken = data['result']['access_token']

configuration = openapi_client.Configuration()
#configuration.access_token = accesstoken
api=openapi_client

#client_account = api.AccountManagementApi(api.ApiClient(configuration))
#client_trading = api.TradingApi(api.ApiClient(configuration))
client_public = api.PublicApi(api.ApiClient(configuration))
#client_private = api.PrivateApi(api.ApiClient(configuration))
#client_market = api.MarketDataApi(api.ApiClient(configuration))

print((f"  D {TEST} {datetime.now()} "))
         
sender_email =  'ringkasan.akun@gmail.com'
receiver_email = 'venoajie@gmail.com'
password = 'ceger844579*'


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


MARGIN      = 1/100
DELTA_PRC	=  MARGIN/20
IDLE_TIME   = 600 #nggak jalan?
LOG_LEVEL   = logging.INFO
INTERVAL	= 3 #5 minutes
XRP_ROUND	=100000000
COUNTER		=5
FREQ		= 8
RED   		= '\033[1;31m'#Sell
BLUE  		= '\033[1;34m'#information
CYAN 	 	= '\033[1;36m'#execution (non-sell/buy)
GREEN 		= '\033[0;32m'#blue
RESET 		= '\033[0;0m'
BOLD    	= "\033[;1m"
REVERSE 	= "\033[;7m"
ENDC 		= '\033[m' # 


TEST=TEST+1
print((f"  E {TEST} {datetime.now()} "))

def time_conversion( waktu ):

	time_now        =	time.mktime(NOW_TIME.timetuple())
	conv_formula	=  	time.mktime (datetime.strptime(waktu,'%Y-%m-%dT%H:%M:%S.%fZ').timetuple() )
	konversi 		= 	time_now - conv_formula

	return konversi

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

def telegram_bot_sendtext(bot_message):

	bot_token   = '1035682714:AAGea_Lk2ZH3X6BHJt3xAudQDSn5RHwYQJM'
	bot_chatID  = '148190671'
	send_text   = 'https://api.telegram.org/bot' + bot_token + (
								'/sendMessage?chat_id=') + bot_chatID + (
							'&parse_mode=Markdown&text=') + bot_message

	response    = requests.get(send_text)

	return response.json()
print((f"  F{TEST} {datetime.now()} "))

class MarketMaker(object):

	def __init__(self, monitor=True, output=True):

		self.client = None
#		self.client_trading = None
#		self.client_public = None
#		self.client_private = None
#		self.client_market = None
#		self.client_market = None
		self.futures = OrderedDict()
		self.logger = None
		self.monitor = monitor
		self.output = output or monitor
		self.position = OrderedDict()
		self.positions = OrderedDict()

	def create_client(self):

		self.client = RestClient(key, secret, deribitauthurl)

#	def create_client_public(self):
#		self.client_public = client_public

#	def create_client_private(self):
#		self.client_private =  client_private

#	def create_client_account(self):
#		self.client_account = client_account

#	def create_client_trading(self):
#		self.client_trading =  client_trading

#	def create_client_market(self):
#		self.client_trading =  client_market
	
	TEST=0
	print((f"  G {TEST} {datetime.now()} "))

#	@lru_cache(maxsize=None)
#	def book_summary_drbt( self, currency):
    		
#		book_summ = client_market.public_get_book_summary_by_currency_get(
#					currency, kind='future')['result']

#		futures = sort_by_key({i['instrument_name']: i for i in (book_summ)})			
		
#		return book_summ

	TEST=TEST+1
	print((f" 3 {TEST} {datetime.now()}  "))

	@lru_cache(maxsize=None)
	def get_bbo_drbt( self, book_summ, contract ):
    		
		ob_drbt 	=	(  [ o for o in [o for o in book_summ if o[
						'instrument_name']==contract   ]]  )[0]
		bid_prc		=  ob_drbt ['bid_price']
		ask_prc		=  ob_drbt ['ask_price']
		  		
		return { 'bid': bid_prc, 'ask': ask_prc }

	@lru_cache(maxsize=None)
	def get_bbo( self, contract ):
    				
		ob_cf		= json.loads(cfPublic.getorderbook(contract.upper()))['orderBook'] 
	
		bid_prc         =  ob_cf ['bids'][0][0]
		ask_prc         =  ob_cf ['asks'][0][0]

		return { 'bid': bid_prc, 'ask': ask_prc }

				
	@lru_cache(maxsize=None)
	def DF(self,endpoint):  

		INSTRUMENT_NAME = 'BTC-PERPETUAL'
		params = {
			'instrument_name': INSTRUMENT_NAME,
			'start_timestamp': int(start_unix),
			'end_timestamp': int(stop_unix),
			'resolution': INTERVAL
		}

		
		df = pd.DataFrame(requests.get(endpoint, params=params).json()['result']).tail(50) 

		columns_to_delete = ['open', 'high','low','cost','volume','status']
		
		df.drop(columns_to_delete, inplace=True, axis=1)

		df['ticks']=pd.to_datetime(df['ticks'],unit='ms')

		return df

	TEST=TEST+1
	print((f" 4 {TEST}{datetime.now()}"))

	@lru_cache(maxsize=None)

	def DF_XRP(self,endpoint):  # Get all current futures instruments


		df_xrp			= 	pd.DataFrame((requests.get(endpoint).json()['result']['XXRPXXBT'])).tail(50) 
		
		df_xrp 			= 	df_xrp.rename(columns={
							0: 'ticks',1: 'open',2: 'high',3: 'low',
							4: 'close_fl',5: 'vwap',6: 'volume',7: 'count' })
		
		columns_to_delete = ['open', 'high','low','vwap','volume','count']
		
		df_xrp.drop(columns_to_delete, inplace=True, axis=1)
		
		df_xrp['ticks']	=	pd.to_datetime(df_xrp['ticks'],unit='s')

		df_xrp['close']	=	pd.Series((df_xrp['close_fl'])).astype(float)*XRP_ROUND

		return df_xrp


	TEST=TEST+1
	print((f" 5 {TEST}{datetime.now()} "))
	
	def WMA(self,df, n,column='close'):
    		
		ws 		= np.zeros(df.shape[0])
		t_sum 	= sum(range(1, n+1))
	
		for i in range(n-1, df.shape[0]):
			ws[i] = sum(df[i-n+1 : i+1] * np.linspace(1, n, n))/ t_sum
			
		return ws #https://github.com/LastAncientOne/Stock_Analysis_For_Quant/blob/master/Python_Stock/Technical_Indicators/WMA.ipynb


	TEST=TEST+1
	print((f" 6 {TEST}{datetime.now()} "))


	def HMA(self,df, n):
    		
		hma 	= self.WMA(2 * self.WMA(df, int(n/2)) - self.WMA(df, n), int(np.sqrt(n)))
			
		return hma #https://github.com/kylejusticemagnuson/pyti/blob/master/pyti/hull_moving_average.py

	@lru_cache(maxsize=None)
	def filledOrder_cf(self,contract ):
    						
		return  [ o for o in [o for o in json.loads(cfPrivate.get_fills())[
									'fills'] if o['symbol']==contract   ]] 


	@lru_cache(maxsize=None)
	def account_drbt(self,contract ):
    						
		return  (client_account.private_get_account_summary_get(
                                        currency=(contract[:3]), extended='true')['result'])

	@lru_cache(maxsize=None)
	def account_CF(self ):
    						
		return  json.loads(cfPrivate.get_accounts())['accounts']['fi_xbtusd']

	@lru_cache(maxsize=None)
	def get_instruments_CF(self ):
    						
		return  json.loads(cfPublic.getinstruments())['instruments']

#	def filledOrder_drbt(self,contract ):

#		return client_trading.private_get_order_history_by_instrument_get (
#											instrument_name=contract, count=10)['result']

	def filter_one_var(self,data,result,filter,member,attr ):
    
		try:
			filter	=  attr([o[result] for o in [o for o in data if o[filter] == member ]])
		
		except:
			filter 	= []

		return filter

	TEST=TEST+1
	print((f" 7 {TEST} {datetime.now()} "))

	def summary_account (self,names,side,avg,tickers_instrument,qty,open_instrument,len_instrument):
  
		names =names
		qty =qty
		avg = avg
		side =side
		ticker =tickers_instrument
		open_instrument=open_instrument
		longest_string = max(map(len, names)) 
		titles = ['instruments', 'side', 'avg_prc','ticker','hold_qty', 'open_qty','freq_qty']
		data = [titles] + list(zip(names, side,  avg,tickers_instrument,qty, open_instrument,len_instrument))

		for i, d in enumerate(data):
			line = '|'.join(str(x).ljust(longest_string + 2) for x in d)
			print(CYAN + str(line),ENDC)
			if i == 0:
				print(RED + str('-' * len(line)),ENDC)

	def format_matrix(self,header, matrix,top_format, left_format, cell_format, row_delim, col_delim):
		table = [[''] + header] + [[name] + col for name, col in zip(header, matrix)]
		table_format = [['{:^{}}'] + len(header) * [top_format]] \
                    + len(matrix) * [[left_format] + len(header) * [cell_format]]
		col_widths = [max(
                        len(format.format(cell, 0))
                        for format, cell in zip(col_format, col))
                    for col_format, col in zip(zip(*table_format), zip(*table))]
		return row_delim.join(
                col_delim.join(
                    format.format(cell, width)
                    for format, cell, width in zip(row_format, row, col_widths))
                for row_format, row in zip(table_format, table))

	def filter_two_var(self,data,result,filter1,member1,filter2,member2,attr ):
    
		try:
			filter	=  attr([o[result] for o in [o for o in data if o[filter1] == member1 and  o[filter2] == member2 ]])
		
		except:
			filter 	= []

		return filter


	def filter_no_var(self,data,result ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data  ]])
		except:
			filter 	= []

		return filter

	TEST=TEST+1
	print((f" 8 {TEST}{datetime.now()}"))

	#@lru_cache(maxsize=None)
	def place_orders(self):				
	
#		get_instruments_drbt			=	self.book_summary_drbt('BTC')

#		self.get_instruments_drbt 	= 	sort_by_key({i['instrument_name']: i for i in (get_instruments_drbt)})	

#		deri			= list((self.futures).keys())
		TEST=8
		print((f" 8A {TEST}{datetime.now()} "))
		 					
	#	stamp			=  [o['instrument_name']  for o in [o for o in get_instruments_drbt if  len(o['instrument_name'])==11 
     #                                               ]]
	#	stamp_new		=  (  min( (stamp)[0],(stamp)[1]))

		get_instruments_CF           = self. get_instruments_CF()

		print((f" 8B {TEST}{datetime.now()} "))

		xbt_perp		= ['pi_xbtusd']

		xbt_fut			=[max( [ o['symbol'] for o in[
							o for o in get_instruments_CF if o[
								'symbol'][3:][:3]=='xbt' and len(o[
									'symbol'])<=16 and o['symbol'][:1] == 'f'  ]])]

		xbt_fut_min			=[min( [ o['symbol'] for o in[
							o for o in get_instruments_CF if o[
								'symbol'][3:][:3]=='xbt' and len(o[
									'symbol'])<=16 and o['symbol'][:1] == 'f'  ]])]
		xrp_perp		= ['pv_xrpxbt']

		xrp_fut			= [ o['symbol'] for o in[o for o in get_instruments_CF if (
							o['symbol'][3:][:3]=='xrp' and o['symbol'][3:][3:][
								:3] !='usd'and  (o['symbol'][:1] == 'f' ))  ]]

		print((f" 8C {TEST}{datetime.now()} "))

		instruments_list_ori= list( xbt_perp + xbt_fut+ xbt_fut_min+xrp_perp + xrp_fut  )
		tickers=json.loads(cfPrivate.get_tickers())
		tickers=tickers['tickers']
		serverTime=json.loads(cfPrivate.get_tickers())['serverTime']

#FIXME: 
		print((f" 8CA {TEST}{datetime.now()} "))

		instruments_list= list( ((xbt_fut)) + xbt_perp +  xrp_perp + xrp_fut  )
		chck_key_list=['1','2','3','4','5','7']

		instruments_list= instruments_list if chck_key in chck_key_list == True else  instruments_list[::-1]

					#mendapatkan atribut isi akun deribit vs crypto facilities			

		account_CF      =self.account_CF()
		
#FIXME: 
		print((f" 8CB {TEST}{datetime.now()} "))

		openOrders_CF				=	 json.loads(cfPrivate.get_openorders())['openOrders']  
		
#FIXME: 
		print((f" 8CC {TEST}{datetime.now()} "))

		openOrders_CF           = [] if openOrders_CF ==[] else openOrders_CF
		print((f" 8D {TEST}{datetime.now()} "))

		try:
			position_CF= json.loads(cfPrivate.get_openpositions(
								))['openPositions']
		except:
			position_CF=0
	

		tickers_xbt_perp			= [ o['markPrice'] for o in[o for o in tickers if (
							o['symbol']==xbt_perp[0] )  ]]

		tickers_xbt_fut			= [ o['markPrice'] for o in[o for o in tickers if (
							o['symbol']==xbt_fut[0] )  ]]       

		tickers_xbt_fut_min			= [ o['markPrice'] for o in[o for o in tickers if (
							o['symbol']==xbt_fut_min[0] )  ]]

		tickers_xrp_perp			= [ o['markPrice'] for o in[o for o in tickers if (
							o['symbol']==xrp_perp[0] )  ]]

		tickers_xrp_fut			= [ o['markPrice'] for o in[o for o in tickers if (
							o['symbol']==xrp_fut[0] )  ]]
		print((f" 8E {TEST}{datetime.now()} "))

		open_xbt_perp			= [sum( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xbt_perp[0] and o[
								'side']== 'buy'  ]])]

		open_xbt_fut			= [sum( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xbt_fut[0] and o[
								'side']== 'sell'  ]])]

		open_xbt_fut_min			= [sum( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xbt_fut_min[0] and o[
								'side']== 'buy'  ]])]
		open_xrp_perp			= [sum( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xrp_perp[0] and o[
								'side']== 'buy'  ]])]
		open_xrp_fut			= [len( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xrp_fut[0] and o[
								'side']== 'sell'  ]])]

		open_xbt_perp_len			= [len( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xbt_perp[0] and o[
								'side']== 'buy'  ]])]

		open_xbt_fut_len			= [len( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xbt_fut[0] and o[
								'side']== 'sell'  ]])]

		open_xbt_fut_min_len			= [len( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xbt_fut_min[0] and o[
								'side']== 'buy'  ]])]
		open_xrp_perp_len			= [len( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xrp_perp[0] and o[
								'side']== 'buy'  ]])]
		open_xrp_fut_len			= [len( [ o['unfilledSize'] for o in[
							o for o in openOrders_CF if o[
								'symbol']==xrp_fut[0] and o[
								'side']== 'sell'  ]])]
		print((f" 8F {TEST}{datetime.now()} "))

		open_instrument= list( open_xbt_perp + open_xbt_fut+ open_xbt_fut_min+open_xrp_perp + open_xrp_fut  )
		open_instrument_len= list( open_xbt_perp_len + open_xbt_fut_len+ open_xbt_fut_min_len+open_xrp_perp_len + open_xrp_fut_len  )
		tickers_instrument= list( tickers_xbt_perp + tickers_xbt_fut+ tickers_xbt_fut_min+tickers_xrp_perp + tickers_xrp_fut  )

		qty_pos=(([o['size'] for o in [o for o in position_CF  ]]))

		side_pos=(([o['side'] for o in [o for o in position_CF  ]])) 
		prc_pos=(([int(o['price']) for o in [o for o in position_CF  ]])) 
		liq=account_CF['triggerEstimates']['lt']
		bal=account_CF['balances']['xbt']

		#instruments_list= (list((  deri)))#deri + xbt_CF + y) ))      

		TEST=TEST+1
		print((f" 9 {TEST}{datetime.now()} "))
		 		
		for fut in instruments_list:
			#membagi deribit vs crypto facilities
			
			deri_test	= 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1
			account         = account_CF #if deri_test == 0 else self.account_drbt(fut)

			#mendapatkan nama akun deribit vs crypto facilities
			sub_name        = 'CF' if deri_test == 0 else account ['username']#deri + xbt_CF + y) ))

			QTY         = 20 if fut=='pi_xbtusd' else 20#	
			nbids		=	2
			nasks		=	2
			FREQ 		= 10
			FREQ		=	FREQ -	max(nasks,nbids)
			QTY         = 20 if fut[3:][:3]=='xrp'else QTY#
			QTY			= int(QTY/8)
				
			n			=10
			IDLE_TIME	=600	
			IDLE_TIME	=int(IDLE_TIME/6)
			place_bids 	= 'true'
			place_asks 	= 'true'			

			get_time	= client_public.public_get_time_get()['result']/1000
			
			counter= get_time - (stop_unix/1000)
			ord_book              = self.get_bbo(fut)  if deri_test==0 else  self.get_bbo_drbt(futures,fut)
#FIXME:			
			print((f" 9A {TEST}{datetime.now()} "))

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
			filledOrder		=  [ o for o in [o for o in json.loads(cfPrivate.get_fills())[
				'fills'] if o[instrument]==fut   ]]  #if deri_test == 0 else  self.filledOrder_drbt( fut ) 

#FIXME:			
			print((f" 9B {TEST}{datetime.now()} "))

			position_CF_fut       = 0 if position_CF == 0 else [ o for o in[o for o in position_CF if o[
                    'symbol'][3:][:3]==fut [3:][:3]  ]]

			positions       = position_CF_fut if deri_test == 0 else  (
				client_account.private_get_positions_get(currency=(fut[:3]
				), kind='future')['result'])
			
			position        = position_CF_fut if deri_test == 0 else (
				client_account.private_get_position_get(fut)['result'])


#FIXME:			
			print((f" 9C {TEST}{datetime.now()} "))

			openOrders_CF_fut           =[] if openOrders_CF ==[] else  (
				 [ o for o in [o for o in openOrders_CF if o[
											instrument]==fut   ]]  ) if deri_test==0 else []											 
			
			openOrders              = openOrders_CF_fut if deri_test==0 else (
                            			client_trading.private_get_open_orders_by_instrument_get (
											instrument_name=fut)['result'])

			perp_test_xbt   =(1 if xbt_perp[0]==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)
			perp_test_xrp   =(1 if xrp_perp[0]==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)
			
			perp_test_CF    =perp_test_xbt if curr== 'xbt' else perp_test_xrp
			
			perp_test   =perp_test_CF if deri_test ==0 else (1 if fut [-10:] == '-PERPETUAL' else 0)

			fut_test_xbt =( 1 if ( xbt_fut[0] == fut   ) else 0 )
			fut_test_xrp =( 1 if ( xrp_fut[0] ==fut  ) else 0 ) 

			fut_test_CF    =fut_test_xbt if curr== 'xbt' else fut_test_xrp

			fut_test    =fut_test_CF# if deri_test==0 else (1 if stamp_new == fut  else 0)

#FIXME:			
			print((f" 9D{TEST}{datetime.now()} "))

			#mendapatkan isi ekuitas deribit vs crypto facilities (ada/tidak collateral)
			equity          = account_CF['balances']['xbt']>0
			
			equity          =   equity if deri_test == 0 else (
									account['equity'] >0 and account [
										'currency']==fut [:3] )


#FIXME:			
			print((f" 9E {TEST}{datetime.now()} "))
		
			#mendapatkan atribut posisi  deribit vs crypto facilities 

			#prc average
			hold_avgPrc_buy		=	self.filter_two_var (positions,avgPrc,side,longs,instrument,fut,sum )

			hold_avgPrc_sell    =  self.filter_two_var (positions,avgPrc,side,short,instrument,fut,sum )	

			#menentukan kuantitas per posisi open per instrumen/total instrumen

			hold_qty_buy		= self.filter_two_var (positions,size,side,longs,instrument,fut,sum ) 
			hold_qty_sell		= self.filter_two_var (positions,size,side,short,instrument,fut,sum ) 
  
			hold_qty_buy_all		= self.filter_one_var (position_CF,size,side,longs,sum ) 
  
			hold_qty_sell_all		= abs(self.filter_one_var (position_CF,size,side,short,sum ))


			openOrders_qty_buy_all=(sum([o[unfilledSize] for o in [o for o in openOrders_CF if o[side] == 'buy' ]])) 
			openOrders_qty_sell_all=(sum([o[unfilledSize] for o in [o for o in openOrders_CF if o[side] == 'sell' ]])) 

			#mendapatkan atribut riwayat transaksi deribit vs crypto facilities 								
			print((f" 10 {TEST}{datetime.now()} "))

			try:
				filledOrders_sell_lastTime	=  (max([o[fillTime] for o in [
												o for o in filledOrder if o[side] == 'sell' ]]))

			except:
				filledOrders_sell_lastTime 	= 0

			try:
				filledOrders_buy_lastTime	=  (max([o[fillTime] for o in [
													o for o in filledOrder if o[side] == 'buy' ]]))

			except:
				filledOrders_buy_lastTime 	= 0

			filledOrders_sell_lastTime_conv	= 0 if filledOrders_sell_lastTime == 0 else (
												time_conversion ((
													filledOrders_sell_lastTime)) if deri_test == 0 else filledOrders_sell_lastTime)

			filledOrders_buy_lastTime_conv	= 0 if filledOrders_buy_lastTime == 0 else (
												time_conversion ((filledOrders_buy_lastTime)) if deri_test == 0 else filledOrders_buy_lastTime)


			filledOrders_sell_openLastTime	= 0 if filledOrders_sell_lastTime ==[] else filledOrders_sell_lastTime

			filledOrders_buy_openLastTime	= 0 if filledOrders_buy_lastTime ==[]else filledOrders_buy_lastTime

			filledOrders_oid_sell	=  0 if filledOrders_sell_lastTime ==0 else (([o['order_id'] for o in [o for o in filledOrder if o[
				fillTime] == filledOrders_sell_lastTime ]]))[0]

			filledOrders_oid_buy	=  0 if filledOrders_buy_lastTime ==0 else (([o['order_id'] for o in [o for o in filledOrder if  o[
				fillTime] == filledOrders_buy_lastTime ]]))[0]

			filledOrders_qty_sell	=sum (([o[size] for o in [o for o in filledOrder if o[side] == 'sell' and  o[
				'order_id'] == filledOrders_oid_sell ]]))
			
			filledOrders_qty_buy	=sum (([o[size] for o in [o for o in filledOrder if o[side] == 'buy' and  o[
				'order_id'] == filledOrders_oid_buy ]]))

			filledOrders_qty_sell 	=  0 if filledOrders_qty_sell ==0 else filledOrders_qty_sell 

			filledOrders_qty_buy    = 0 if filledOrders_qty_buy ==0 else filledOrders_qty_buy   

			#mendapatkan atribut open order deribit vs crypto facilities 	  
			filledOrders_prc_sell	=   ([ o[price] for o in [o for o in filledOrder if o[side]=='sell'  ]])

			filledOrders_prc_buy	=  [o[price] for o in [o for o in filledOrder if o[side] == 'buy'  ]]

			filledOrders_prc_sell 	=  0 if filledOrders_prc_sell ==[] else filledOrders_prc_sell [0]

			filledOrders_prc_buy    = 0 if filledOrders_prc_buy ==[] else filledOrders_prc_buy [0]



			try:				
				open_limit			=  [ o for o in[o for o in openOrders if o[orderType]== limit ]]
			except:
				open_limit  		=0

			try:				
				open_limit_buy= [ o for o in[o for o in open_limit if o[side]== 'buy' ]]

			except:
				open_limit_buy  =0

			try:				
				open_limit_sell= [ o for o in[o for o in open_limit if o[side]== 'sell' ]]

			except:
				open_limit_sell  =0

			#menentukan kuantitas per  open order per instrumen
			openOrders_qty_buy      =   (self.filter_one_var (openOrders,unfilledSize,side,'buy',sum ))
			openOrders_qty_sell	    =	(self.filter_one_var (openOrders,unfilledSize,side,'sell',sum ))

			openOrders_time_buy	    =	self.filter_one_var (openOrders,last_update_timestamp,side,'buy',max )
			openOrders_time_sell	=	self.filter_one_var (openOrders,last_update_timestamp,side,'sell',max )

			try:				
				open_limit_time_sell_max= [ o for o in[o for o in open_limit_sell if o[
					last_update_timestamp]== openOrders_time_sell ]]
			except:
				open_limit_time_sell_max  =0

			openOrders_prc_sell_limit_max= 0 if openOrders_time_sell==  [] else [ o[limitPrice] for o in [
					o for o in open_limit_time_sell_max  ]] [0]

			try:				
				open_limit_time_buy_max= [ o for o in[o for o in open_limit_buy if o[
					last_update_timestamp]== openOrders_time_buy ]]
			except:
				open_limit_time_buy_max  =0

			openOrders_prc_buy_limit_max= 0 if openOrders_time_buy==  [] else [ o[limitPrice] for o in [
					o for o in open_limit_time_buy_max  ]] [0]


			openOrders_time_buy_min	    =	self.filter_one_var (openOrders,last_update_timestamp,side,'buy',min )
			openOrders_time_sell_min	=	self.filter_one_var (openOrders,last_update_timestamp,side,'sell',min )

			openOrders_time_buy_conv= 0 if openOrders_time_buy== [] else ( 
				time_conversion( openOrders_time_buy) if deri_test == 0 else openOrders_time_buy)

			openOrders_time_sell_conv=  0 if openOrders_time_sell== [] else (
				time_conversion( openOrders_time_sell) if deri_test == 0 else openOrders_time_sell)

			openOrders_time_buy_conv_min= 0 if openOrders_time_buy== [] else ( 
				time_conversion( openOrders_time_buy_min) if deri_test == 0 else openOrders_time_buy_min)

			openOrders_time_sell_conv_min=  0 if openOrders_time_sell== [] else (
				time_conversion( openOrders_time_sell_min) if deri_test == 0 else openOrders_time_sell_min)


			try:				
				open_limit_time_buy= [ o for o in[o for o in open_limit_buy if o[
					last_update_timestamp]== openOrders_time_buy_min ]]
			except:
				open_limit_time_buy  =0

			try:				
				open_limit_time_sell= [ o for o in[o for o in open_limit_sell if o[
					last_update_timestamp]== openOrders_time_sell_min ]]
			except:
				open_limit_time_sell  =0



			try:				
				open_limit_time_buy_min= [ o for o in[o for o in open_limit_buy if o[
					last_update_timestamp]== openOrders_time_buy ]]
			except:
				open_limit_time_buy_min  =0

			try:				
				open_limit_time_sell_min= [ o for o in[o for o in open_limit_sell if o[
					last_update_timestamp]== openOrders_time_sell ]]
			except:
				open_limit_time_sell_min  =0

			openOrders_prc_buy_limit= 0 if openOrders_time_buy== [] else ([ o[limitPrice] for o in [
					o for o in open_limit_time_buy  ]])[0]

			openOrders_oid_buy_limit= 0 if openOrders_time_buy== []  else ([ o[order_id] for o in [
					o for o in open_limit_time_buy  ]])[0]

			openOrders_oid_sell_limit=  0 if openOrders_time_sell== []  else ([ o[order_id] for o in [
					o for o in open_limit_time_sell  ]])[0]	

			openOrders_oid_buy_limit_min= 0 if openOrders_time_buy_min== []  else ([ o[order_id] for o in [
					o for o in open_limit_time_buy_min  ]])[0]

			openOrders_oid_sell_limit_min=  0 if openOrders_time_sell_min== []  else ([ o[order_id] for o in [
					o for o in open_limit_time_sell_min  ]])[0]	

			openOrders_prc_sell_limit= 0 if openOrders_time_sell==  [] else [ o[limitPrice] for o in [
					o for o in open_limit_time_sell  ]] [0]

			#menghitung kuantitas limit order per instrumen
#openOrders_time_sell 
			#qty individual
			openOrders_qty_sell_limit  = 0 if open_limit_time_sell== [] else [ o[unfilledSize] for o in [
					o for o in open_limit_time_sell  ]] [0]

			openOrders_qty_buy_limit  =  0 if openOrders_time_buy== [] else [ o[unfilledSize] for o in [
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

			openOrders_oid_sell_limitBal=  0 if openOrders_oid_sell_limitBal== 0 else (([o[order_id] for o in [o for o in open_limit_sell if  (
				o[unfilledSize])  ==openOrders_oid_sell_limitBal ]]  )[0])
				
			openOrders_buy_oid_limitBal=  0 if open_limit_buy== []  else max([o[unfilledSize] for o in [o for o in open_limit_buy   ]]  )

			openOrders_oid_buy_limitBal=  0 if openOrders_buy_oid_limitBal== 0 else (([o[order_id] for o in [o for o in open_limit_buy if  (
				o[unfilledSize])  ==openOrders_buy_oid_limitBal ]]  )[0])

			#menghitung waktu stop order per instrumen ada di platform
				#maks stop order 20


			openOrders_qty_sell_filled=   0 if open_limit_sell== [] else ([o[
			'filledSize'] for o in [o for o in open_limit_sell  ]]  )[0]

			openOrders_qty_buy_filled=  0 if open_limit_buy== [] else ([o[
			'filledSize'] for o in [o for o in open_limit_buy]]  ) [0]

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

			IDLE_TIME=480
			 
			delta_time_buy= max (filled_time_buy,open_time_buy)  if (
				filled_time_buy == 0 or open_time_buy ==0) else min (
					filled_time_buy,open_time_buy)

			delta_time_sell= max (filled_time_sell,open_time_sell) if (
				filled_time_sell ==0 or open_time_sell==0) else min (
					filled_time_sell,open_time_sell)

#FIXME:

			qty_imbalance_sell 		=	abs(hold_qty_sell_all) -  openOrders_qty_buy_all  #4 menjamin order sell maks = order buy
			qty_imbalance_buy 	=	abs(hold_qty_buy_all) -  openOrders_qty_sell_all  #4 menjamin order sell maks = order buy
			
			test_qty_zero_fut =  ((hold_qty_buy ==0 and openOrders_qty_buy_limit == 0))
			
			test_time_fut	=delta_time_buy > IDLE_TIME
			
			test_qty_zero_perp	=hold_qty_sell ==0 and abs(openOrders_qty_sell_limit) ==0

			test_time_perp=delta_time_sell > IDLE_TIME

			fut_order=  ( test_time_perp == True )  or (test_qty_zero_perp ==True)

			perp_order=  test_time_fut == True   or (test_qty_zero_fut ==True )

			print((f" 11 {TEST}{datetime.now()} "))
				
			if (qty_imbalance_sell ==0 and qty_imbalance_buy== 0) and (fut_order==False and perp_order==False)  :
				while True:
					print(fut,'sys.exit()',sys.exit())
					sys.exit()
				break
			 
			print((f" 12 {TEST}{datetime.now()} "))

			bid_oke=False
			ask_oke=False

			if test_time_fut ==True or test_time_perp == True:

				end_point_btc='https://www.deribit.com/api/v2/public/get_tradingview_chart_data'
				endpoint_xrp='https://api.kraken.com/0/public/OHLC?pair=xxrpxxbt&interval=5' 
				
				df				=	self.DF(end_point_btc) if curr =='xbt' else self.DF_XRP(endpoint_xrp)

				print((f" 12AA {TEST}{datetime.now()} "))
		
				df['HMA']		= 	self.WMA(2 * self.WMA(df['close'], int(n/2)) - self.WMA(df['close'], n), int(np.sqrt(n)))
				print((f" 12AB {TEST}{datetime.now()} "))

				df['up']		=	df['HMA'] .diff()

				print((f" 12AC {TEST}{datetime.now()} "))

				hma_net			=int(df['up'].tail(1).values.tolist() [0]) 
				print((f" 12A {TEST}{datetime.now()} "))
				
				bid_oke			=True if hma_net > (1 if curr =='xbt' else  0) else False
				ask_oke			=True if hma_net < (-1 if curr =='xbt' else  0) else False
				print((f" 12B {TEST}{datetime.now()} "))

				hma_prc_buy		=	( abs(hma_net)  if curr =='xbt' else abs(hma_net)/XRP_ROUND )   if bid_oke==True else 0
				hma_prc_sell	= 	( abs(hma_net)   if curr =='xbt' else abs(hma_net)/XRP_ROUND )  if ask_oke==True else 0


			qty_imbal_perp 		=	abs(hold_qty_sell) -  openOrders_qty_buy_limit_sum  #4 menjamin order sell maks = order buy
			qty_imbal_fut 	=	abs(hold_qty_buy) -  openOrders_qty_sell_limit_sum  #4 menjamin order sell maks = order buy
			bid_prc=0
			ask_prc=0

				
			if bid_oke ==True  or qty_imbal_perp !=0:
				bid_prc         = ord_book['ask'] - TICK
				
			if ask_oke ==True or qty_imbal_fut !=0  :
				ask_prc         = ord_book['ask'] - TICK
			
			print((f" bid_oke {bid_oke} ask_oke {ask_oke} "))

			print((f" bid_prc {bid_prc} ask_prc {ask_prc} "))

			print((f" 13 {TEST}{datetime.now()} "))

			#order tidak dieksekusi >280 detik
			#seluruh stop limit yg belum ditrigger
			#limit, sesuai dengan lawan masing2 default

			if ((abs(openOrders_qty_sell_limit_sum) ) > hold_qty_buy) and fut_test==1 and hold_qty_buy != 0:
				
				if openOrders_oid_sell_limit  !=0: #openOrders_oid_sell_limit  !=0 = mengecek open order sudah tereksekusi/belum	
	
					print(BLUE + str((fut,'222',cfPrivate.cancel_order(openOrders_oid_sell_limit) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_limit)))),ENDC)

			if ((abs(openOrders_qty_buy_limit_sum) ) > abs(hold_qty_sell)) and perp_test==1 and hold_qty_sell != 0:

				if openOrders_oid_buy_limit  !=0:#openOrders_oid_sell_limit  !=0 = mengecek open order sudah tereksekusi/belum							
	
					print(BLUE + str((fut,'333',cfPrivate.cancel_order(openOrders_oid_buy_limit) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_limit)))),ENDC)

			if  (fut_test==1 and open_time_buy >IDLE_TIME/4) or (perp_test==1 and open_time_sell >IDLE_TIME/4) :# hanya berlaku bagi beli/jual, bukan lawan transaksi

				if perp_test==1 and openOrders_oid_sell_limit != 0  : 													
	
					print(BLUE + str((fut,'444',cfPrivate.cancel_order(openOrders_oid_sell_limit) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_limit)))),ENDC)

				if fut_test==1  and openOrders_oid_buy_limit !=0:                                                   

					print(BLUE + str((fut,'444B',cfPrivate.cancel_order(openOrders_oid_buy_limit) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_limit)))),ENDC)


			cancel_fut_test		=  abs(openOrders_qty_sell_limitLen) >= FREQ and openOrders_time_sell_conv_min > (IDLE_TIME * FREQ)
			
			cancel_perp_test	=  openOrders_qty_buy_limitLen >= FREQ and openOrders_time_buy_conv_min > (IDLE_TIME *FREQ)

			if  cancel_fut_test == True or cancel_perp_test == True   :	

				if perp_test==1 : 	
					
					if  openOrders_oid_buy_limit_min != 0:
						
						print(BLUE + str((fut,'555',cfPrivate.cancel_order(openOrders_oid_buy_limit_min) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_limit_min)))),ENDC)

					if  openOrders_oid_buy_limitBal != 0:
						
						print(BLUE + str((fut,'555B',cfPrivate.cancel_order(openOrders_oid_buy_limitBal) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_limitBal)))),ENDC)

				if fut_test==1 : 													

					if  openOrders_oid_sell_limit_min != 0 :
						
						print(BLUE + str((fut,'555C',cfPrivate.cancel_order(openOrders_oid_sell_limit_min) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_limit_min)))),ENDC)

															
					if  openOrders_oid_sell_limitBal != 0 :
  						
						print(BLUE + str((fut,'555D',cfPrivate.cancel_order(openOrders_oid_sell_limitBal) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_limitBal)))),ENDC)

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

			place_bids  =  equity==True  
			place_asks  =   equity==True 


#TODO:'place_bids'
			if place_bids:

				default_order_limit= (dict(default_order_limit,**{"side": "buy"}))
				default_order_stop= (dict(default_order_limit,**{"side": "buy"}))

				stop_prc_perp=   max( ask_prc ,( float(openOrders_prc_sell_limit+TICK ) ) )

				if   perp_test==1 :
					
					test_time		=	(filledOrders_sell_lastTime_conv < openOrders_time_buy_conv or openOrders_time_buy_conv ==0) and (
						filledOrders_sell_lastTime_conv < IDLE_TIME*5
					)
										
					test_qty_sum_perp 	=	abs(hold_qty_sell) >  openOrders_qty_buy_limit_sum and abs(
										hold_qty_sell) > 0 #4 menjamin order sell maks = order buy					
					
					prc_imbal 		=	 min(bid_prc, int(hold_avgPrc_sell-(hold_avgPrc_sell * MARGIN * 2)) if curr=='xbt' else float(
										(round(hold_avgPrc_sell-(hold_avgPrc_sell * MARGIN * 2),8))) ) 
										
					test_qty_freq 	=  openOrders_qty_buy_limitLen < FREQ#3 boleh sampai 5 misalnnya

					test_pct_sum 	=  False if abs(hold_qty_sell)==0 else (openOrders_qty_buy_limit_sum /abs(hold_qty_sell)) < 40/100#ini buat apa ya ? kayaknya nggak perlu deh

					prc_limit		=	bid_prc if filledOrders_prc_sell ==0 else min(bid_prc ,(int(filledOrders_prc_sell  - (hma_prc_sell)) if curr== 'xbt' else float( (round(
										filledOrders_prc_sell  - (hma_prc_sell),8)))))-TICK
					
#NORMAL,  limit seketika setelah eksekusi order

					if (test_qty_sum_perp == True  and test_time == True  ):													

						print(GREEN + str((fut,'#NORMAL, bila limit diekseskusi','test_qty_sum_perp',test_qty_sum_perp,
						'test_time',test_time,'filledOrders_sell_lastTime_conv', filledOrders_sell_lastTime_conv,
						'openOrders_time_buy_conv',  openOrders_time_buy_conv,'IDLE_TIME',IDLE_TIME)),ENDC)
						if deri_test == 1 and qty_imbal_perp !=0:

							client_trading.private_buy_get(
							instrument_name =fut,
								reduce_only	='false',
								type		=limit,
								price		=prc_limit,
								post_only		='true',
								amount			=qty_imbal_perp
							)	

						if deri_test == 0 and qty_imbal_perp !=0:
									
							print(GREEN + str((fut,cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty_imbal_perp,"limitPrice":prc_limit}))
						)),ENDC)

#pengimbang saldo sell, sisa apa pun, dimasukkan ke average 						
					elif  test_qty_sum_perp  ==True :											

						qty=abs(filledOrders_qty_sell)

						print(GREEN + str((fut,'#pengimbang AVG DOWN','hold_qty_sell',abs(hold_qty_sell),
						'(abs(hold_qty_sell)-abs(openOrders_qty_buy_limit)) >= 0',
						(abs(hold_qty_sell)-abs(openOrders_qty_buy_limit)) > 0,
						abs(openOrders_qty_buy_limit),'test_qty_sum_perp ',test_qty_sum_perp,'cancel_perp_test',cancel_perp_test )),ENDC)

						if deri_test == 1 :

							client_trading.private_buy_get(
							instrument_name =fut,
							reduce_only     ='false',
							type            =limit,
							price           =prc_imbal,#seharusnya prc_net ,
							post_only       ='true',
							amount          =qty_imbal,
							)	

						if deri_test == 0 :

							print(GREEN + str((fut,cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty_imbal_perp,"limitPrice":prc_imbal}))
						)),ENDC)


#NORMAL,, pasang posisi beli pada QTY =0/avg down  					                                                    							
				elif  fut_test==1 and (openOrders_qty_buy == 0 or  openOrders_qty_buy_filled !=0) and bid_oke==True:
					
					for i in range(max(0,nbids)):
						if i <nbids:

							#test_qty_zero =  ((hold_qty_buy ==0 and openOrders_qty_buy_limit == 0))					
							print(GREEN + str((fut,'#NORMAL AAA, pasang posisi beli pada QTY =0/avg down','test_time_fut', delta_time_buy > IDLE_TIME,
								'test_qty_zero_fut',((hold_qty_buy ==0 and openOrders_qty_buy_limit == 0)),
								'delta_time_buy',delta_time_buy,'IDLE_TIME',IDLE_TIME,'prc',bid_prc ,
								'QTY',QTY,'openOrders_qty_buy',openOrders_qty_buy,'openOrders_qty_buy_filled',openOrders_qty_buy_filled,
								'bid_prc -(TICK * i)',bid_prc -(TICK * i)
								)),ENDC)			
											
							if  test_time_fut == True   or (test_qty_zero_fut ==True ) and i < nbids :
									
								prc= bid_prc if i == 0 else bid_prc -(TICK * i)
								qty= 1

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
									print(GREEN + str((fut,cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty,"limitPrice":prc}))
								)),ENDC)

						else:
    
							pass

#TODO:'place_asks'

			# OFFERS

			if place_asks:

				default_order_limit= (dict(default_order_limit,**{"side": "sell"}))

				if   fut_test==1 : 

					test_time		= 	(filledOrders_buy_lastTime_conv < openOrders_time_sell_conv or openOrders_time_sell_conv ==0) and (
						filledOrders_buy_lastTime_conv <  IDLE_TIME *5
					)
											
					

					prc_imbal 	=	 max(ask_prc, int(hold_avgPrc_buy+(hold_avgPrc_buy*MARGIN * 2)) if curr=='xbt' else float(round(
										hold_avgPrc_buy+(hold_avgPrc_buy*MARGIN * 2),8)) )
					test_qty_sum_fut 	= 	hold_qty_buy > abs(openOrders_qty_sell_limit_sum)   and abs(abs(hold_qty_buy) ) > 0 

					test_qty_freq 	=  abs(openOrders_qty_sell_limitLen ) < FREQ
					test_pct_sum 	=  False if abs(hold_qty_buy)==0 else (
										openOrders_qty_sell_limit_sum /abs(hold_qty_buy)) < 40/100					

					prc_limit		=	ask_prc if filledOrders_prc_buy ==0 else max(ask_prc ,int(filledOrders_prc_buy+(hma_prc_buy)) if curr== 'xbt' else float( (round(
									filledOrders_prc_buy+(hma_prc_buy),8)))) + TICK

#NORMAL,  limit seketika setelah eksekusi order

					if (test_time == True and test_qty_sum_fut == True ):													
						

						print(RED + str((fut,'#NORMAL, bila limit diekseskusi','test_time',test_time,
						'filledOrders_buy_lastTime_conv', filledOrders_buy_lastTime_conv,'openOrders_time_sell_conv',  openOrders_time_sell_conv,
						'test_qty_sum',test_qty_sum_fut,'prc_limit',prc_limit,'filledOrders_qty_buy',filledOrders_qty_buy
						)),ENDC)	
													
						if deri_test == 1 and qty_imbal_fut !=0:

							client_trading.private_sell_get(
							instrument_name=fut,
							reduce_only='false',
							type=limit,
							price=prc_limit,
							post_only='true',
							amount=qty)	

						if deri_test == 0 and qty_imbal_fut !=0:

							print(RED + str((fut,cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty_imbal_fut,"limitPrice":prc_limit}))
						)),ENDC)

#pengimbang saldo sell, sisa apa pun, dimasukkan ke average 						
					if   test_qty_sum_fut  == True :
				
						if deri_test == 1 :																		
							client_trading.private_sell_get(
							instrument_name=fut,
							reduce_only='false',
							type=limit,
							price=prc_imbal,
							post_only='true',
							amount=qty_imbal_fut
							)	

						if deri_test == 0 :

							print(RED + str((fut,cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty_imbal_fut,"limitPrice":prc_imbal}))
						)),ENDC)

#NORMAL,, pasang posisi beli pada QTY =0/avg up  					                                                    							
				elif   perp_test==1 and (openOrders_qty_sell == 0 or  openOrders_qty_sell_filled !=0 ) and ask_oke==True:

					test_qty_zero_perp =  hold_qty_sell ==0 and abs(openOrders_qty_sell_limit) ==0
					test_time = delta_time_sell > IDLE_TIME
					
					for i in range(max(0,nasks)):
						if i <nasks:


							print(RED + str((fut,'#NORMAL,pasang posisi beli pada QTY =0/avg up','test_time', delta_time_sell > IDLE_TIME,
							'test_qty_zero',test_qty_zero_perp,'delta_time_sell',delta_time_sell,'IDLE_TIME',IDLE_TIME,
							'ask_prc + (TICK*i)',ask_prc + (TICK*i))),ENDC)			
											
							if  ( test_time_perp == True )  or (test_qty_zero_perp ==True):

								prc= ask_prc if i == 0 else ask_prc + (TICK*i)
								qty= 1 
								
								if deri_test == 1 :
									client_trading.private_sell_get(
									instrument_name=fut,
									reduce_only='false',
									type=limit,
									price=max(prc,ask_prc) ,
									post_only='true',
									amount=qty
									)	

								if deri_test == 0:

									print(RED + str((fut,cfPrivate.send_order_1(dict(default_order_limit,**{"size": qty,"limitPrice":prc}))
								)),ENDC)
						else:
    
							pass


			print('\n')

			self.summary_account(instruments_list_ori,side_pos,prc_pos,tickers_instrument,qty_pos,open_instrument,open_instrument_len)
			qty_imbalance_sell 		=	abs(hold_qty_sell_all) -  openOrders_qty_buy_all  #4 menjamin order sell maks = order buy
			qty_imbalance_buy 	=	abs(hold_qty_buy_all) -  openOrders_qty_sell_all  #4 menjamin order sell maks = order buy
			
			print('\n')
			print(BOLD + str((fut)),ENDC)
			print(BOLD + str(('qty_imbalance_sell                          ',qty_imbalance_sell)),ENDC)
			print(BOLD + str(('qty_imbalance_buy                           ',qty_imbalance_buy)),ENDC)
			print('\n')
			print(BOLD + str(('counter',counter,'hma',hma_net,)),ENDC)
			print('\n')

		#	print('bal=',bal,bal*tickers_xbt_fut[0])
  
    #https://stackoverflow.com/questions/39032720/formatting-lists-into-columns-of-a-table-output-python-3

			qty= max (hold_qty_buy,abs(hold_qty_sell))
#			my_message= (f" {datetime.now()}  {fut}  {counter}")

			

#			if counter >10:
#				telegram_bot_sendtext(my_message)
			print((f" 14 {TEST}{datetime.now()} "))

			if counter > (COUNTER if equity !=0 else 0):
				while True:
					sys.exit()
				break
								
			print(BOLD + str((fut,'counter',counter,'hma',hma_net)),ENDC)
#			if counter > (COUNTER-4 if equity !=0 else 0) and (
#				(bid_oke==False and fut_test==1) or (ask_oke==False and perp_test==1)):

#				print(BOLD + str((fut,'counter A',counter,'hma',hma_net)),ENDC)
#				while True:
#					print(BOLD + str((fut,'counter',counter,'bid_oke==False and fut_test==1 A',bid_oke==False and 
#			fut_test==1,'ask_oke==False and perp_test==1',ask_oke==False and perp_test==1)),ENDC)
#					sys.exit()
#				break
	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

	def run(self):

		self.run_first()

		while True:

			self.place_orders()

	print(BOLD + str(('run')),ENDC)

	def run_first(self):

		self.create_client()
	#	self.create_client_account()
	#	self.create_client_trading()
	#	self.create_client_public()
	#	self.create_client_private()
	#	self.create_client_market()
		self.logger = get_logger('root', LOG_LEVEL)

if __name__ == '__main__':

	try:
		mmbot = MarketMaker(monitor=args.monitor, output=args.output)
		mmbot.run()
	except(KeyboardInterrupt, SystemExit):
		print(traceback.format_exc())
		sys.exit()
	except:
		print(traceback.format_exc())
		if args.restart:
			mmbot.run()
#PR
#konsistecdcfnsi tanda minus
#TODO:


#optimal TF
#penempatan ob df
#FIXME:
