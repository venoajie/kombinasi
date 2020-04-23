
import os
import sys
import logging
import time
from time import sleep
from datetime import datetime, timedelta
from os.path import getmtime
import argparse,  traceback
import requests
#from api import RestClient
import openapi_client
#from openapi_client.rest import ApiException
import cfRestApiV3 as cfApi
import ssl
import  json
from functools import lru_cache

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

NOW_TIME 	= datetime.now()
START_TIME 	= datetime.now() - timedelta (days = 1, hours =24 )
start_unix 	= time.mktime(START_TIME.timetuple())*1000
stop_unix 	= time.mktime(NOW_TIME.timetuple())*1000

#FIXME:
TRAINING                    =  False#True# 
endpoint_training           =   "https://conformance.cryptofacilities.com/derivatives"
endpoint_production         =   "https://www.cryptofacilities.com/derivatives"
apiPublicKey_training       =   "PlRnNMw9jpQw1Cnxel99eVqjAp00fCypDdc4zC4godZJa91Y4UXfMHMz"
apiPublicKey_production     =   "lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
apiPrivateKey_training      =   "3k8j0gangNZ/+B0Zxi8WNfpd+6ETXfJf+f/sD3H+K6dolQ5dlw4EtK6VzZxU7LqjktZVgHSdosdT7qxZKcU5sK/Q"
apiPrivateKey_production    =   "ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"

apiPath 					= 	endpoint_production if TRAINING==False else endpoint_training 
apiPrivateKey 				=	apiPrivateKey_production if TRAINING==False else apiPrivateKey_training
apiPublicKey 				= apiPublicKey_production if TRAINING==False else apiPublicKey_training
checkCertificate 			= True if TRAINING==False else False 
timeout 					= 5
useNonce 					= False  # nonce is optional

cfPublic 					= cfApi.cfApiMethods(apiPath, 
								timeout=timeout, 
								checkCertificate=checkCertificate)

cfPrivate 					= cfApi.cfApiMethods(apiPath, 
								timeout=timeout, 
								apiPublicKey=apiPublicKey, 
								apiPrivateKey=apiPrivateKey, 
								checkCertificate=checkCertificate, 
								useNonce=useNonce)

key = "_zEH40KQ"
secret = "UJoBPSraxZvVzM42MMjiygTYUzKoSu3skyG2EE7wN90"

deribitauthurl = "https://deribit.com/api/v2/public/auth"

#PARAMS = {'client_id': key, 'client_secret': secret, 'grant_type': 'client_credentials'}

#data = s.get(url=deribitauthurl, params=PARAMS).json()

#accesstoken = data['result']['access_token']

configuration = openapi_client.Configuration()
#configuration.access_token = accesstoken
api=openapi_client

#client_account = api.AccountManagementApi(api.ApiClient(configuration))
#client_trading = api.TradingApi(api.ApiClient(configuration))
client_public = api.PublicApi(api.ApiClient(configuration))
#client_private = api.PrivateApi(api.ApiClient(configuration))
#client_market = api.MarketDataApi(api.ApiClient(configuration))
        
sender_email =  'ringkasan.akun@gmail.com'
receiver_email = 'venoajie@gmail.com'
password = 'ceger844579*'

# Add command line switches
parser = argparse.ArgumentParser(description='Bot')

# Use production platform/account
parser.add_argument('-p',
					dest='use_prod',
					action='store_true')

# Do not restart bot on errors
parser.add_argument('--no-restart',
					dest='restart',
					action='store_false')

args = parser.parse_args()

one_pct       = 1/100
DELTA_PRC	=  one_pct /20
IDLE_TIME   = 600 #nggak jalan?
LOG_LEVEL   = logging.INFO
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
time_now    =	time.mktime(NOW_TIME.timetuple())
s 			= requests.Session()

def time_conversion( waktu ):
	'''Mengonversi waktu format ISO ke UTC'''
	
	conv_formula	=  	time.mktime (
						datetime.strptime(
							waktu,
							'%Y-%m-%dT%H:%M:%S.%fZ').
							timetuple() )

	konversi 		= 	time_now - conv_formula

	return konversi

def time_conversion_ori( waktu ):
	'''Mengonversi waktu format ISO ke UTC'''

	konversi		=  	time.mktime (
						datetime.strptime(
							waktu,
							'%Y-%m-%dT%H:%M:%S.%fZ').timetuple() )

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

