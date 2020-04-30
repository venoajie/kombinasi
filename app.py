
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



def time_conversion ( waktu ):
	'''Mengonversi waktu format ISO ke UTC'''
	
	konversi	=  	time.mktime (
						datetime.strptime(
							waktu,
							'%Y-%m-%dT%H:%M:%S.%fZ').
							timetuple() )
	return konversi

def time_conversion_net  ( waktu ):
	'''Mengurangi waktu  UTC dengan waktu saat ini'''

	konversi 		= 	time_now - time_conversion(waktu) 

	return konversi


def conversion_to_utc ( waktu ):
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
	def get_position_CF(self,contract ):
    						
		try:
			get_position_CF = json.loads(cfPrivate.get_openpositions(
							        ))['openPositions']
		
		except:
			get_position_CF 	= 0

		get_position_CF = 0 if get_position_CF == 0 else [ o for o in[o for o in get_position_CF if o[
                    'symbol'][3:][:3]==contract [3:][:3]  ]]
		

		return  get_position_CF

	@lru_cache(maxsize=None)
	def openOrders_CF(self ):
    						
		return  json.loads(cfPrivate.get_openorders())['openOrders'] 

	@lru_cache(maxsize=None)
	def get_tick_CF(self,contract ):
		'''get TICK/instrument'''
   						
		instrument=json.loads(cfPublic.getinstruments())['instruments']
		tick = ([o['tickSize']  for o in [o for o in instrument if  
								o['symbol']==contract]] [0])
		return tick

	@lru_cache(maxsize=None)
	def get_tickers_CF(self ):
		'''get ticker CF: rangkuman semua informasi penting: order book, instrument, dst'''
    						
		tickers 	=	json.loads(cfPrivate.get_tickers())['tickers']
		tickers		=	list(tuple(tickers))#https://stackoverflow.com/questions/39189272/python-list-comprehension-and-json-parsing
		
		return  tickers

	@lru_cache(maxsize=None)
	def get_bbo_CF( self,  contract ):
  		
		tickers 	=	self.get_tickers_CF()

		bid_prc		=  [ o['bid'] for o in[o for o in tickers  if o['symbol']==contract]] [0]
		ask_prc		=   [ o['ask'] for o in[o for o in tickers  if o['symbol']==contract]] [0]
		  		
		return { 'bid': bid_prc, 'ask': ask_prc, 'tickers':tickers}

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

	def truncate(self,f, contract):
		'''Truncates/pads a float f to n decimal places without rounding'''
		s 		= '%.12f' % f
		i, p, d = s.partition('.')
		curr    = 	contract [3:][:3] #'xbt'/'xrp')

		if curr == 'xbt':
			n 	= 2

		elif curr == 'eth':
			n 	= 2

		elif curr == 'xrp':
			n 	= 8

		else :
			n 	= 8

		return '.'.join([i, (d+'0'*n)[:n]])

	def get_non_perpetual (self,currency):
		'''get non-perpetual instruments'''
		tickers 	=	self.get_tickers_CF()
		fut = [( [ o['symbol'] for o in[
				o for o in tickers if o[
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

		xbt_non_perp 		= self.get_non_perpetual ('xbt')[0]

		xrp_non_perp 		= self.get_non_perpetual ('xrp') [0]
		eth_non_perp		= self.get_non_perpetual ('eth') [0]

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
		instruments_list	= list(instruments_list_xbt + instruments_list_alts)
		instruments_list 	= instruments_list_xbt if TRAINING  ==   True  else instruments_list

		chck_key=str(int(start_unix/1000))[8:9]#memperkenalkan random untuk multi akun
		chck_key_list=['1','3','5','7','9']
		instruments_list= instruments_list if chck_key in chck_key_list  else  instruments_list[::-1]

#!mendapatkan atribut isi akun deribit vs crypto facilities			
		
		openOrders_CF	=	 self.openOrders_CF()
        
		openOrders_CF	= [] if openOrders_CF ==[] else openOrders_CF
				 		
		for fut in instruments_list:
					
			deri_test	= 0 if (fut[:1] == 'p' or fut[:1]=='f') else 1 #membagi deribit vs crypto facilities	
			sub_name    = 'CF' if deri_test == 0 else account ['username']#deri + xbt_CF + y) )) #mendapatkan nama akun deribit vs crypto facilities
			nbids		=	1
			nasks		=	1
			FREQ 		= 	2 if TRAINING  ==   True  else 10
			FREQ		=	FREQ -	max(nasks,nbids)				
			n			=	10		
			QTY         = 	10
			IDLE_TIME 	= 120 if TRAINING  ==   True  else 480
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
			buy         	=	('buy' or 'buy')
			sell        	=	('sell' or 'sell') 
			longs         	=	('long'  if deri_test ==0 else 'buy')
			short         	=	('short'  if deri_test ==0 else 'buy')
			limit    		=	('lmt'  if deri_test ==0 else 'limit' ) 
			stop    		=	('stop' if deri_test ==0 else 'stop') 
			curr    		= 	fut [3:][:3] #'xbt'/'xrp')
			TICK			= 	self.get_tick_CF(fut)
			TICK			= 	TICK if deri_test == 0 else (1/2)
			QTY         	=	QTY if curr== 'xbt' else  (max(1, int(QTY)) if curr== 'eth' else QTY *2 )#* 3
			
			perp_test_xbt   =	(1 if xbt_perp[0]==fut else 0) if deri_test ==0 else (
								1 if fut [-10:] == '-PERPETUAL' else 0)

			perp_test_xrp   =	(1 if xrp_perp[0]==fut else 0) if deri_test ==0 else (
								1 if fut [-10:] == '-PERPETUAL' else 0)

			perp_test_eth   =	(1 if eth_perp[0]==fut else 0) if deri_test ==0 else (
								1 if fut [-10:] == '-PERPETUAL' else 0)

			perp_test_CF    = perp_test_xbt if curr== 'xbt' else ( perp_test_xrp if curr== 'xrp' else perp_test_eth)
			
			perp_test   	=	perp_test_CF if deri_test ==0 else (1 if fut [-10:] == '-PERPETUAL' else 0)

			fut_test_xbt 	=	( 1 if ( xbt_fut == fut   ) else 0 )

			fut_test_xrp 	=  0 if TRAINING==True else ( 1 if ( xrp_fut ==fut  ) else 0 ) 
			fut_test_eth 	=  0 if TRAINING==True else ( 1 if ( eth_fut ==fut  ) else 0 ) 

			fut_test_CF     =	fut_test_xbt if curr== 'xbt' else ( fut_test_xrp if curr== 'xrp' else fut_test_eth) 

			fut_test    	=	fut_test_CF# if deri_test==0 else (1 if stamp_new == fut  else 0)


#! mendapatkan kontrak outstanding --> 								

			position_CF_fut = self.get_position_CF(fut)

			positions       = position_CF_fut if deri_test == 0 else  (
								client_account.private_get_positions_get(currency=(fut[:3]
				)				, kind='future')['result'])
			
			position        = position_CF_fut if deri_test == 0 else (
								client_account.private_get_position_get(fut)['result'])

	# berdasarkan harga

			hold_avgPrc_buy		=	self.filter_two_var (positions,avgPrc,side,longs,instrument,fut )
			hold_avgPrc_buy		= 0 if  hold_avgPrc_buy == [] else hold_avgPrc_buy[0]

			hold_avgPrc_sell    =  self.filter_two_var (positions,avgPrc,side,short,instrument,fut )	
			hold_avgPrc_sell		= 0 if  hold_avgPrc_sell == [] else hold_avgPrc_sell[0]

	# berdasarkan qty

			hold_qty_buy		= self.filter_two_var (positions,size,side,longs,instrument,fut ) 
			hold_qty_buy		= 0 if  hold_qty_buy == [] else hold_qty_buy[0]
			hold_qty_sell		= self.filter_two_var (positions,size,side,short,instrument,fut ) 
			hold_qty_sell		= 0 if  hold_qty_sell == [] else hold_qty_sell[0]
			print(fut,'hold_avgPrc_buy',hold_avgPrc_buy,'hold_avgPrc_sell',hold_avgPrc_sell)
			print(fut,'hold_qty_buy',hold_qty_buy,'hold_qty_sell',hold_qty_sell)

#! mendapatkan atribut RIWAYAT transaksi deribit vs crypto facilities-->FILLED 								
			filledOrder 	=	self.filledOrder_cf(fut) #if deri_test == 0 else  self.filledOrder_drbt( fut ) 

	# cek waktu transaksi--> fillTime
			filledOrders_sell_Time	=   self.filter_one_var (filledOrder,
																fillTime,
																side,
																'sell'
																)
		# cek waktu transaksi terbaru--> fillTime
			filledOrders_sell_lastTime = 0 if filledOrders_sell_Time == [] else max (filledOrders_sell_Time)

		# konversi waktu transaksi ke UTC--> time_conversion
			filledOrders_sell_lastTime_conv	= 0 if filledOrders_sell_lastTime == 0 else (
												time_conversion  ((
													filledOrders_sell_lastTime)) if deri_test == 0 else filledOrders_sell_lastTime)

		# waktu transaksi UTC di-net dg waktu saat ini--> time_conversion_net: now
			filledOrders_sell_lastTime_conv_net	= 0 if filledOrders_sell_lastTime == 0 else (
												time_conversion_net  ((
													filledOrders_sell_lastTime)) if deri_test == 0 else filledOrders_sell_lastTime)

	# cek waktu transaksi--> fillTime
			filledOrders_buy_Time	=   self.filter_one_var (filledOrder,
																		fillTime,
																		side,
																		'buy'
																		)
		# cek waktu transaksi terbaru--> fillTime
			filledOrders_buy_lastTime = 0 if filledOrders_buy_Time == [] else max (filledOrders_buy_Time)


		# konversi waktu transaksi ke UTC--> time_conversion
			filledOrders_buy_lastTime_conv	= 0 if filledOrders_buy_lastTime == 0 else (
												time_conversion  ((filledOrders_buy_lastTime)) if deri_test == 0 else filledOrders_buy_lastTime)

		# waktu transaksi UTC di-net dg waktu saat ini--> time_conversion_net: now
			filledOrders_buy_lastTime_conv_net	= 0 if filledOrders_buy_lastTime == 0 else (
												time_conversion_net  ((filledOrders_buy_lastTime)) if deri_test == 0 else filledOrders_buy_lastTime)

	# cek harga transaksi--> price 'sell'
			filledOrders_prc_sell	=   self.filter_one_var (filledOrder,
															price,
															side,
															'sell'
															)
			filledOrders_prc_sell 	=  0 if filledOrders_prc_sell ==[] else filledOrders_prc_sell [0]

	# cek harga transaksi--> price 'buy'
			filledOrders_prc_buy	=   self.filter_one_var (filledOrder,
															price,
															side,
															'buy'
															)

			filledOrders_prc_buy    = 0 if filledOrders_prc_buy ==[] else filledOrders_prc_buy [0]

	# cek harga transaksi--> price 'sell'
			filledOrders_qty_sell	=   self.filter_one_var (filledOrder,
															size,
															fillTime,
															filledOrders_sell_lastTime
															)
			filledOrders_qty_sell 	=  0 if filledOrders_qty_sell ==[] else filledOrders_qty_sell [0]

	# cek harga transaksi--> price 'buy'
			filledOrders_qty_buy	=   self.filter_one_var (filledOrder,
															size,
															fillTime,
															filledOrders_buy_lastTime
															)

			filledOrders_qty_buy    = 0 if filledOrders_qty_buy ==[] else filledOrders_qty_buy [0]


#! mendapatkan atribut OPEN ORDER/transaksi belum tereksekusi --> openOrders								

			openOrders_CF_fut       = [] if (openOrders_CF ==[] and deri_test==0 ) else  (
				 							[ o for o in [o for o in openOrders_CF if o[
											instrument]==fut   ]]  ) 										 
			
			openOrders              = openOrders_CF_fut if deri_test==0 else (
                            			client_trading.private_get_open_orders_by_instrument_get (
											instrument_name=fut)['result'])

			try:				
				open				=  [ o for o in[o for o in openOrders  ]]#if o[orderType]== limit

			except:
				open  				=	0

	# cek seluruh open long--> 'buy'
			try:				
				open_buy			= [ o for o in[o for o in open if o[side]== 'buy' ]]

			except:
				open_buy  			=	0

	# cek seluruh open sell--> 'sell'
			try:				
				open_sell			= [ o for o in[o for o in open if o[side]== 'sell' ]]

			except:
				open_sell  			=	0


		# cek waktu order beli disubmit--> last_update_timestamp										 
			openOrders_time_buy	    =	(self.filter_one_var (openOrders,
															last_update_timestamp,
															side,
															'buy'
															))

		# cek waktu order beli TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_time_buy_min = 0 if openOrders_time_buy == [] else min (openOrders_time_buy)

		# cek waktu order beli TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_time_buy_max = 0 if openOrders_time_buy == [] else max (openOrders_time_buy)

		# konversi waktu transaksi ke UTC--> time_conversion
			openOrders_time_buy_max_conv	= 0 if openOrders_time_buy_max== 0 else ( 
											time_conversion  ( openOrders_time_buy_max) if deri_test == 0 else openOrders_time_buy_max)

		# waktu transaksi UTC di-net dg waktu saat ini--> time_conversion_net: now
			openOrders_time_buy_max_conv_net	= 0 if openOrders_time_buy_max== 0 else ( 
											time_conversion_net  ( openOrders_time_buy_max) if deri_test == 0 else openOrders_time_buy_max)

		# cek waktu order jual disubmit--> last_update_timestamp										 
			openOrders_time_sell	=	self.filter_one_var (openOrders,
														last_update_timestamp,
														side,
														'sell'
														)

		# cek waktu order jual TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_time_sell_min 	= 0 if openOrders_time_sell == [] else min (openOrders_time_sell)

		# cek waktu order jual TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_time_sell_max 	= 0 if openOrders_time_sell == [] else max (openOrders_time_sell)


		# konversi waktu order disubmit ke UTC--> time_conversion
			openOrders_time_sell_max_conv	=  0 if openOrders_time_sell_max== 0 else (
											time_conversion ( openOrders_time_sell_max) if deri_test == 0 else openOrders_time_sell_max)

		# waktu order UTC di-net dg waktu saat ini--> time_conversion_net: now
			openOrders_time_sell_max_conv_net	=  0 if openOrders_time_sell_max== 0 else (
											time_conversion_net ( openOrders_time_sell_max) if deri_test == 0 else openOrders_time_sell_max)

		# cek harga order beli TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_prc_buy_min			= 0 if openOrders_time_buy_min == 0 else ([ o[limitPrice] for o in [
												o for o in open_buy if o[
												last_update_timestamp]== openOrders_time_buy_min ]])[0]

		# cek harga order beli TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_prc_buy_max			= 0 if openOrders_time_buy_max == 0 else ([ o[limitPrice] for o in [
												o for o in open_buy if o[
												last_update_timestamp]== openOrders_time_buy_max ]])[0]

		# cek harga order jual TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_prc_sell_min			= 0 if openOrders_time_sell_min == 0 else ([ o[limitPrice] for o in [
												o for o in open_sell if o[
												last_update_timestamp]== openOrders_time_sell_min ]])[0]

		# cek harga order jual TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_prc_sell_max			= 0 if openOrders_time_sell_max == 0 else ([ o[limitPrice] for o in [
												o for o in open_sell if o[
												last_update_timestamp]== openOrders_time_sell_max ]])[0]

		# cek kuantitas JUMLAH order beli  disubmit								 
			openOrders_qty_buy_sum		= 0 if open_buy == 0 else sum ([ o[unfilledSize] for o in [
												o for o in open_buy   ]])

		# cek kuantitas JUMLAH order jual disubmit								 
			openOrders_qty_sell_sum		= 0 if open_sell == 0 else sum ([ o[unfilledSize] for o in [
												o for o in open_sell  ]])

		# cek kuantitas order belum terkesekusi di order book--> unfilledSize : max 10 per instrumen di CF								 
			openOrders_qty_buy_Len	=  0 if open_buy== [] else len ([o[
											unfilledSize] for o in [o for o in open_buy]]  )

		# cek kuantitas order belum terkesekusi di order book--> unfilledSize : max 10 per instrumen di CF								 
			openOrders_qty_sell_Len= 0 if open_sell== [] else len ([o[
											unfilledSize] for o in [o for o in open_sell ]]  )			

		# cek kuantitas order beli TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_qty_buy_max		= 0 if openOrders_time_buy_max == 0 else ([ o[unfilledSize] for o in [
												o for o in open_buy  if o[
													last_update_timestamp]== openOrders_time_buy_max ]])[0]

		# cek kuantitas order jual TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_qty_sell_max		= 0 if openOrders_time_sell_max == 0 else ([ o[unfilledSize] for o in [
												o for o in open_sell  if o[
													last_update_timestamp]== openOrders_time_sell_max ]])[0]
																								
			openOrders_time_sell_max1	= 0
			
			openOrders_oid_sell_max2	= 0
			
			openOrders_oid_buy_max1		= 0
			
			openOrders_oid_buy_max2		= 0

			cancel_test					=  (abs(openOrders_qty_sell_Len) + openOrders_qty_buy_Len) >= (FREQ - nbids) 

			cancel_sell					=  (abs(openOrders_qty_sell_Len) >= (FREQ - nbids) or (cancel_test and max (
											openOrders_qty_buy_Len,abs(
											openOrders_qty_sell_Len))== abs(openOrders_qty_sell_Len))) and (
											openOrders_qty_sell_Len >1 and openOrders_time_sell_max !=0)
			
			cancel_buy  				=  (openOrders_qty_buy_Len >= (FREQ - nbids) or (cancel_test and max (
											openOrders_qty_buy_Len,abs(
											openOrders_qty_sell_Len))==openOrders_qty_buy_Len)) and (
											openOrders_qty_buy_Len > 1 and openOrders_time_buy_max !=0)