class MarketMaker(object):

	def __init__(self, monitor=True, output=True):

		self.client = None
#		self.client_trading = None
#		self.client_public = None
#		self.client_private = None
#		self.client_market = None
#		self.client_market = None
		self.logger = None
		self.monitor = monitor
		self.output = output or monitor

	def create_client(self):

		self.client = (key, secret, deribitauthurl)

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
	
#	@lru_cache(maxsize=None)
#	def book_summary_drbt( self, currency):
    		
#		book_summ = client_market.public_get_book_summary_by_currency_get(
#					currency, kind='future')['result']

#		futures = sort_by_key({i['instrument_name']: i for i in (book_summ)})			
		
#		return book_summ

	@lru_cache(maxsize=None)
	def get_bbo_drbt( self, book_summ, contract ):

		'''Mendapatkan orderbook deribit'''
   		
		ob_drbt 	=	(  [ o for o in [o for o in book_summ if o[
						'instrument_name']==contract   ]]  )[0]
		bid_prc		=  ob_drbt ['bid_price']
		ask_prc		=  ob_drbt ['ask_price']
		  		
		return { 'bid': bid_prc, 'ask': ask_prc }

	@lru_cache(maxsize=None)
	def filledOrder_cf(self,contract ):

		'''Mendapatkan order yang tereksekusi CF'''

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
	def position_CF(self ):
    						
		return  json.loads(cfPrivate.get_openpositions())['openPositions']

#	@lru_cache(maxsize=None)
	def openOrders_CF(self ):
    						
		return  json.loads(cfPrivate.get_openorders())['openOrders'] 

	@lru_cache(maxsize=None)
	def get_instruments_CF(self ):
    						
		return  json.loads(cfPublic.getinstruments())['instruments']

	@lru_cache(maxsize=None)
	def get_tickers_CF(self ):
    						
		return  json.loads(cfPrivate.get_tickers())

	@lru_cache(maxsize=None)
	def get_bbo_CF( self,  contract ):
    		
		tickers 	=	self.get_tickers_CF()['tickers']
		tickers		=	list(tuple(tickers))#https://stackoverflow.com/questions/39189272/python-list-comprehension-and-json-parsing

		bid_prc		=  [ o['bid'] for o in[o for o in tickers  if o['symbol']==contract]] [0]
		ask_prc		=   [ o['ask'] for o in[o for o in tickers  if o['symbol']==contract]] [0]
		  		
		return { 'bid': bid_prc, 'ask': ask_prc}

	@lru_cache(maxsize=None)
	def get_tag_CF( self ):
    		
		tickers 	=	self.get_tickers_CF()['tickers']
		tickers		=	list(tuple(tickers))#https://stackoverflow.com/questions/39189272/python-list-comprehension-and-json-parsing

		perp		= [ o['symbol'] for o in[o for o in tickers  if o['symbol']=='pi_xbtusd']] 
		qtr		=  [ o['symbol'] for o in[o for o in tickers  if o['symbol']=='pi_xbtusd']] 
		mth		=  [ o['symbol'] for o in[o for o in tickers  if o['symbol']=='pi_xbtusd']] 
		  		
		return { 'perp': perp, 'qtr': qtr,'mth': mth}

#	def filledOrder_drbt(self,contract ):

#		return client_trading.private_get_order_history_by_instrument_get (
#											instrument_name=contract, count=10)['result']

	def filter_one_var(self,data,result,filter,member ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data if o[filter] == member ]])
		
		except:
			filter 	= []

		return filter


	def filter_two_var(self,data,result,filter1,member1,filter2,member2 ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data if o[
						filter1] == member1 and  o[filter2] == member2 ]])
		
		except:
			filter 	= []

		return filter

	def filter_no_var(self,data,result ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data  ]])
		except:
			filter 	= []

		return filter

	def truncate(self,f, n):
		'''Truncates/pads a float f to n decimal places without rounding'''
		s = '%.12f' % f
		i, p, d = s.partition('.')
		return '.'.join([i, (d+'0'*n)[:n]])

	def get_non_perpetual (self,get_instruments_CF,currency):
		'''get non-perpetual instruments'''
		fut = [( [ o['symbol'] for o in[
				o for o in get_instruments_CF if o[
				'symbol'][3:][:3]== currency and len(o[
					'symbol'])<=16 and o['symbol'][:1] == 'f'  ]])]
		return fut

	def place_orders(self):					
	
#		get_instruments_drbt			=	self.book_summary_drbt('BTC')

#		self.get_instruments_drbt 	= 	sort_by_key({i['instrument_name']: i for i in (get_instruments_drbt)})	

#		deri			= list((self.futures).keys())
	 					
	#	stamp			=  [o['instrument_name']  for o in [o for o in get_instruments_drbt if  len(o['instrument_name'])==11 
     #                                               ]]
	#	stamp_new		=  (  min( (stamp)[0],(stamp)[1]))

		get_instruments_CF	= self. get_instruments_CF()
		xbt_non_perp 		= self.get_non_perpetual (get_instruments_CF,'xbt')[0]
		xrp_non_perp 		= self.get_non_perpetual (get_instruments_CF,'xrp') [0]
		eth_non_perp		= self.get_non_perpetual (get_instruments_CF,'eth') [0]

		xbt_perp			= ['pi_xbtusd']
		eth_perp			= ['pi_ethusd']
		xrp_perp			= ['pv_xrpxbt']

		xbt_fut				= max(sorted (xbt_non_perp))

		xbt_fut_min			= min(sorted(xbt_non_perp))

		eth_fut				= max(sorted (eth_non_perp) )

		eth_fut_min 		= min(sorted (eth_non_perp) )

		xrp_fut				= max (sorted (xrp_non_perp) )

		instruments_list_xbt= list( xbt_perp + [xbt_fut])
		instruments_list_eth= list( eth_perp + [eth_fut])
		instruments_list_xrp= list( xrp_perp + [xrp_fut])
		instruments_list_alts= list( instruments_list_eth + instruments_list_xrp  )

		tickers=self.get_tickers_CF()

		serverTime=tickers['serverTime']
		tickers=tickers['tickers']

		instruments_list= list(instruments_list_xbt + instruments_list_alts)