#!#####    	
			if cancel_buy :
    				
				openOrders_buy_minmax= sorted ([ o['receivedTime'] for o in [
						o for o in open_buy  if  o['orderType']== 'lmt' ]])

				print(fut,'openOrders_buy_minmax',openOrders_buy_minmax)

				openOrders_time_buy_max1=  (0 if openOrders_qty_buy_Len <= 1 else  openOrders_buy_minmax[0])
				
				openOrders_time_buy_max2= openOrders_buy_minmax[1]

				openOrders_oid_buy_max2=  ([ o[order_id] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

				openOrders_oid_buy_max1=  ([ o[order_id] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]
	#!!!!!!
				openOrders_qty_buy_max2=  ([ o[unfilledSize] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

				openOrders_qty_buy_max1= ([ o[unfilledSize] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]

				openOrders_prc_buy_max2=  ([ o[limitPrice] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

				openOrders_prc_buy_max1= 0 if openOrders_time_buy_max1 == 0 else ([ o[limitPrice] for o in [
						o for o in open_buy  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]

			if cancel_sell  :

				openOrders_sell_minmax=  sorted ([ o['receivedTime'] for o in [
						o for o in open_sell if o['orderType']== 'lmt' ]])

				openOrders_time_sell_max1= openOrders_sell_minmax[0]

				openOrders_time_sell_max2= openOrders_sell_minmax[1]

				openOrders_oid_sell_max2= ([ o[order_id] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]

				openOrders_oid_sell_max1=  ([ o[order_id] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

				openOrders_qty_sell_max1= ([ o[unfilledSize] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

				openOrders_qty_sell_max2=  ([ o[unfilledSize] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]    

				openOrders_prc_sell_max1= ([ o[limitPrice] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

				openOrders_prc_sell_max2=  ([ o[limitPrice] for o in [
						o for o in open_sell  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]    


			print(fut,'open_buy',open_buy)
			print(fut,'open_sell',open_sell)
#! *********************************
	# cek seluruh open sell--> 'sell'
			try:				
				openOrders_oid_buy_lmt= 0 if openOrders_time_buy_max== 0  else ([ o[order_id] for o in [
					o for o in open_buy if o[last_update_timestamp]== openOrders_time_buy_max and o[
						'orderType']== 'lmt' ]])[0]

			except:
				openOrders_oid_buy_lmt  			=	0

			try:				
				openOrders_oid_sell_lmt= 0 if openOrders_time_sell_max== 0 else ([ o[order_id] for o in [
					o for o in open_sell if o[last_update_timestamp]== openOrders_time_sell_max and o[
						'orderType']== 'lmt' ]])[0]	
			except:
				openOrders_oid_sell_lmt  			=	0


			try:				
				openOrders_oid_buy_stp= 0 if openOrders_time_buy_max== 0  else ([ o[order_id] for o in [
					o for o in open_buy if o[last_update_timestamp]== openOrders_time_buy_max and o[
						'orderType']== 'stop']])[0]
			except:
				openOrders_oid_buy_stp  			=	0

			try:				
				openOrders_oid_sell_stp= 0 if openOrders_time_sell_max== 0 else ([ o[order_id] for o in [
					o for o in open_sell if o[last_update_timestamp]== openOrders_time_sell_max  and o[
						'orderType']== 'stop']])[0]
			except:
				openOrders_oid_sell_stp  			=	0


#! *********************************


#! DELTA TIME: menghitung waktu filled/OS:								

			delta_time_buy				= max (filledOrders_buy_lastTime_conv_net,openOrders_time_buy_max_conv_net)  if (
											filledOrders_buy_lastTime_conv_net == 0 or openOrders_time_buy_max_conv_net ==0) else min (
											filledOrders_buy_lastTime_conv_net, openOrders_time_buy_max_conv_net)

			delta_time_sell				= max (filledOrders_sell_lastTime_conv_net,openOrders_time_sell_max_conv_net) if (
											filledOrders_sell_lastTime_conv_net ==0 or openOrders_time_sell_max_conv_net==0) else min (
											filledOrders_sell_lastTime_conv_net, openOrders_time_sell_max_conv_net)
	
#! CANCEL								

			if  cancel_buy  == True or cancel_sell == True   :	

	# berdasarkan FREKUENSI order per instrumen (max: 10)

				if  openOrders_time_sell_max1 != 0:

					prc=(openOrders_prc_sell_max2 + openOrders_prc_sell_max1)/2
					alts_prc		= float(self.truncate(prc,fut))
					prc_lmt			=  prc if curr== 'xbt' else  alts_prc
					prc_lmt		= round(prc_lmt,0)+TICK

					
					edit 		= {
					"limitPrice": prc_lmt,
					"orderId": openOrders_oid_sell_max1,
					"size": openOrders_qty_sell_max1 + openOrders_qty_sell_max2,
					}
					
					print(BLUE + str((fut,'555B','prc_lmt',prc_lmt,'qty',openOrders_qty_sell_max1 + openOrders_qty_sell_max2,
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
    					
					prc=(openOrders_prc_buy_max2 + openOrders_prc_buy_max1)/2
					alts_prc		= float(self.truncate(prc,fut))
					prc_lmt			=  prc if curr== 'xbt' else  alts_prc
					prc_lmt		= round(prc_lmt,0)-TICK
					
					edit 		= {
					"orderId": openOrders_oid_buy_max1,
					"limitPrice": prc_lmt,
					"size":openOrders_qty_buy_max2 + openOrders_qty_buy_max1,
					}

					print(BLUE + str((fut,'555D','prc_lmt',prc_lmt,'openOrders_oid_buy_max1',
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

	# berdasarkan WAKTU/QTY order os di order book per instrumen (max: 10)
#! cancel karena waktu
			if  openOrders_oid_buy_stp !=0 and ( openOrders_time_sell_max_conv_net > (
				(IDLE_TIME)-20)) : 													
	
					print(BLUE + str((fut,'AAA',cfPrivate.cancel_order(
						openOrders_oid_buy_stp) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_stp)))),ENDC)

	
					print(BLUE + str((fut,'BBB',cfPrivate.cancel_order(
						openOrders_oid_sell_lmt) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_lmt)))),ENDC)

			if     openOrders_oid_sell_stp != 0   and (openOrders_time_buy_max_conv_net > (
				(IDLE_TIME)-20)) :                                                   
	
					print(BLUE + str((fut,'CCC',cfPrivate.cancel_order(
						openOrders_oid_sell_stp) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_stp)))),ENDC)

	
					print (BLUE + str((fut,'DDD',cfPrivate.cancel_order(
						openOrders_oid_buy_lmt) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_lmt)))),ENDC)

#!#######
#! cancel karena kondisi imbalance (hanya ada 1 stop tanpa limit, vv)

			hold_qty 					=	 hold_qty_buy - abs(hold_qty_sell) #! kalau 0 bagaimana?
			qty_open_net				=	openOrders_qty_buy_sum - openOrders_qty_sell_sum
			test_hold_open_bal			= max (hold_qty_buy,hold_qty_sell) 
			imbalance_qty_sell			= ((hold_qty_buy + openOrders_qty_buy_sum) - (hold_qty_sell +  openOrders_qty_sell_sum ) ) > 0  
			imbalance_qty_buy			= ((hold_qty_buy + openOrders_qty_buy_sum) - (hold_qty_sell +  openOrders_qty_sell_sum ) ) < 0
			
			#! tidak berlaku kalau ada eksekusi partial
			cancel_imbalance_sell		=  imbalance_qty_buy and openOrders_qty_sell_sum > hold_qty_sell and abs(hold_qty_buy-abs(qty_open_net)) == QTY 
			cancel_imbalance_buy		=  imbalance_qty_sell and openOrders_qty_buy_sum > hold_qty_buy and  abs(hold_qty_sell- abs(qty_open_net)) == QTY
			
#??? TAMBAHAN TERAKHIR
			#! bila hanya ada satu stop/limit order
				#! len: hanya ada 1 order tersisa
				#! hold: secara net open vs hold, tidak nol (harusnya nol/ada pasangannya)
				#! open: secara net open, mmg hanya tersisa 1
			balance_hold_buy			= hold_qty_buy +  openOrders_qty_buy_sum - openOrders_qty_sell_sum 
			balance_hold_sell			= hold_qty_sell +  openOrders_qty_sell_sum - openOrders_qty_buy_sum 

			#! balance_hold...memastika selisih semata dari open 
			imbalance_open				= qty_open_net != 0 and (balance_hold_sell ==0 and balance_hold_buy ==0)

			#! hold_qty_...konfirmasi kalau selisih mmg disebabkan oleh saldo tanpa lawan, bkn karena saldo hold ada di lawan (makanya 0) 
			imbalance_sell_one	=   ((balance_hold_sell != 0 and hold_qty_buy == 0)or imbalance_open) and openOrders_qty_sell_Len == 1  
			imbalance_buy_one	=  ((balance_hold_buy != 0  and hold_qty_sell ==0) or imbalance_open) and openOrders_qty_buy_Len == 1 

			cancel_imbalance_sell_one	=  imbalance_sell_one and (openOrders_oid_sell_stp != 0 or openOrders_oid_sell_lmt != 0) 

			cancel_imbalance_buy_one	= imbalance_buy_one and (openOrders_oid_buy_stp != 0 or openOrders_oid_buy_lmt != 0 ) 

			imbalance_sell_two	=   balance_hold_buy != 0 and openOrders_qty_sell_Len > 1 
			imbalance_buy_two	=  balance_hold_sell != 0  and openOrders_qty_buy_Len > 1  
			
			cancel_imbalance_sell_two	=  imbalance_sell_two and  (openOrders_oid_sell_stp != 0 or openOrders_oid_sell_lmt != 0) 
			cancel_imbalance_buy_two	= imbalance_buy_two and (openOrders_oid_buy_stp != 0 or openOrders_oid_buy_lmt != 0 ) 
			

			print(CYAN + str((fut,'cancel_imbalance_sell_one', cancel_imbalance_sell_one,'cancel_imbalance_buy_one',cancel_imbalance_buy_one )),ENDC)
			print(fut,'imbalance_sell_one',imbalance_sell_one,'imbalance_buy_one',imbalance_buy_one)
			print(fut,'imbalance_open',imbalance_open)

			print(CYAN + str((fut,'cancel_imbalance_sell_two', cancel_imbalance_sell_two,'cancel_imbalance_buy_two',cancel_imbalance_buy_two )),ENDC)
			print(fut,'imbalance_sell_two',imbalance_sell_two,'imbalance_buy_two',imbalance_buy_two)
			print(fut,'openOrders_qty_buy_Len',openOrders_qty_buy_Len,'openOrders_qty_sell_Len',openOrders_qty_sell_Len)
			print(fut,'balance_hold_sell',balance_hold_sell,'balance_hold_buy',balance_hold_buy)
			print(fut,'qty_open_net',qty_open_net,'test_hold_open_bal',test_hold_open_bal)

			print(fut,'cancel_imbalance_sell',cancel_imbalance_sell,'cancel_imbalance_buy',cancel_imbalance_buy)
			print(fut,'imbalance_qty_sell',imbalance_qty_sell,'imbalance_qty_buy',imbalance_qty_buy)
			print(fut,' cancel_imbalance_sell == False', cancel_imbalance_sell == False,'cancel_imbalance_buy == False',cancel_imbalance_buy == False)
			print(fut,'(hold_qty_buy + openOrders_qty_buy_sum)',(hold_qty_buy + openOrders_qty_buy_sum),'(hold_qty_sell +  openOrders_qty_sell_sum )',(hold_qty_sell +  openOrders_qty_sell_sum ))
			print(fut, ((hold_qty_buy + openOrders_qty_buy_sum) - (hold_qty_sell +  openOrders_qty_sell_sum ) ))			
			print(fut,'openOrders_qty_sell_sum > hold_qty_sell',openOrders_qty_sell_sum > hold_qty_sell,
			'openOrders_qty_buy_sum > hold_qty_buy',openOrders_qty_buy_sum > hold_qty_buy)


			if    cancel_imbalance_sell_one or cancel_imbalance_sell_two: 													
	
					if openOrders_oid_sell_stp !=0:
						print(BLUE + str((fut,'AAAA',cfPrivate.cancel_order(
						openOrders_oid_sell_stp) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_stp)))),ENDC)

	
					if openOrders_oid_sell_lmt !=0:
						print(BLUE + str((fut,'BBBB',cfPrivate.cancel_order(
						openOrders_oid_sell_lmt) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_lmt)))),ENDC)

						self.restart_program()

			if    cancel_imbalance_buy_one or cancel_imbalance_buy_two:                                                   
	
					if openOrders_oid_buy_stp   !=0:
						print(BLUE + str((fut,'CCCC',cfPrivate.cancel_order(
						openOrders_oid_buy_stp) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_sell_stp)))),ENDC)

	
					if openOrders_oid_buy_lmt !=0:
						print (BLUE + str((fut,'DDD D',cfPrivate.cancel_order(
						openOrders_oid_buy_lmt) if deri_test == 0 else (
						client_trading.private_cancel_get(openOrders_oid_buy_lmt)))),ENDC)

						self.restart_program()



#! Kapan boleh mengorder?

	#? Mengorder berdasarkan saldo, tujuannya saldo selalu (mendekati) 0
		#! pesan tahap awal, aturan fut/perp berlaku: fut-> buy, perp-> sell
		#! tahap berikutnya, pesan tergantung posisi net, jadi saldo selalu terjaga
		#! setiap pesan, selesai pada saat itu dg lawannya, jadi tidak ada menggulung. Pesan langsung lawan stop
		#! manajemen pesanan saja ini sebnarnya + penundaan realisasi laba kalau masih rugi
		#! pengaman:
			#!- order hanya bila imbang
			#!- tidak imbang: imbangi dulu baru boleh order lagi / Cancel
	


#FIXME:
# kalau order dipenuhi nggak full, bagaimana cancelnya?
# pembuatan lawan bla ada yang nyangkut kecepetan

		#? Kontrol kuantitas transaksi, memastikan setiap kondisi hanya 
		#? menghasilkan 1 order, dan setiap eksekusi memiliki hanya 1 lawan

		#?  cek qty


			#! init: awal operasi, ditentukan berdasarkan saldo instrumen 

			test_qty_buy_init	=	hold_qty == 0 and openOrders_qty_buy_Len == 0 or hold_qty <= QTY#! benar2 kosong, fill 0. open order 0
			test_qty_sell_init	=	hold_qty == 0  and openOrders_qty_sell_Len == 0 or hold_qty >= QTY 
			print(fut,'hold_qty',hold_qty,'test_qty_buy_init',test_qty_buy_init,'test_qty_sell_init',test_qty_sell_init)


			print(fut, 'AAA','openOrders_qty_buy_sum',openOrders_qty_buy_sum,'openOrders_qty_sell_sum',openOrders_qty_sell_sum )

		#? cek waktu
			#? awal, posisi 0
	
			test_time_buy_init  =  	(delta_time_buy > IDLE_TIME or  delta_time_buy == 0 ) and fut_test ==1  and hold_qty_buy == 0
			test_time_sell_init =	(delta_time_sell > IDLE_TIME or delta_time_sell ==0  ) and perp_test ==1 and hold_qty_sell == 0	  

			print(fut,'test_time_buy_init',test_time_buy_init,'test_time_sell_init',test_time_sell_init)
			print(fut,'delta_time_buy',delta_time_buy,'delta_time_sell',delta_time_sell)

			#? Transaksi tidak tereksekusi segera, diasumsikan ada yang salah

			test_time_buy_run 		=	 openOrders_time_buy_max_conv_net > IDLE_TIME * 2 or (
										hold_qty_sell > 0 and filledOrders_buy_lastTime_conv_net > IDLE_TIME *2 
										) #! berarti order beli tidak tereksekusi. 
																						#! diasumsikan posisi short dah berjalan jauh
																						#! diimbangi dengan buy, sehingga saldo 0, vice versa
			test_time_sell_run		=	openOrders_time_sell_max_conv_net > IDLE_TIME * 2 or (
										hold_qty_buy > 0 and filledOrders_sell_lastTime_conv_net > IDLE_TIME* 2	
										)
			print(fut,'test_time_buy_run',test_time_buy_run,'test_time_sell_run',test_time_sell_run)
			print(fut,'openOrders_time_buy_max_conv_net',openOrders_time_buy_max_conv_net,'openOrders_time_sell_max_conv_net',openOrders_time_sell_max_conv_net)
			print(fut,'filledOrders_buy_lastTime_conv_net',filledOrders_buy_lastTime_conv_net,'filledOrders_sell_lastTime_conv_net',filledOrders_sell_lastTime_conv_net)


			#! qty OK, time OK, freq OK
			order_buy_init			= 	(test_time_buy_init or test_time_buy_run)  and openOrders_oid_sell_stp ==0 and (
										imbalance_qty_sell == False and imbalance_qty_buy == False)
			order_sell_init			= 	(test_time_sell_init or test_time_sell_run) and openOrders_oid_buy_stp ==0 and (
										imbalance_qty_sell == False and imbalance_qty_buy == False)
			print(fut,'order_buy_init',order_buy_init,'order_sell_init',order_sell_init)
			print(fut,'openOrders_oid_sell_stp',openOrders_oid_sell_stp,'openOrders_oid_buy_stp',openOrders_oid_buy_stp)

#? menentukan prc & qty
			
		#	if order_buy or order_sell:	
		
			print('\n')
			ord_book        = 	self.get_bbo_CF (fut)  if deri_test==0 else  self.get_bbo_drbt(futures,fut) #! ord book diakses terus tanpa if
			
			if order_buy_init:													
				bid_prc         = (ord_book['ask'] - TICK ) if abs( (ord_book['bid'] - (
									abs(ord_book['ask'] - TICK) ) ) > TICK * 2) else ord_book['bid']
				alts_prc_buy	= float(self.truncate(bid_prc,fut))
				bid_prc				= bid_prc if curr== 'xbt' else alts_prc_buy
				print(f'AAA {fut} bid_prc {bid_prc} alts_prc_buy {alts_prc_buy}')
								
			if order_sell_init:													
				ask_prc         = (ord_book['bid'] + TICK ) if  abs((ord_book['ask'] - (
									ord_book['bid'] + TICK)) > TICK * 2) else ord_book['ask']
				alts_prc_sell	= float(self.truncate(ask_prc,fut))				
				ask_prc				= ask_prc if curr== 'xbt' else alts_prc_sell
				print(f'BBB {fut} ask_prc {ask_prc} alts_prc_sell {alts_prc_sell}')

			#print(self.get_bbo_CF (fut) )

			if  deri_test == 1 and prc !=0 :

				client_trading.private_buy_get(
											instrument_name = fut,
												reduce_only	= 'false',
												type		= limit,
												price		= prc,
												post_only	='true',
												amount		= qty
											)	

			if deri_test == 0 :
			
				print( fut,'order_buy_init or imbalance_qty_buy',order_buy_init or imbalance_qty_buy)
				print( fut,'order_sell_init or imbalance_qty_sell',order_sell_init or imbalance_qty_sell)
				
				default_order = {
						"symbol": fut.upper(),
						"reduceOnly": "false"
						}						

				default_order_buy= (dict(default_order,**{"side": "buy"}))

				default_order_sell= (dict(default_order,**{"side": "sell"}))


				qty = QTY
				qty				= 	abs(test_hold_open_bal) if 	imbalance_qty_buy else qty	

				if order_buy_init or imbalance_qty_buy:					
										

					#! menghitung prc imbalance	
					prc_imb			= hold_avgPrc_sell - ( (1/100)/2 * hold_avgPrc_sell)
					alts_prc		= float(self.truncate((prc_imb),fut))-TICK	
					prc_imb			=  round(prc_imb,0)-TICK if curr== 'xbt' else  alts_prc
					prc				= 	prc_imb if imbalance_qty_buy else bid_prc	

					if imbalance_qty_buy :
 
    						print(GREEN + str((fut,'imbalance_qty_sell ',imbalance_qty_sell ,
							'imbalance_qty_buy ',imbalance_qty_buy ,'prc_imb',prc_imb,'qty',qty  )),ENDC)

					if  order_buy_init and imbalance_qty_buy == False:
						alts_prc_buy		= float(self.truncate(bid_prc + (TICK*4),fut))
						print(fut,'alts_prc_buy',alts_prc_buy )
						prc_lmt			=  (bid_prc +  (TICK*5) if curr== 'xbt' else  (alts_prc_buy ) )
						print(GREEN + str((fut,'prc_lmt',prc_lmt,'triggerPrice',bid_prc  )),ENDC)
						
						print(RED + str((fut,
									cfPrivate.send_order_1(
									dict(default_order_sell,
									**{"size": qty,
									"orderType": "stp",
									"limitPrice":prc_lmt,
									"triggerSignal":"last",
									"reduceOnly":"true",
									"stopPrice":bid_prc})))),ENDC)
 
					if  abs(prc_imb)> 5 if imbalance_qty_buy else prc:
						print(REVERSE + str((fut,
									cfPrivate.send_order_1(
									dict(default_order_buy,
									**{"size": qty,
									"orderType": "post",
									"limitPrice": prc})))),ENDC)  						
	
    
				if order_sell_init or imbalance_qty_sell:
    									
					#! menghitung prc imbalance	
					prc_imb			= hold_avgPrc_buy + ( (1/100)/2 * hold_avgPrc_buy)
					alts_prc		= float(self.truncate((prc_imb),fut)) +TICK	
					prc_imb			=  round(prc_imb,0)+TICK if curr== 'xbt' else  alts_prc
					prc				= 	prc_imb if imbalance_qty_sell else ask_prc	
					
					if imbalance_qty_sell  :
 
						print(GREEN + str((fut,'imbalance_qty_sell ',imbalance_qty_sell,
							'imbalance_qty_buy ',imbalance_qty_buy,'prc_imb',prc_imb,'qty',qty  )),ENDC)
	
					if order_sell_init and imbalance_qty_sell == False:
    
						alts_prc_sell		= float(self.truncate(ask_prc - (TICK*4),fut))
						print(fut,'alts_prc_sell',alts_prc_sell )
						prc_lmt			= (ask_prc  - (TICK*5)) if curr== 'xbt' else  (alts_prc_sell)
						print(GREEN + str((fut,'prc_lmt',prc_lmt,'triggerPrice',ask_prc  )),ENDC)

						print(GREEN + str((fut,
									cfPrivate.send_order_1(dict(default_order_buy,
									**{"size": qty,
									"orderType": "stp",
									"limitPrice":prc_lmt,
									"reduceOnly":"true",
									"triggerSignal":"last",
									"stopPrice":ask_prc})))),ENDC)
	 
					if  abs(prc_imb)> 5 if imbalance_qty_sell else prc :
						print(REVERSE + str((fut,
									cfPrivate.send_order_1(dict(default_order_sell,
									**{"size": qty,
									"orderType": "post",
									"limitPrice":prc})))),ENDC)
					
					print(GREEN + str((fut,'default_order',default_order )),ENDC)
					print(GREEN + str((fut,'order_sell_init',order_sell_init, 'imbalance_qty_sell == False',imbalance_qty_sell == False)),ENDC)

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
	
	print('\n')
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