#!mendapatkan atribut isi akun deribit vs crypto facilities			

		account_CF      =self.account_CF()
		
		openOrders_CF				=	 self.openOrders_CF()
        
		openOrders_CF           = [] if openOrders_CF ==[] else openOrders_CF
		 		
		for fut in instruments_list:
			#membagi deribit vs crypto facilities			
			deri_test	= 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1
			account         = account_CF #if deri_test == 0 else self.account_drbt(fut)
			#mendapatkan nama akun deribit vs crypto facilities
			sub_name        = 'CF' if deri_test == 0 else account ['username']#deri + xbt_CF + y) ))
			nbids		=	1
			nasks		=	1
			FREQ 		= 	2 if TRAINING  ==   True  else 10
			FREQ		=	FREQ -	max(nasks,nbids)				
			n			=	10		
			QTY         = 3
			IDLE_TIME 	= 480
			get_time	= client_public.public_get_time_get()['result']/1000			
			counter		= get_time - (stop_unix/1000)

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

			QTY         = QTY if curr== 'xbt' else ( int(QTY/3) if curr== 'eth' else QTY *3 )#* 3

			filledOrder		=  [ o for o in [o for o in json.loads(cfPrivate.get_fills())[
				'fills'] if o[instrument]==fut   ]]  #if deri_test == 0 else  self.filledOrder_drbt( fut ) 

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

			perp_test_eth   =(1 if eth_perp[0]==fut else 0) if deri_test ==0 else (
				1 if fut [-10:] == '-PERPETUAL' else 0)


			perp_test_CF    = perp_test_xbt if curr== 'xbt' else ( perp_test_xrp if curr== 'xrp' else perp_test_eth)
			
			perp_test   =perp_test_CF if deri_test ==0 else (1 if fut [-10:] == '-PERPETUAL' else 0)

			fut_test_xbt =( 1 if ( xbt_fut[0] == fut   ) else 0 )

			fut_test_xrp =  0 if TRAINING==True else ( 1 if ( xrp_fut[0] ==fut  ) else 0 ) 
			fut_test_eth =  0 if TRAINING==True else ( 1 if ( eth_fut[0] ==fut  ) else 0 ) 

			fut_test_CF    =fut_test_xbt if curr== 'xbt' else ( fut_test_xrp if curr== 'xrp' else fut_test_eth) 

			fut_test    =fut_test_CF# if deri_test==0 else (1 if stamp_new == fut  else 0)

			#mendapatkan atribut riwayat transaksi deribit vs crypto facilities 								

			filledOrders_sell_lastTime	=   self.filter_one_var (filledOrder,
																		fillTime,
																		side,
																		'sell'
																		)

			filledOrders_sell_lastTime = 0 if filledOrders_sell_lastTime == [] else max (filledOrders_sell_lastTime)

			filledOrders_buy_lastTime	=   self.filter_one_var (filledOrder,
																		fillTime,
																		side,
																		'buy'
																		)

			filledOrders_buy_lastTime = 0 if filledOrders_buy_lastTime == [] else max (filledOrders_buy_lastTime)

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

			filledOrders_qty_sell 	=   sum(self.filter_two_var (filledOrder,
																size,
																side,
																'sell',
																order_id,
																filledOrders_oid_sell
																))

			filledOrders_qty_buy 	=   sum(self.filter_two_var (filledOrder,
																size,
																side,
																'buy',
																order_id,
																filledOrders_oid_buy
																))

			#mendapatkan atribut open order deribit vs crypto facilities 	  

			filledOrders_prc_sell	=   self.filter_one_var (filledOrder,
															price,
															side,
															'sell'
															)
			filledOrders_prc_sell 	=  0 if filledOrders_prc_sell ==[] else filledOrders_prc_sell [0]

			filledOrders_prc_buy	=   self.filter_one_var (filledOrder,
															price,
															side,
															'buy'
															)

			filledOrders_prc_buy    = 0 if filledOrders_prc_buy ==[] else filledOrders_prc_buy [0]

			try:				
				open				=  [ o for o in[o for o in openOrders if o[orderType]== limit ]]

			except:
				open  				=	0

			try:				
				open_buy			= [ o for o in[o for o in open if o[side]== 'buy' ]]

			except:
				open_buy  			=	0

			try:				
				open_sell			= [ o for o in[o for o in open if o[side]== 'sell' ]]

			except:
				open_sell  			=	0

			#menentukan kuantitas per  open order per instrumen
			openOrders_qty_buy      =   sum(self.filter_one_var (openOrders,
															unfilledSize,
															side,
															'buy'
															))

			openOrders_qty_sell	    =	sum(self.filter_one_var (openOrders,
															unfilledSize,
															side,
															'sell'
															))

			openOrders_time_buy	    =	(self.filter_one_var (openOrders,
															last_update_timestamp,
															side,
															'buy'
															))
			openOrders_time_buy = 0 if openOrders_time_buy == [] else max (openOrders_time_buy)


			openOrders_time_sell	=	(self.filter_one_var (openOrders,
															last_update_timestamp,
															side,
															'sell'
															))

			openOrders_time_sell = 0 if openOrders_time_sell == [] else max (openOrders_time_sell)

			openOrders_CF_fut           =[] if openOrders_CF ==[] else  (
				 							[ o for o in [o for o in openOrders_CF if o[
											instrument]==fut   ]]  ) if deri_test==0 else []											 

			openOrders_time_buy_min	    =	self.filter_one_var (openOrders,
																	last_update_timestamp,
																	side,
																	'buy'
																	)
			openOrders_time_buy_min = 0 if openOrders_time_buy_min == [] else min (openOrders_time_buy_min)


			openOrders_time_sell_min	=	self.filter_one_var (openOrders,
																	last_update_timestamp,
																	side,
																	'sell'
																	)

			openOrders_time_sell_min = 0 if openOrders_time_sell_min == [] else min (openOrders_time_sell_min)

			openOrders_time_buy_conv= 0 if openOrders_time_buy== 0 else ( 
				time_conversion( openOrders_time_buy) if deri_test == 0 else openOrders_time_buy)


			openOrders_time_sell_conv=  0 if openOrders_time_sell== 0 else (
				time_conversion( openOrders_time_sell) if deri_test == 0 else openOrders_time_sell)

			try:				
				open_time_buy= [ o for o in[o for o in open_buy if o[
					last_update_timestamp]== openOrders_time_buy_min ]]
			except:
				open_time_buy  =0

			try:				
				open_time_sell= [ o for o in[o for o in open_sell if o[
					last_update_timestamp]== openOrders_time_sell_min ]]
			except:
				open_time_sell  =0

			try:				
				open_time_buy_min= [ o for o in[o for o in open_buy if o[
					last_update_timestamp]== openOrders_time_buy ]]
			except:
				open_time_buy_min  =0

			try:				
				open_time_sell_min= [ o for o in[o for o in open_sell if o[
					last_update_timestamp]== openOrders_time_sell ]]
			except:
				open_time_sell_min  =0

			openOrders_prc_buy= 0 if open_time_buy== [] else ([ o[limitPrice] for o in [
					o for o in open_time_buy  ]])[0]

			openOrders_qty_buy_limitLen=  0 if open_buy== [] else len ([o[
			unfilledSize] for o in [o for o in open_buy]]  )

			openOrders_qty_sell_limitLen= 0 if open_sell== [] else len ([o[
			unfilledSize] for o in [o for o in open_sell ]]  )			

			print(fut,'openOrders_qty_sell_limitLen',openOrders_qty_sell_limitLen)
			print('openOrders_qty_buy_limitLen',openOrders_qty_buy_limitLen)

			openOrders_time_sell_max1=0
			
			openOrders_oid_sell_max2=0
			
			openOrders_oid_buy_max1=0
			
			openOrders_oid_buy_max2=0
			print(fut, 'openOrders_time_buy',openOrders_time_buy)
			print(fut, 'openOrders_qty_buy_limitLen',openOrders_qty_buy_limitLen)
			print(fut, 'openOrders_qty_buy_limitLen > (QTY - nbids)',openOrders_qty_buy_limitLen > (QTY - nbids))
			
#!#####    			
			if openOrders_qty_buy_limitLen > (FREQ - nbids):
    				
				openOrders_buy_minmax= 0 if openOrders_time_buy== 0 else sorted ([ o['receivedTime'] for o in [
						o for o in open_buy  ]])

				openOrders_time_buy_max1= 0 if openOrders_buy_minmax == 0 else  openOrders_buy_minmax[0]
				
				openOrders_time_buy_max2=  0 if openOrders_buy_minmax == 0 else  openOrders_buy_minmax[1]

				openOrders_oid_buy_max2= 0 if openOrders_buy_minmax == 0  else ([ o[order_id] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

				openOrders_oid_buy_max1= 0 if openOrders_buy_minmax ==0  else ([ o[order_id] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]
	#!!!!!!
				openOrders_qty_buy_max2= 0 if openOrders_buy_minmax == 0 else ([ o[unfilledSize] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

				openOrders_qty_buy_max1= 0 if openOrders_buy_minmax == 0 else ([ o[unfilledSize] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]

			if openOrders_qty_sell_limitLen > (FREQ - nbids):

				openOrders_sell_minmax= 0 if openOrders_time_sell== [] else sorted ([ o['receivedTime'] for o in [
						o for o in open_sell  ]])

				openOrders_time_sell_max1=  0 if openOrders_sell_minmax == []  else  openOrders_sell_minmax[0]

				openOrders_time_sell_max2=  0 if openOrders_sell_minmax == [] else  openOrders_sell_minmax[1]

				openOrders_oid_sell_max2= 0 if openOrders_sell_minmax == []  else ([ o[order_id] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]

				openOrders_oid_sell_max1= 0 if openOrders_sell_minmax == []   else ([ o[order_id] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

				openOrders_qty_sell_max1= 0 if openOrders_sell_minmax == [] else ([ o[unfilledSize] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

				openOrders_qty_sell_max2= 0 if openOrders_sell_minmax == [] else ([ o[unfilledSize] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]    

			
			
			cancel_test		=  (abs(openOrders_qty_sell_limitLen) + openOrders_qty_buy_limitLen) >= FREQ 
			cancel_fut_test		=  abs(openOrders_qty_sell_limitLen) >= FREQ or (cancel_test and max (
									openOrders_qty_buy_limitLen,abs(openOrders_qty_sell_limitLen))== abs(openOrders_qty_sell_limitLen))
			
			cancel_perp_test	=  openOrders_qty_buy_limitLen >= FREQ or (cancel_test and max (
									openOrders_qty_buy_limitLen,abs(openOrders_qty_sell_limitLen))==openOrders_qty_buy_limitLen)

			print('cancel_fut_test',cancel_fut_test,'cancel_perp_test',cancel_perp_test)
			if  cancel_fut_test == True or cancel_perp_test == True   :	
					
				if  openOrders_time_sell_max1 != 0:
					
					edit 		= {
					"orderId": openOrders_oid_sell_max1,
					"size": openOrders_qty_sell_max1 + openOrders_qty_sell_max2,
					}
					
					print(BLUE + str((fut,'555B','qty',openOrders_qty_sell_max1 + openOrders_qty_sell_max2,
										'openOrders_oid_sell_max1',
										openOrders_oid_sell_max1,'openOrders_qty_sell_max2',openOrders_qty_sell_max2,
										cfPrivate.edit_order(
										edit) if deri_test == 0 else (
										client_trading.private_cancel_get(
										openOrders_oid_buy_limitBal)))),ENDC)

				if  openOrders_oid_sell_max2 != 0:
					
					print(BLUE + str((fut,'openOrders_oid_sell_max2',
										openOrders_oid_sell_max2,
										cfPrivate.cancel_order(
										openOrders_oid_sell_max2) if deri_test == 0 else (
										client_trading.private_cancel_get(
										openOrders_oid_sell_max2)))),ENDC)

				if  openOrders_oid_buy_max1 != 0 :
					
					edit 		= {
					"orderId": openOrders_oid_buy_max1,
					"size":openOrders_qty_buy_max2 + openOrders_qty_buy_max1,
					}

					print(BLUE + str((fut,'555D','openOrders_oid_buy_max1',
									openOrders_oid_buy_max1,'openOrders_qty_buy_max2',openOrders_qty_buy_max2,
									'openOrders_qty_buy_max1',openOrders_qty_buy_max1,
									openOrders_qty_buy_max2 + openOrders_qty_buy_max1,
									cfPrivate.edit_order(edit) if deri_test == 0 else (
									client_trading.private_cancel_get(
									openOrders_oid_sell_limitBal)))),ENDC)
																			
				if  openOrders_oid_buy_max2 != 0 :
					print(BLUE + str((fut,'555C','openOrders_oid_buy_max2',
									openOrders_oid_buy_max2,cfPrivate.cancel_order(
									openOrders_oid_buy_max2) if deri_test == 0 else (
									client_trading.private_cancel_get(
									openOrders_oid_buy_max2)))),ENDC)

			openOrders_oid_buy= 0 if openOrders_time_buy==0  else ([ o[order_id] for o in [
					o for o in open_time_buy  ]])[0]

			openOrders_oid_sell=  0 if openOrders_time_sell== 0 else ([ o[order_id] for o in [
					o for o in open_time_sell  ]])[0]	

			openOrders_oid_buy_min= 0 if openOrders_time_buy_min== 0  else ([ o[order_id] for o in [
					o for o in open_time_buy_min  ]])[0]

			openOrders_oid_sell_min=  0 if openOrders_time_sell_min==0  else ([ o[order_id] for o in [
					o for o in open_time_sell_min  ]])[0]	

			openOrders_prc_sell= 0 if openOrders_time_sell==  0 else [ o[limitPrice] for o in [
					o for o in open_time_sell  ]] [0]

			#menghitung kuantitas limit order per instrumen
#openOrders_time_sell 
			#qty individual
			openOrders_qty_sell  = 0 if open_time_sell== [] else [ o[unfilledSize] for o in [
					o for o in open_time_sell  ]] [0]

			openOrders_qty_buy  =  0 if openOrders_time_buy==0 else [ o[unfilledSize] for o in [
					o for o in open_time_buy ]] [0]

			openOrders_qty_sell_sum  = 0 if open_sell== [] else sum ([ o[unfilledSize] for o in [
					o for o in open_sell]] )

			openOrders_qty_buy_sum  = 0 if open_buy== []else sum ([ o[unfilledSize] for o in [
					o for o in open_buy]] )

			openOrders_qty_buyQTY= 0 if open_buy== [] else sum (self.filter_two_var (open_buy,
																					unfilledSize,
																					unfilledSize,
																					QTY,
																					last_update_timestamp,
																					openOrders_time_buy
																					))

			openOrders_qty_sellQTY= 0 if open_sell== [] else sum (self.filter_two_var (open_sell,
																					unfilledSize,
																					unfilledSize,
																					QTY,
																					last_update_timestamp,
																					openOrders_time_sell
																					))

			openOrders_oid_sellBal=  0 if open_sell== [] else max([o[unfilledSize] for o in [o for o in open_sell   ]]  )

			openOrders_oid_sellBal=  0 if openOrders_oid_sellBal== 0 else (([o[order_id] for o in [o for o in open_sell if  (
				o[unfilledSize])  ==openOrders_oid_sellBal ]]  )[0])
				
			openOrders_buy_oidBal=  0 if open_buy== []  else max([o[unfilledSize] for o in [o for o in open_buy   ]]  )

			openOrders_oid_buyBal=  0 if openOrders_buy_oidBal== 0 else (([o[order_id] for o in [o for o in open_buy if  (
				o[unfilledSize])  ==openOrders_buy_oidBal ]]  )[0])

			openOrders_qty_sell_filled=   0 if open_sell== [] else ([o[
			'filledSize'] for o in [o for o in open_sell  ]]  )[0]

			openOrders_qty_buy_filled=  0 if open_buy== [] else ([o[
			'filledSize'] for o in [o for o in open_buy]]  ) [0]

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

			delta_time_buy= max (filled_time_buy,open_time_buy)  if (
				filled_time_buy == 0 or open_time_buy ==0) else min (
					filled_time_buy,open_time_buy)

			delta_time_sell= max (filled_time_sell,open_time_sell) if (
				filled_time_sell ==0 or open_time_sell==0) else min (
					filled_time_sell,open_time_sell)

			test_time_fut	=	delta_time_buy > IDLE_TIME
			test_time_perp	=	delta_time_sell > IDLE_TIME


			#order tidak dieksekusi > IDLE_TIME
			if   perp_test==1 and openOrders_oid_sell != 0  and (
				openOrders_qty_sell==QTY and open_time_sell > (IDLE_TIME-20)): 													
	
					print(BLUE + str((fut,'open time > idle time',open_time_buy,cfPrivate.cancel_order(
						openOrders_oid_sell) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell)))),ENDC)

			print(fut,'open_time_buy',open_time_buy,IDLE_TIME,openOrders_oid_buy)
			if    fut_test==1  and openOrders_oid_buy !=0 and (
				openOrders_qty_buy==QTY and open_time_buy > (IDLE_TIME-20)) :                                                   

					print(BLUE + str((fut,'open time > idle time',open_time_sell,cfPrivate.cancel_order(
						openOrders_oid_buy) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy)))),ENDC)			
	
#! seluruh kondisi hanya bosa terpenuhi 1 kali
#? kondisi 0, oke untuk perp & fut? perp masih pesan berkali2
#FIXME:
#                   mulai          > 10 menit no transaction         
			test_time_buy_beg 	= delta_time_buy > IDLE_TIME or delta_time_buy == 0
			test_time_sell_beg 	=	 delta_time_sell > IDLE_TIME or delta_time_sell ==0

			print(fut,'delta_time_sell',delta_time_sell,'delta_time_buy',delta_time_buy )
			print(CYAN + str((fut,'test_time_buy_beg',test_time_buy_beg,'test_time_sell_beg',test_time_sell_beg)),ENDC)
			openOrders_qty_buyQTY
#FIXME:
#                   test transaksi terakhir, buy/sell?                   
			test_time_buy_filled 	=	filledOrders_buy_lastTime_conv < filledOrders_sell_lastTime_conv and test_time_buy_beg == False#!
			test_time_sell_filled 	=	filledOrders_sell_lastTime_conv < filledOrders_buy_lastTime_conv and test_time_sell_beg == False

#? test apakah transaksi terakhir tersebut sudah pernah dibuatkan lawannya?                   
			test_time_sell_open 	=	 openOrders_time_sell_conv > filledOrders_buy_lastTime_conv or openOrders_time_sell_conv == 0 #!
			test_time_buy_open 	=	 openOrders_time_buy_conv > filledOrders_sell_lastTime_conv or openOrders_time_buy_conv == 0

#?bila transaksi terakhir adalah beli, maka harus jual kembali
			test_sell_perp 	=	test_time_buy_filled and test_time_sell_open 

#? bila transaksi terakhir adalah jual, maka harus beli kembali
			test_buy_fut 	=	test_time_sell_filled and test_time_buy_open 


			print(fut,'openOrders_time_sell',openOrders_time_sell,'openOrders_time_sell_conv',openOrders_time_sell_conv )
			
			print(fut,'openOrders_time_buy',openOrders_time_buy,'openOrders_time_buy_conv',openOrders_time_buy_conv )
			print(fut,'filledOrders_sell_lastTime',filledOrders_sell_lastTime,'filledOrders_sell_lastTime_conv',filledOrders_sell_lastTime_conv )

#? menentukan prc
			prc =0


			if (test_time_sell_filled and test_time_buy_open) or (fut_test==1 and test_time_buy_beg ) or (
				(test_time_buy_filled and test_time_sell_open) or (perp_test==1 and test_time_sell_beg )):													
				ord_book        = 	self.get_bbo_CF (fut)  if deri_test==0 else  self.get_bbo_drbt(futures,fut)
			
			if (test_time_sell_filled and test_time_buy_open) or (fut_test==1 and test_time_buy_beg ):													
				bid_prc         = ord_book['ask'] - TICK
				
			if (test_time_buy_filled and test_time_sell_open) or (perp_test==1 and test_time_sell_beg ):													
				ask_prc         = ord_book['bid'] + TICK
				
			if (test_time_sell_filled and test_time_buy_open)  :													
				prc=		prc + min(bid_prc,(filledOrders_prc_sell - TICK))

			if (test_time_buy_filled and test_time_sell_open) :					
				prc=		prc + max(ask_prc,(filledOrders_prc_buy + TICK))
				
#? menentukan qty
			qty= QTY * 2

#? menentukan side

			default_order = {
						"orderType": "post",
						"symbol": fut.upper(),
						"reduceOnly": "false"
						}						

			print(fut,'openOrders_qty_buyQTY',openOrders_qty_buyQTY,'openOrders_qty_sellQTY',openOrders_qty_sellQTY )

			if test_buy_fut :													
				print (GREEN + str((fut,'fut_test 2',test_time_sell_filled,test_time_buy_open)),ENDC)
				default_order= (dict(default_order,**{"side": "buy"}))

			elif (openOrders_qty_buyQTY < QTY and fut_test==1 and test_time_buy_beg ) :													
				print (GREEN + str((fut,'fut_test 1',fut_test,'openOrders_qty_buyQTY',openOrders_qty_buyQTY,
				'test_time_buy_beg',test_time_buy_beg)),ENDC)
				default_order= (dict(default_order,**{"side": "buy"}))

			if test_sell_perp :													
				print (RED + str((fut,'fut_test 4',test_time_buy_filled,test_time_sell_open)),ENDC)
				default_order= (dict(default_order,**{"side": "sell"}))

			elif (openOrders_qty_sellQTY < QTY and perp_test==1 and test_time_sell_beg ) :													
				print (RED + str((fut,'fut_test 3',fut_test,'openOrders_time_sell_conv',openOrders_time_sell_conv,
				'test_time_sell_beg',test_time_sell_beg)),ENDC)
				default_order= (dict(default_order,**{"side": "sell"}))

			if (fut_test==1 and test_time_buy_beg )  :													
				xrp_prc=float(self.truncate(bid_prc,8))
				eth_prc=float(self.truncate(bid_prc,8))

				prc		=		xrp_prc if curr== 'xrp' else  (eth_prc if curr== 'eth' else bid_prc ) 
				qty		=		QTY

			if (perp_test==1 and test_time_sell_beg ) :													
				xrp_prc=float(self.truncate(ask_prc,8))
				eth_prc=float(self.truncate(ask_prc,8))
				prc		=		xrp_prc if curr== 'xrp' else  (eth_prc if curr== 'eth' else ask_prc )  
				qty		=		QTY

			print(GREEN + str((fut,'prc',prc,'qty',qty,'default_order',default_order)),ENDC)
			print(GREEN + str((fut,'default_order len',len(default_order))),ENDC)

			print('\n')

			if  deri_test == 1 and prc !=0 :

				client_trading.private_buy_get(
											instrument_name = fut,
												reduce_only	= 'false',
												type		= limit,
												price		= prc,
												post_only	='true',
												amount		= qty
											)	

			if  deri_test == 0 and (abs(prc) > 5 if curr== 'xbt' else (abs(prc) > 0) )and len(default_order) > 3:

				print(REVERSE + str((fut,
									cfPrivate.send_order_1(dict(default_order,
									**{"size": qty,
									"limitPrice":prc}))
						)),ENDC) 

			if counter > (COUNTER ):
				while True:
					sleep (10)
					self.restart_program()
				break
								
			print(BOLD + str((fut,'counter',counter)),ENDC)

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
		mmbot = MarketMaker( )
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


#FIXME:
