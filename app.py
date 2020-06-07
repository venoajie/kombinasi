
import os
from collections import OrderedDict
import sys
import logging
import time
from time import sleep
from datetime import datetime, timedelta
from os.path import getmtime
import argparse,  traceback
import requests
import cfRestApiV3 as cfApi
import  json
import openapi_client

from functools import lru_cache


#c0t8sxtj@futures-demo.com
#wpnjckpwaxacphzm78du

NOW_TIME 					= datetime.now()
START_TIME 					= datetime.now() - timedelta (days = 1, hours =24 )
start_unix 					= time.mktime(START_TIME.timetuple())*1000
stop_unix 					= time.mktime(NOW_TIME.timetuple())*1000

chck_key=str(int(start_unix/1000))[8:9]#memperkenalkan random untuk multi akun
chck_key_list=['3','7','9']


apiPublicKey_gmail1="t7ujWKxYdwoL4fA2I8AoiXtafXaHm7e0hTC1wHj3uFbW7s8JMCt9nxiF"
apiPrivateKey_gmail1="xaXI0pd6DLPJoPHsr6HGRC7dLmAJXJqqkcV6g5MXEBynXvfcScoZd8f7xBaD4Gn4d5J1YAL23m+LiuXP7BdPi0zI"


apiPublicKey_google="flEg0Z9nnziWJuKwi3kjS6LlY5fAUUahrU7c7YFMH2KbzoMW45In9iXh"
apiPrivateKey_google="/dDn2FhD8WMBnoufpieEyk7z+l3UPJphJQFJpRwzeg7xKiHHzFzMGdWou5oXSKUVcVXASlp8P0NesOEBtFuzug/A"

apiPublicKey_gmail="lBTg/GwBoDSyHzIY/8h9BYiXxNq97ZhUKjgscl6Sm/hTRSWcv1sGznec"
apiPrivateKey_gmail="ROR2h15z2WelO4OXH5MrS4c5TeIJXCE6bq+/l0q4l5GF9stHCNVGWzM3wBNjkrzuVKvCJrXaZoRVYhL47mg2eZzg"

accountCF= 'google'if chck_key in chck_key_list  else  'gmail'
print('accountCF',chck_key,accountCF)


#FIXME:
TRAINING                    =  True# False#
endpoint_training           =   "https://conformance.cryptofacilities.com/derivatives"
endpoint_production         =   "https://www.cryptofacilities.com/derivatives"
apiPublicKey_training       =   "PlRnNMw9jpQw1Cnxel99eVqjAp00fCypDdc4zC4godZJa91Y4UXfMHMz"
apiPublicKey_production     =   apiPublicKey_google if accountCF=='google' else apiPublicKey_gmail
apiPrivateKey_training      =   "3k8j0gangNZ/+B0Zxi8WNfpd+6ETXfJf+f/sD3H+K6dolQ5dlw4EtK6VzZxU7LqjktZVgHSdosdT7qxZKcU5sK/Q"
apiPrivateKey_production    =   apiPrivateKey_google if accountCF=='google' else apiPrivateKey_gmail

apiPath 					= 	endpoint_production if TRAINING==False else endpoint_training 
apiPrivateKey 				=	apiPrivateKey_production if TRAINING==False else apiPrivateKey_training
apiPublicKey 				= 	apiPublicKey_production if TRAINING==False else apiPublicKey_training
checkCertificate 			= 	True if TRAINING==False else False 
timeout 					= 	5
useNonce 					= 	False  # nonce is optional

cfPublic 					= 	cfApi.cfApiMethods(apiPath, 
									timeout=timeout, 
									checkCertificate=checkCertificate)

cfPrivate 					= 	cfApi.cfApiMethods(apiPath, 
									timeout=timeout, 
									apiPublicKey=apiPublicKey, 
									apiPrivateKey=apiPrivateKey, 
									checkCertificate=checkCertificate, 
									useNonce=useNonce)

apiPublicKey_training = "ofT125Jz"
apiPrivateKey_training = "Is7P8VMuNCyOGScGFJZpXjd7r-RyevBf9_9N_0o5A4Q"

apiPublicKey_production = "6BcNigZ1ifgkZ"
apiPrivateKey_production = "QU46YNAYWZQFQTV7JATJUO6M3FWUHIE2"


apiPrivateKey 				=	apiPrivateKey_production if TRAINING==False else apiPrivateKey_training
apiPublicKey 				= 	apiPublicKey_production if TRAINING==False else apiPublicKey_training

endpoint_production         =  "https://deribit.com/api/v2/public/auth"
endpoint_training         =  "https://test.deribit.com/api/v2/public/auth"

PARAMS = {'client_id': apiPublicKey_production, 'client_secret': apiPrivateKey_production, 'grant_type': 'client_credentials'}

data = requests.get(url=endpoint_production, params=PARAMS).json()

accesstoken = data['result']['access_token']

configuration = openapi_client.Configuration()
configuration.access_token = accesstoken
api=openapi_client

client_account = api.AccountManagementApi(api.ApiClient(configuration))
client_trading = api.TradingApi(api.ApiClient(configuration))
client_public = api.PublicApi(api.ApiClient(configuration))
client_private = api.PrivateApi(api.ApiClient(configuration))
client_market = api.MarketDataApi(api.ApiClient(configuration))

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
IDLE_TIME   = 600 #nggak jalan?
LOG_LEVEL   = logging.INFO
COUNTER		=3
FREQ		= 8
RED   		= '\033[1;31m'#Sell
BLUE  		= '\033[1;34m'#information
CYAN 	 	= '\033[1;36m'#execution (non-sell/buy)
GREEN 		= '\033[0;32m'#blue
RESET 		= '\033[0;0m'
BOLD    	= "\033[;1m"
REVERSE 	= "\033[;7m"
ENDC 		= '\033[m' # 
time_now    =	int(time.mktime(NOW_TIME.timetuple()))


print(NOW_TIME)
print(BOLD + str(('run')),ENDC)
print('\n')



def get_exchange(contract):
	'''deribit/KF?'''

	exchange 		=  'deribit' if contract[:3] == ('BTC' or 'ETH' ) else 'krakenfut' 

	return exchange


def time_conversion ( waktu ):
	'''Mengonversi waktu format ISO ke UTC'''
	test_waktu 		= isinstance(waktu, int)

	if test_waktu == False:
		konversi	=  0 if waktu == 0 else	time.mktime (
						datetime.strptime(
						waktu,
						'%Y-%m-%dT%H:%M:%S.%fZ').
						timetuple() )

	elif test_waktu == True:
		konversi	=  int( waktu/1000)

	else:
		konversi	=  0
		
    
	return konversi

def time_conversion_net  ( waktu ):
	'''Mengurangi waktu  UTC dengan waktu saat ini'''


	konversi 		=  0 if waktu == 0 else	(time_now) - time_conversion(waktu) 
	print('time_now',time_now,len(str(time_now)))
	print('time_conversion(waktu)',time_conversion(waktu),len(str((time_conversion(waktu)))))
	print('konversi',konversi,len(str(konversi)))

	return konversi


def conversion_to_utc ( waktu ):
	'''Mengonversi waktu format ISO ke UTC'''

	konversi		=  	time.mktime (
						datetime.strptime(
							waktu,
							'%Y-%m-%dT%H:%M:%S.%fZ').timetuple() )

	return konversi

def extract_date_drbt(contract):
	
	year 	=	int((contract)[-2:])
	month=int(datetime.strptime((contract)[6:][:3], "%b").month)

	int_date=year + month
	

	return		int_date 	

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


class MarketMaker(object):

	def __init__(self, monitor=True, output=True):

		self.client = None
		self.logger = None
		self.monitor = monitor
		self.output = output or monitor

	def create_client(self):

		self.client = cfPrivate

	@lru_cache(maxsize=None)
	def filledOrder (self,contract ):
    
		exchange 	=	get_exchange(contract)
    						
		try:
			filledOrder_cf = [ o for o in [o for o in json.loads(cfPrivate.get_fills())[
									'fills'] if o['symbol']==contract   ]] 
		
		except:
			filledOrder_cf 	= 0

		try:
			filledOrder_drbt = client_trading.private_get_order_history_by_instrument_get (
											instrument_name=contract, count=10)['result']#, include_old ='true'
		
		except:
			filledOrder_drbt 	= 0

		
		filledOrder 	=	filledOrder_drbt if exchange == 'deribit' else filledOrder_cf

		return  filledOrder



	@lru_cache(maxsize=None)
	def get_position(self ):
    						
		try:
			get_position = json.loads(cfPrivate.get_openpositions(
							        ))['openPositions']
		
		except:
			get_position 	= 0

		get_position = 0 if get_position == 0 else [ o for o in[o for o in get_position  ]]
		

		return  get_position


	@lru_cache(maxsize=None)
	def get_position_CF(self,contract ):

		exchange 	=	get_exchange(contract)
    						
		try:
			get_position_CF = json.loads(cfPrivate.get_openpositions(
							        ))['openPositions']
		
		except:
			get_position_CF 	= 0

		try:
			get_position_drbt = (client_account.private_get_positions_get(currency=(contract[:3]
				), kind='future')['result'])
		
		except:
			get_position_drbt 	= 0


		get_position_CF = 0 if get_position_CF == 0 else [ o for o in[o for o in get_position_CF if o[
                    'symbol'][3:][:3]==contract [3:][:3]  ]]
		
		get_position_CF 	=	get_position_drbt if exchange == 'deribit' else get_position_CF

		return  get_position_CF

	@lru_cache(maxsize=None)
	def openOrders_CF(self ):
    						
		return  json.loads(cfPrivate.get_openorders())['openOrders'] 



	@lru_cache(maxsize=None)
	def openOrders_drbt(self,  contract ):

		openOrders_fut       = client_trading.private_get_open_orders_by_instrument_get (
											instrument_name=contract)['result']
		return openOrders_fut


	@lru_cache(maxsize=None)
	def openOrders_kf(self,  contract ):
		openOrders_all	=	 self.openOrders_CF()
        
		openOrders_all	= [] if openOrders_all ==[] else openOrders_all
		openOrders_fut       = [] if (openOrders_all ==[] ) else  (
				 							[ o for o in [o for o in openOrders_all if o[
											'symbol']==contract   ]]  ) 										 
		return openOrders_fut


	@lru_cache(maxsize=None)
	def open_orders ( self,  contract ):
  						
  
		exchange 	=	get_exchange(contract)

		[side]			= ['side'] if exchange == 'krakenfut' else ['direction']
		[instrument]	= ['symbol'] if exchange == 'krakenfut' else ['instrument_name']
		[orderType]		=  ['orderType'] if exchange == 'krakenfut' else ['order_type']
		limit    		=('lmt'  if exchange == 'krakenfut' else 'limit' )
		stop    		=('stop' if exchange == 'krakenfut' else 'stop') 	
				

		try:
			openOrders_drbt	=	 self.openOrders_drbt(contract)
		except:
			openOrders_drbt 	=	0


		try:
			openOrders_kf	=	 self.openOrders_kf(contract)
		except:
			openOrders_kf 	=	0

		openOrders_fut 	=	openOrders_drbt if exchange == 'deribit' else openOrders_kf


		try:				
			open				=  [ o for o in[o for o in openOrders_fut  ]]#if o[orderType]== limit

		except:
			open  				=	0

	# cek seluruh open long--> 'buy'
		try:				
			open_buy			= [ o for o in[o for o in open if o[side]== 'buy' ]]

		except:
			open_buy  			=	0

	# cek seluruh open sell--> 'sell'
		try:				
			open_sell			= [ o for o in[o for o in open if o[side] == 'sell' ]]

		except:
			open_sell  			=	0

	# cek seluruh open long--> 'buy'
		try:				
			open_buy_lmt			= [ o for o in[o for o in open_buy if o[orderType]	==limit ]]

		except:
			open_buy_lmt  			=	0

	# cek seluruh open sell--> 'sell'
		try:				
			open_sell_lmt			= [ o for o in[o for o in open_sell if o[orderType]	==limit]]

		except:
			open_sell_lmt  			=	0

	# cek seluruh open long--> 'buy'
		try:				
			open_buy_stp			= [ o for o in[o for o in open_buy if o[orderType]	==stop ]]

		except:
			open_buy_stp 			=	0

	# cek seluruh open sell--> 'sell'
		try:				
			open_sell_stp			= [ o for o in[o for o in open_sell if o[orderType]	==stop ]]

		except:
			open_sell_stp 			=	0

		return { 'openOrders_fut': openOrders_fut, 
				'open_buy': open_buy, 
				'open_sell': open_sell,
				'open_buy_lmt': open_buy_lmt, 
				'open_sell_lmt': open_sell_lmt, 
				'open_buy_stp': open_buy_stp,
				'open_sell_stp': open_sell_stp}

	@lru_cache(maxsize=None)
	def get_tick_CF(self,contract ):
		'''get TICK/instrument'''

		#! bila kontrak deribit (numpang ke CF)
		currency 	=	contract[:3]
		contract	=	'pi_xbtusd' if currency== 'BTC' else contract
		contract	=	'pi_ethusd' if currency== 'ETH' else contract
   						
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
	def book_summary_drbt( self, currency):
		'''get book summary'''
		book_summary  	=	client_market.public_get_book_summary_by_currency_get(
                                        currency, kind='future')['result']
		return book_summary

	@lru_cache(maxsize=None)
	def get_bbo_drbt( self,  contract ):
  		
		currency 	=	contract[:3]
		tickers_drbt=self.book_summary_drbt(currency)
		
		bid_prc_drbt		=  [ o['bid_price'] for o in[o for o in tickers_drbt  if o[
                        'instrument_name']==contract]] [0]
		ask_prc_drbt		=  [ o['ask_price'] for o in[o for o in tickers_drbt  if o[
                        'instrument_name']==contract]] [0]
		
		  		
		return { 'bid_prc_drbt': bid_prc_drbt, 'ask_prc_drbt': ask_prc_drbt}


	@lru_cache(maxsize=None)
	def get_bbo_CF( self,  contract ):
  		
		tickers 	=	self.get_tickers_CF()
		
		bid_prc_KF		=  [ o['bid'] for o in[o for o in tickers  if o['symbol']==contract]] [0]
		ask_prc_KF		=   [ o['ask'] for o in[o for o in tickers  if o['symbol']==contract]] [0]
		
		  		
		return { 'bid_prc_KF': bid_prc_KF, 'ask_prc_KF': ask_prc_KF, 'tickers':tickers}



	@lru_cache(maxsize=None)
	def get_bbo( self,  contract ):
  		
		exchange 	=	get_exchange(contract)
    
		try:
			get_bbo_CF 	=	self.get_bbo_CF(contract)
		except:
			get_bbo_CF 	=	0
		bid_CF 	        =	0 if get_bbo_CF== 0 else get_bbo_CF['bid_prc_KF']
		ask_CF 	         =	0 if get_bbo_CF== 0 else get_bbo_CF['ask_prc_KF']

		try:
			get_bbo_drbt 	=	self.get_bbo_drbt(contract)
		except:
			get_bbo_drbt 	=	0
		  		
		bid_drbt 	=	0 if get_bbo_drbt== 0 else get_bbo_drbt['bid_prc_drbt']
		ask_drbt 	=	0 if get_bbo_drbt== 0 else get_bbo_drbt['ask_prc_drbt']


		bid_prc 	=	bid_drbt if exchange == 'deribit' else bid_CF
		ask_prc 	=	ask_drbt if exchange == 'deribit' else ask_CF

		return { 'bid': bid_prc, 'ask': ask_prc}

	def filter_one_var(self,data,result,filter,member,func ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data if o[filter] == member ]])
			filter 	= func(filter)
		
		except:
			filter 	= []

		filter = 0 if data 	== 0 else filter
		filter = 0 if filter 	== [] else filter
		

		return filter

	def filter_two_var(self,data,result,filter1,member1,filter2,member2 ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data if o[
						filter1] == member1 and  o[filter2] == member2 ]])
		
		except:
			filter 	= []

		return filter

	def filter_no_var(self,data,result,func ):
    
		try:
			filter	=  ([o[result] for o in [o for o in data  ]])
			filter	= func (filter)

		except:
			filter 	= []

		filter = 0 if data 	== 0 else filter
		filter = 0 if filter 	== [] else filter
		
		return filter


	def get_instruments_drbt( self):
		'''get instruments --> currency = BTC or ETH'''
		book_summ_btc  	=	self.book_summary_drbt('BTC')
		futures_btc   	=	sort_by_key({i['instrument_name']: i for i in (book_summ_btc)})
		futures_btc			= list((futures_btc).keys())

		book_summ_eth  	=	self.book_summary_drbt('ETH')
		futures_eth   	=	sort_by_key({i['instrument_name']: i for i in (book_summ_eth)})
		futures_eth			= list((futures_eth).keys())
		non_perp		= [ o for o in[o for o in book_summ_btc if o[
				'instrument_name'][4:] != 'PERPETUAL' ]]
		
		return { 'BTC': futures_btc, 'ETH': futures_eth}


	def get_non_perpetual_drbt( self, currency):
		'''get non-perpetual instruments for deribit'''
		book_summ  	=	self.book_summary_drbt(currency)

		non_perp		= [ o for o in[o for o in book_summ if o[
				'instrument_name'][4:] != 'PERPETUAL' ]]

		non_perp_all		= [ o['instrument_name']  for o in[
				o for o in non_perp     ]]

		int_date=   [extract_date_drbt( o['instrument_name'] ) for o in[
				o for o in non_perp     ]]

		non_perp_min = [ o['instrument_name'] for o in[
				o for o in non_perp if extract_date_drbt(o[
				'instrument_name'])== min(int_date)   ]]
		
		non_perp_max = [ o['instrument_name'] for o in[
				o for o in non_perp if extract_date_drbt(o[
				'instrument_name'])== max(int_date)   ]]
		
		non_perp_med = [ o['instrument_name'] for o in[
				o for o in non_perp if int(extract_date_drbt(o[
				'instrument_name'])) != min(int_date) and  extract_date_drbt(o[
				'instrument_name']) != max(int_date)   ]]

		return {'non_perp_all': non_perp_all, 
				'non_perp_min': non_perp_min, 
				'non_perp_max': non_perp_max, 
				'non_perp_med': non_perp_med}


	def get_non_perpetual_kf (self,currency):
		'''get non-perpetual instruments for kraken futures'''
		tickers 	=	self.get_tickers_CF()

		non_perp =  [ o for o in[
				o for o in tickers if o[
				'symbol'][3:][:3]== currency and len(o[
					'symbol'])<=16 and o['symbol'][:1] == 'f'  ]]

		non_perp_all		= [ o['symbol']  for o in[
				o for o in non_perp     ]]

		non_perp_min = [ o['symbol']  for o in[
				o for o in non_perp  if o[
				'symbol'] == min(non_perp_all)   ]]

		non_perp_max = [ o['symbol']  for o in[
				o for o in non_perp  if o[
				'symbol'] == max(non_perp_all)   ]]

		return {'non_perp_all': non_perp_all, 
				'non_perp_min': non_perp_min, 
				'non_perp_max': non_perp_max}


	@lru_cache(maxsize=None)
	def account_CF(self ):

		account_CF=json.loads(cfPrivate.get_accounts())['accounts']
		return		account_CF 	
		

	@lru_cache(maxsize=None)
	def account_drbt(self,contract ):
    						
		return  (client_account.private_get_account_summary_get(
                                        currency=(contract[:3]), extended='true')['result'])
	def usd_value_kf(self,contract ):
    
		account_CF 	=	self.account_CF( )
		tickers = self.get_tickers_CF ()

		account_CF_xbt=account_CF['fi_xbtusd']  ['balances']   ['xbt']
		account_CF_eth=account_CF ['fi_ethusd']  ['balances'] ['eth']

		mark_prc =[ o['markPrice'] for o in[o for o in tickers  if o['symbol']==contract]] [0]

		balances_xbt=account_CF_xbt *mark_prc
		balances_eth=account_CF_eth *mark_prc

		usd_value=balances_xbt if 	contract [3:][:3] == 'xbt' else balances_eth

		return		usd_value 	

	def usd_value_drbt(self,contract ):
        
		account_drbt 	=	self.account_drbt(contract )
		book_summ_btc  	=	self.book_summary_drbt('BTC')
		mark_prc=book_summ_btc ['mark_price'] 

		account_drbt=[ o['equity'] for o in[o for o in account_drbt  if o['currency']==contract[:3]]] [0]

		usd_value=account_drbt *mark_prc

		return		usd_value 	

	def usd_value (self,contract ):
        
		exchange 	=	get_exchange(contract)
    
		try:
			usd_value_kf 	=	self.usd_value_kf(contract)

		except:
			usd_value_kf 	=	0

		try:
			usd_value_drbt 	=	self.usd_value_drbt(contract)
		except:
			usd_value_drbt 	=	0

		usd_value 	=	usd_value_drbt if exchange == 'deribit' else usd_value_kf

		return		usd_value 	



	def rounding(self,variable,TICK ):
        
    
		rounding			= round(variable / TICK)
		rounding			= round((variable * TICK)-TICK,2)

		return		rounding 	



	def place_orders(self):			


		get_non_perpetual_drbt = self.get_non_perpetual_drbt('BTC')
		get_non_perpetual_kf_xbt = self.get_non_perpetual_kf('xbt')
		get_non_perpetual_kf_eth = self.get_non_perpetual_kf('eth')


		xbt_perp_drbt		= ['BTC-PERPETUAL']
		xbt_perp_kf			= ['pi_xbtusd']
		eth_perp_kf			= ['pi_ethusd']
		xrp_perp_kf			= ['pv_xrpxbt']

		instrmt_sell_drbt_xbt	= (xbt_perp_drbt + get_non_perpetual_drbt['non_perp_min'])
		instrmt_buy_drbt_xbt	= (get_non_perpetual_drbt['non_perp_max'] + get_non_perpetual_drbt['non_perp_med'])
		instrmt_drbt_xbt	= (instrmt_sell_drbt_xbt+ instrmt_buy_drbt_xbt)

		instrmt_sell_kf_xbt	= (xbt_perp_kf )
		instrmt_buy_kf_xbt		= (get_non_perpetual_kf_xbt['non_perp_max'] +  get_non_perpetual_kf_xbt['non_perp_min'] )
		instrmt_kf_xbt	= (instrmt_sell_kf_xbt+ instrmt_buy_kf_xbt)

		instrmt_sell_kf_eth	= (eth_perp_kf )
		instrmt_buy_kf_eth		= (get_non_perpetual_kf_eth['non_perp_max'] +  get_non_perpetual_kf_eth['non_perp_min'] )
		instrmt_kf_eth	= (instrmt_sell_kf_eth+ instrmt_buy_kf_eth)
		print('instrmt_kf_eth',instrmt_kf_eth)

		instrmt_buy	= (instrmt_buy_drbt_xbt + instrmt_buy_kf_xbt + instrmt_buy_kf_eth)
		instrmt_sell	= (instrmt_sell_drbt_xbt + instrmt_sell_kf_xbt + instrmt_sell_kf_eth)


	
		instruments_list_xbt= list( instrmt_drbt_xbt+ instrmt_kf_xbt)
		print('instruments_list_xbt',instruments_list_xbt)

		instruments_list_eth= list(instrmt_kf_eth)
		instruments_list_xrp= 0# list( xrp_perp + [xrp_fut])
#		instruments_list_alts= list( instruments_list_eth + instruments_list_xrp  )
		instruments_list	= list(instruments_list_xbt + instruments_list_eth)
		instruments_list 	= instruments_list_xbt if (TRAINING  ==   True )  else instruments_list

		chck_key=str(int(start_unix/1000))[8:9]#memperkenalkan random untuk multi akun
		chck_key_list=['1','3','5','7','9']
		instruments_list= instruments_list if chck_key in chck_key_list  else  instruments_list[::-1]

		serverTime	= time_conversion(json.loads(cfPrivate.get_tickers())['serverTime'])

#!mendapatkan atribut isi akun deribit vs crypto facilities			
		
		openOrders_CF	=	 self.openOrders_CF()
        
		openOrders_CF	= [] if openOrders_CF ==[] else openOrders_CF
				 		
		for fut in instruments_list:
			
			exchange 	=	get_exchange(fut) 


			ord_book		= self.get_bbo(fut)		

			nbids		=	1
			nasks		=	1
			FREQ 		= 	2 if TRAINING  ==   True  else 10
			FREQ		=	FREQ -	max(nasks,nbids)				
			n			=	10		
			IDLE_TIME 	= 120 if TRAINING  ==   True  else 90
			counter		= serverTime - (stop_unix/1000)
			margin_pct=	one_pct/4

			[instrument]	= ['symbol'] if exchange == 'krakenfut' else ['instrument_name'] 
			[unfilledSize]	= ['unfilledSize'] 	if exchange == 'krakenfut' else ['amount'] 
			[filledSize]	=  ['filledSize']  	if exchange == 'krakenfut' else ['filled_amount'] 
			[size]			=  ['size']  if exchange == 'krakenfut' else ['size'] 
			[side]			= ['side']  if exchange == 'krakenfut' else ['direction'] 
			[price]			= ['price']  if exchange == 'krakenfut' else ['price'] 
			[limitPrice]	= ['limitPrice'] if exchange == 'krakenfut' else ['price'] 
			[stopPrice]		= ['stopPrice'] if exchange == 'krakenfut' else ['stop_price'] 		
			[avgPrc]		= ['price'] if exchange == 'krakenfut' else ['avgPrc'] 
			[fillTime]		=  ['fillTime'] if exchange == 'krakenfut' else ['creation_timestamp'] 
			[last_update_timestamp]=  ['lastUpdateTime']  if exchange == 'krakenfut' else ['last_update_timestamp'] 	
			[orderType]		=  ['orderType'] if exchange == 'krakenfut' else ['order_type']
			[order_id]		=  ['order_id'] if exchange == 'krakenfut' else ['order_id'] 

			buy         	=	('buy' or 'buy')
			sell        	=	('sell' or 'sell') 
			longs         	=	('long' if exchange == 'krakenfut' else 'buy')
			limit    		=('lmt'  if exchange == 'krakenfut' else 'limit' )
			stop    		=('stop' if exchange == 'krakenfut' else 'stop') 	
			short         	=	('short'  if exchange == 'krakenfut' else 'sell')
			curr    		= 	fut [3:][:3] #'xbt'/'xrp')
			TICK			= 	self.get_tick_CF(fut)
			QTY         	= 	10 if accountCF == 'gmail' else 2
			QTY         	=	QTY if curr== 'xbt' else  max(1, int(QTY*1/3))
			usd_value = self.usd_value(fut)
			QTY = max(1,int(usd_value *1/3))
			
			sellable_test   	=	1 if fut in instrmt_sell  else  0 
			buyable_test    	=	1 if fut in instrmt_buy  else  0
			print('fut',fut)
			print('sellable',sellable_test)
			print('buyable',buyable_test)

#! mendapatkan kontrak outstanding --> 

			positions       = self.get_position_CF(fut) 

	# berdasarkan harga

			hold_avgPrc_buy		=	self.filter_two_var (positions,
															avgPrc,
															side,
															longs,
															instrument,
															fut )

			hold_avgPrc_buy		= 	0 if  hold_avgPrc_buy == []   else hold_avgPrc_buy[0]

			hold_avgPrc_sell    =  	self.filter_two_var (positions,
															avgPrc,
															side,
															short,
															instrument,
															fut )	

			hold_avgPrc_sell	= 	0 if  hold_avgPrc_sell == [] else hold_avgPrc_sell[0]

	# berdasarkan qty

			hold_qty_buy		= 	self.filter_two_var (positions,
															size,
															side,longs,
															instrument,fut ) 

			hold_qty_buy		= 	0 if  hold_qty_buy == [] else hold_qty_buy[0]

			hold_qty_sell		= 	self.filter_two_var (positions,
															size,
															side,
															short,
															instrument,
															fut ) 

			hold_qty_sell		= 	0 if  hold_qty_sell == [] else hold_qty_sell[0]


			hold_qty_buy_all		=  []#	([o[size] for o in [o for o in positions if o[side]== longs if o[
#												instrument] != xbt_fut_min and o[
#												instrument] != eth_fut_min	]])

			hold_qty_sell_all		=  []#	([o[size] for o in [o for o in positions if o[side]== short if o[
#												instrument] != xbt_fut_min and o[
#												instrument] != eth_fut_min]])

			hold_qty_buy_all		= 	0 if  hold_qty_buy_all == [] else sum(hold_qty_buy_all)
			hold_qty_sell_all		= 	0 if  hold_qty_sell_all == [] else sum(hold_qty_sell_all)


			print(BOLD + str((accountCF,fut,'positions',positions  )),ENDC)
			print(BOLD + str((fut,'hold_avgPrc_buy',hold_avgPrc_buy,'hold_qty_buy',hold_qty_buy,'hold_qty_buy_all',hold_qty_buy_all  )),ENDC)
			print(BOLD + str((fut,'hold_avgPrc_sell',hold_avgPrc_sell,'hold_qty_sell',hold_qty_sell,'hold_qty_sell_all',hold_qty_sell_all  )),ENDC)

#! mendapatkan atribut RIWAYAT transaksi deribit vs crypto facilities-->FILLED 								
			filledOrder 		=	self.filledOrder(fut)  
			print('filledOrderc',filledOrder)

		# cek waktu transaksi terbaru--> fillTime
			filledOrders_sell_lastTime	=   (self.filter_one_var (filledOrder,
																fillTime,
																side,
																'sell',max                                                                
																))

		# konversi waktu transaksi ke UTC--> time_conversion
			filledOrders_sell_lastTime_conv	= (time_conversion  (filledOrders_sell_lastTime)) 

		# waktu transaksi UTC di-net dg waktu saat ini--> time_conversion_net: now
			filledOrders_sell_lastTime_conv_net	= (time_conversion_net  (filledOrders_sell_lastTime)) 

		# cek waktu transaksi terbaru--> fillTime
			filledOrders_buy_lastTime	=   (self.filter_one_var (filledOrder,
																		fillTime,
																		side,
																		'buy',max
																		))

		# konversi waktu transaksi ke UTC--> time_conversion
			filledOrders_buy_lastTime_conv	= (time_conversion  ((filledOrders_buy_lastTime)))

		# waktu transaksi UTC di-net dg waktu saat ini--> time_conversion_net: now
			filledOrders_buy_lastTime_conv_net	=(time_conversion_net  ((filledOrders_buy_lastTime)) )


#			print(fut,'filledOrders_prc_sell',filledOrders_prc_sell,'filledOrders_prc_buy',filledOrders_prc_buy)
#			print(fut,'filledOrder',filledOrder)
#			sleep(10)

	# cek harga transaksi--> price 'sell'
			filledOrders_qty_sell	=   self.filter_one_var (filledOrder,
															size,
															fillTime,
															filledOrders_sell_lastTime,max
															) 


	# cek harga transaksi--> price 'buy'
			filledOrders_qty_buy	=   self.filter_one_var (filledOrder,
															size,
															fillTime,
															filledOrders_buy_lastTime,max
															)

#! mendapatkan atribut OPEN ORDER/transaksi belum tereksekusi --> openOrders										  		
	# cek seluruh open 
			open_orders= self.open_orders(fut)

	# cek seluruh open long--> 'buy'
			open_buy= open_orders ['open_buy']

	# cek seluruh open sell--> 'sell'
			open_sell= open_orders ['open_sell']

	# cek seluruh open long--> 'buy'
			open_buy_lmt= open_orders ['open_buy_lmt']

	# cek seluruh open sell--> 'sell'
			open_sell_lmt= open_orders ['open_sell_lmt']

	# cek seluruh open long--> 'buy'
			open_buy_stp= open_orders ['open_buy_stp']

	# cek seluruh open sell--> 'sell'
			open_sell_stp= open_orders ['open_sell_stp']

		# cek kuantitas JUMLAH order beli  disubmit								 
			openOrders_qty_buy_sum		= self.filter_no_var (open_buy,unfilledSize,sum)

		# cek kuantitas JUMLAH order jual disubmit								 
			openOrders_qty_sell_sum		=self.filter_no_var (open_sell,unfilledSize,sum)

		# cek kuantitas order belum terkesekusi di order book--> unfilledSize : max 10 per instrumen di CF								 
			openOrders_qty_buy_Len	=  self.filter_no_var (open_buy,unfilledSize,len)


			openOrders_qty_buy_Len_lmt	=  self.filter_no_var (open_buy_lmt,unfilledSize,len)


		# cek kuantitas order belum terkesekusi di order book--> unfilledSize : max 10 per instrumen di CF								 
			openOrders_qty_sell_Len=self.filter_no_var (open_sell,unfilledSize,len)

			openOrders_qty_sell_Len_lmt= self.filter_no_var (open_sell_lmt,unfilledSize,len)

		# cek waktu order beli disubmit--> last_update_timestamp										 
			openOrders_time_buy	    =	sorted ([ o['receivedTime'] for o in [o for o in open_buy]])
			openOrders_time_buy_lmt	    =	sorted ([ o['receivedTime'] for o in [o for o in open_buy_lmt]])
			openOrders_time_buy_stp	    =	sorted ([ o['receivedTime'] for o in [o for o in open_buy_stp]])

		# cek waktu order beli TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_time_buy_min = 0 if openOrders_time_buy == [] else min (openOrders_time_buy)

		# cek waktu order beli TERBARU disubmit--> last_update_timestamp	max									 

			openOrders_time_buy_max = 0 if openOrders_time_buy ==  [] else max (openOrders_time_buy)
			openOrders_time_buy_lmt_max = 0 if openOrders_time_buy_lmt ==  [] else max (openOrders_time_buy_lmt)
			openOrders_time_buy_stp_max = 0 if openOrders_time_buy_stp ==  [] else max (openOrders_time_buy_stp)
			openOrders_time_buy_max1=  0 if openOrders_qty_buy_Len_lmt < 2 else  openOrders_time_buy_lmt[0]
			openOrders_time_buy_max2=  0 if openOrders_qty_buy_Len_lmt < 2 else openOrders_time_buy_lmt[1]

		# konversi waktu transaksi ke UTC--> time_conversion
			openOrders_time_buy_lmt_max_conv 	=( time_conversion  ( openOrders_time_buy_lmt_max) )

			openOrders_time_buy_stp_max_conv 	= ( time_conversion  ( openOrders_time_buy_stp_max) )

			openOrders_time_buy_lmt_max1_conv 	= ( time_conversion  ( openOrders_time_buy_max1) )

			openOrders_time_buy_lmt_max2_conv 	=( time_conversion  ( openOrders_time_buy_max2) )




		# waktu transaksi UTC di-net dg waktu saat ini--> time_conversion_net: now
			openOrders_time_buy_lmt_max_conv_net 	=  ( time_conversion_net  ( openOrders_time_buy_lmt_max) )

			openOrders_time_buy_stp_max_conv_net 	= ( time_conversion_net  ( openOrders_time_buy_stp_max) )




		# cek waktu order jual disubmit--> last_update_timestamp	

			openOrders_time_sell	= sorted ([ o['receivedTime'] for o in [o for o in open_sell]])
			openOrders_time_sell_lmt	= sorted ([ o['receivedTime'] for o in [o for o in open_sell_lmt]])
			openOrders_time_sell_stp	= sorted ([ o['receivedTime'] for o in [o for o in open_sell_stp]])

		# cek waktu order jual TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_time_sell_min 	= 0 if openOrders_time_sell == [] else min (openOrders_time_sell)

		# cek waktu order jual TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_time_sell_max 	= 0 if openOrders_time_sell == [] else max (openOrders_time_sell)
			openOrders_time_sell_lmt_max 	= 0 if openOrders_time_sell_lmt ==[] else max (openOrders_time_sell_lmt)
			openOrders_time_sell_stp_max 	= 0 if openOrders_time_sell_stp == [] else max (openOrders_time_sell_stp)
			openOrders_time_sell_max1=  (0 if openOrders_qty_sell_Len_lmt <= 2 else  openOrders_time_sell_lmt[0])
			openOrders_time_sell_max2= 0 if openOrders_qty_sell_Len_lmt <= 2 else openOrders_time_sell_lmt[1]

		# konversi waktu order disubmit ke UTC--> time_conversion
			openOrders_time_sell_lmt_max_conv 	=  (time_conversion ( openOrders_time_sell_lmt_max) )


			openOrders_time_sell_lmt_max1_conv 	=  (time_conversion ( openOrders_time_sell_max1) )
			openOrders_time_sell_lmt_max2_conv 	=   (time_conversion ( openOrders_time_sell_max2) )

			openOrders_time_sell_stp_max_conv 	=  (time_conversion ( openOrders_time_sell_stp_max) )
		# waktu order UTC di-net dg waktu saat ini--> time_conversion_net: now
			openOrders_time_sell_lmt_max_conv_net 	=  (time_conversion_net ( openOrders_time_sell_lmt_max) )

			openOrders_time_sell_stp_max_conv_net 	= (time_conversion_net ( openOrders_time_sell_stp_max) )



#! openOrders_time_sell_lmt_max_conv_net 	= 
		# cek harga order beli TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_prc_buy_min			= self.filter_one_var (open_buy,
															[limitPrice],
															['receivedTime'],
															openOrders_time_buy_min,min
															)

		# cek harga order beli min--> limitPrice	min				
			openOrders_prc_buy_LmtMinPrc  			=	 self.filter_no_var (open_buy_lmt,limitPrice,min)
			openOrders_prc_buy_LmtMaxPrc  			=	 self.filter_no_var (open_buy_lmt,limitPrice,max)

			
		# cek harga order jual min--> limitPrice	min									 
			openOrders_prc_sell_LmtMinPrc  			=	 self.filter_no_var (open_sell_lmt,limitPrice,min)
			openOrders_prc_sell_LmtMaxPrc  			=	 self.filter_no_var (open_sell_lmt,limitPrice,max)


#! DELTA TIME: menghitung waktu filled/OS:								


			delta_time_buy				= max (filledOrders_buy_lastTime_conv_net,openOrders_time_buy_lmt_max_conv_net )  if (
											filledOrders_buy_lastTime_conv_net == 0 or openOrders_time_buy_lmt_max_conv_net  ==0) else min (
											filledOrders_buy_lastTime_conv_net, openOrders_time_buy_lmt_max_conv_net )

			delta_time_sell				= max (filledOrders_sell_lastTime_conv_net,openOrders_time_sell_lmt_max_conv_net ) if (
											filledOrders_sell_lastTime_conv_net ==0 or openOrders_time_sell_lmt_max_conv_net ==0) else min (
											filledOrders_sell_lastTime_conv_net, openOrders_time_sell_lmt_max_conv_net )


#! *************************************************************************************************************************************

	# cek harga order beli TERBARU disubmit--> last_update_timestamp	max									 

			openOrders_prc_buy_max			= self.filter_no_var (open_buy_lmt,limitPrice,max)
  

			openOrders_qty_buy_prcMax			= self.filter_one_var (open_buy,
															unfilledSize,
															limitPrice,
															openOrders_prc_buy_max,max
															)


			openOrders_oid_buy_prcMax			= self.filter_one_var (open_buy,
															order_id,
															limitPrice,
															openOrders_prc_buy_max,max
															)
                                                            
			openOrders_prc_buy_min			= self.filter_no_var (open_buy_lmt,limitPrice,min)
 

			openOrders_qty_buy_prcMin			= self.filter_one_var (open_buy,
															unfilledSize,
															limitPrice,
															openOrders_prc_buy_min,min
															)

			openOrders_oid_buy_prcMin			= self.filter_one_var (open_buy,
															order_id,
															limitPrice,
															openOrders_prc_buy_min,max
															)
    
			openOrders_time_buy_prcMin			= self.filter_one_var (open_buy_lmt,
															['receivedTime'],
															limitPrice,
															openOrders_prc_buy_min,min
															)

			openOrders_time_buy_prcMin_conv_net 	=  (time_conversion_net ( openOrders_time_buy_prcMin) )

		# cek harga order jual TERLAMA disubmit--> last_update_timestamp	min									 
			openOrders_prc_sell_min			= self.filter_no_var (open_sell_lmt,limitPrice,min)
 
		# cek harga order jual TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_prc_sell_max			= self.filter_no_var (open_sell_lmt,limitPrice,max)
 
			openOrders_qty_sell_prcMax			= self.filter_one_var (open_sell_lmt,
															unfilledSize,
															limitPrice,
															openOrders_prc_sell_max,max
															)

			openOrders_oid_sell_prcMax			= self.filter_one_var (open_sell_lmt,
															[order_id],
															limitPrice,
															openOrders_prc_sell_max,max
															)

			openOrders_time_sell_prcMax			= self.filter_one_var (open_sell_lmt,
															['receivedTime'],
															limitPrice,
															openOrders_prc_sell_max,max
															)

			openOrders_time_sell_prcMax_conv_net 	= (time_conversion_net ( openOrders_time_sell_prcMax) )

			print(fut,'openOrders_time_sell_prcMax',openOrders_time_sell_prcMax,'openOrders_time_sell_prcMax_conv_net',openOrders_time_sell_prcMax_conv_net)

			print(fut,'openOrders_prc_sell_min',openOrders_prc_sell_min,'openOrders_prc_sell_max',openOrders_prc_sell_max,
			'openOrders_qty_sell_prcMax',openOrders_qty_sell_prcMax,'openOrders_oid_sell_prcMax',openOrders_oid_sell_prcMax)


			prc_min_max = openOrders_prc_sell_max - openOrders_prc_buy_min
			prc_min_max_pct = 0 if openOrders_prc_sell_max == 0 else prc_min_max/openOrders_prc_sell_max
			qty_min_max = abs(openOrders_qty_sell_prcMax - openOrders_qty_buy_prcMin)
			cancel_qty_min = min(openOrders_qty_sell_prcMax,openOrders_qty_buy_prcMin) 
			edit_qty_max = max(openOrders_qty_sell_prcMax,openOrders_qty_buy_prcMin)
			editable= edit_qty_max    >  QTY * 5 and cancel_qty_min > QTY *2



			openOrders_oid_sell_cancel= self.filter_one_var (open_sell_lmt,
															[order_id],
															[unfilledSize],
															cancel_qty_min,max
															)
 
			openOrders_oid_buy_cancel= self.filter_one_var (open_buy_lmt,
															[order_id],
															[unfilledSize],
															cancel_qty_min,min
															)
        
			openOrders_oid_sell_edit= self.filter_one_var (open_sell_lmt,
															[order_id],
															[unfilledSize],
															edit_qty_max,max
															)
                

			openOrders_oid_buy_edit= self.filter_one_var (open_buy_lmt,
															[order_id],
															[unfilledSize],
															edit_qty_max,max
															)

			print(fut,'cancel_qty_min',cancel_qty_min,'edit_qty_max',edit_qty_max)
#			print(fut,'openOrders_oid_sell_cancel',openOrders_oid_sell_cancel,'openOrders_oid_buy_cancel',openOrders_oid_buy_cancel)
#			print(fut,'openOrders_oid_sell_edit',openOrders_oid_sell_edit,'openOrders_oid_buy_edit',openOrders_oid_buy_edit)
	



#! ****************************************************************************************************			
#! UNTUK DIHAPUS			
			print(fut, 'UNTUK DIHAPUS')
			print('filledOrder',filledOrder)
			print('filledOrders_sell_lastTime',filledOrders_sell_lastTime)
			print('filledOrders_sell_lastTime_conv',filledOrders_sell_lastTime_conv)
			print('filledOrders_sell_lastTime_conv_net',filledOrders_sell_lastTime_conv_net)

			print('filledOrders_buy_lastTime',filledOrders_buy_lastTime)
			print('filledOrders_buy_lastTime_conv',filledOrders_buy_lastTime_conv)
			print('filledOrders_buy_lastTime_conv_net',filledOrders_buy_lastTime_conv_net)



			print('openOrders_qty_buy_sum',openOrders_qty_buy_sum)
			print('openOrders_qty_sell_sum',openOrders_qty_sell_sum)
			print('openOrders_qty_buy_Len',openOrders_qty_buy_Len)
			print('openOrders_qty_buy_Len_lmt',openOrders_qty_buy_Len_lmt)
			print('openOrders_qty_sell_Len',openOrders_qty_sell_Len)
			print('openOrders_qty_sell_Len_lmt',openOrders_qty_sell_Len_lmt)

			print('openOrders_time_buy_lmt_max_conv',openOrders_time_buy_lmt_max_conv)
			print('openOrders_time_buy_stp_max_conv',openOrders_time_buy_stp_max_conv)
			print('openOrders_time_buy_lmt_max1_conv',openOrders_time_buy_lmt_max1_conv)
			print('openOrders_time_buy_lmt_max2_conv',openOrders_time_buy_lmt_max2_conv)

			print('openOrders_time_buy_lmt_max_conv_net',openOrders_time_buy_lmt_max_conv_net)
			print('openOrders_time_buy_stp_max_conv_net',openOrders_time_buy_stp_max_conv_net)


			print('openOrders_time_sell_lmt_max_conv',openOrders_time_sell_lmt_max_conv)
			print('openOrders_time_sell_lmt_max1_conv',openOrders_time_sell_lmt_max1_conv)
			print('openOrders_time_sell_lmt_max2_conv',openOrders_time_sell_lmt_max2_conv)
			print('openOrders_time_sell_stp_max_conv',openOrders_time_sell_stp_max_conv)
			print('openOrders_time_sell_lmt_max_conv_net',openOrders_time_sell_lmt_max_conv_net)
			print('openOrders_time_sell_stp_max_conv_net',openOrders_time_sell_stp_max_conv_net)


			print('openOrders_prc_buy_min',openOrders_prc_buy_min)
			print('openOrders_prc_buy_LmtMinPrc',openOrders_prc_buy_LmtMinPrc)
			print('openOrders_prc_buy_LmtMaxPrc',openOrders_prc_buy_LmtMaxPrc)
			print('openOrders_prc_sell_LmtMinPrc',openOrders_prc_sell_LmtMinPrc)
			print('openOrders_prc_sell_LmtMaxPrc',openOrders_prc_sell_LmtMaxPrc)

			print('openOrders_oid_sell_cancel',openOrders_oid_sell_cancel)
			print('openOrders_oid_buy_cancel',openOrders_oid_buy_cancel)
			print('openOrders_oid_sell_edit',openOrders_oid_sell_edit)
			print('openOrders_oid_buy_edit',openOrders_oid_buy_edit)
			print(fut, 'UNTUK DIHAPUS')

#! ****************************************************************************************************			



#! *************************************************************************************************************************************
			if openOrders_qty_sell_Len <=1 and openOrders_prc_sell_LmtMinPrc !=0:
				openOrders_oid_sell_lmtMinPrc= 0 if openOrders_prc_sell_LmtMinPrc== 0 else ([ o[order_id] for o in [
											o for o in open_sell  ]])[0]	

			else:
				openOrders_oid_sell_lmtMinPrc= 0 if openOrders_prc_sell_LmtMinPrc== 0 else ([ o[order_id] for o in [
											o for o in open_sell if o[limitPrice]== openOrders_prc_sell_LmtMinPrc  ]])[0]	

			if openOrders_qty_buy_Len <=1 and openOrders_prc_buy_LmtMinPrc !=0:
    
				openOrders_oid_buy_lmtMinPrc= 0 if openOrders_prc_buy_LmtMinPrc== 0 else ([ o[order_id] for o in [
					o for o in open_buy   ]])[0]

			else:
        
				openOrders_oid_buy_lmtMinPrc= 0 if openOrders_prc_buy_LmtMinPrc== 0 else ([ o[order_id] for o in [
					o for o in open_buy if o[limitPrice]== openOrders_prc_buy_LmtMinPrc  ]])[0]


		# cek kuantitas order beli TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_qty_buy_max		= self.filter_one_var (open_buy,
															[unfilledSize],
															['receivedTime'],
															openOrders_time_buy_max,max
															)

		# cek kuantitas order jual TERBARU disubmit--> last_update_timestamp	max									 
			openOrders_qty_sell_max		= self.filter_one_var (open_buy,
															[unfilledSize],
															['receivedTime'],
															openOrders_time_sell_max,max
															)
                                                            
			print(fut,'openOrders_time_sell_max',openOrders_time_sell_max)

			openOrders_oid_buy_max1		= 0
			
			openOrders_oid_buy_max2		= 0

#!#####  

			openOrders_oid_buy_max2=  0 if openOrders_time_buy_max2== 0 else ([ o[order_id] for o in [
					o for o in open_buy_lmt  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

			openOrders_oid_buy_max1=  0 if openOrders_time_buy_max1== 0 else ([ o[order_id] for o in [
					o for o in open_buy_lmt  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]
#!!!!!!
			openOrders_qty_buy_max2=  0 if openOrders_time_buy_max2== 0 else ([ o[unfilledSize] for o in [
					o for o in open_buy_lmt  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

			openOrders_qty_buy_max1=  0 if openOrders_time_buy_max1== 0 else ([ o[unfilledSize] for o in [
					o for o in open_buy_lmt  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]

			openOrders_prc_buy_max2= 0 if openOrders_time_buy_max2== 0 else ([ o[limitPrice] for o in [
					o for o in open_buy_lmt  if o['receivedTime']== openOrders_time_buy_max2 ]])[0]

			openOrders_prc_buy_max1= 0 if openOrders_time_buy_max1 == 0 else ([ o[limitPrice] for o in [
					o for o in open_buy_lmt  if o['receivedTime']== openOrders_time_buy_max1 ]])[0]

			openOrders_oid_sell_max2= 0 if openOrders_time_sell_max2== 0 else ([ o[order_id] for o in [
					o for o in open_sell_lmt  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]

			openOrders_oid_sell_max1=  0 if openOrders_time_sell_max1== 0  else ([ o[order_id] for o in [
					o for o in open_sell_lmt  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

			openOrders_qty_sell_max1=  0 if openOrders_time_sell_max1== 0 else ([ o[unfilledSize] for o in [
					o for o in open_sell_lmt  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

			openOrders_qty_sell_max2=  0 if openOrders_time_sell_max2== 0 else ([ o[unfilledSize] for o in [
					o for o in open_sell_lmt  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]    

			openOrders_prc_sell_max1= 0 if openOrders_time_sell_max1== 0 else ([ o[limitPrice] for o in [
					o for o in open_sell_lmt  if o['receivedTime']== openOrders_time_sell_max1 ]])[0]

			openOrders_prc_sell_max2= 0 if openOrders_time_sell_max2== 0 else ([ o[limitPrice] for o in [
					o for o in open_sell_lmt  if o['receivedTime']== openOrders_time_sell_max2 ]])[0]    

#! *********************************
	# cek seluruh open sell--> 'sell'

			openOrders_oid_buy_lmt= 0 if open_buy_lmt== []  else ([ o[order_id] for o in [
					o for o in open_buy_lmt if o['receivedTime']== openOrders_time_buy_lmt_max ]])[0]

			openOrders_oid_sell_lmt= 0 if open_sell_lmt == [] else ([ o[order_id] for o in [
					o for o in open_sell_lmt if o['receivedTime']== openOrders_time_sell_lmt_max ]])[0]	

			openOrders_oid_buy_stp= 0 if open_buy_stp== []  else ([ o[order_id] for o in [
					o for o in open_buy_stp if o['receivedTime']== openOrders_time_buy_stp_max]])[0]


			openOrders_prcStp_buy_stp= 0 if open_buy_stp== []  else ([ o['stopPrice'] for o in [
					o for o in open_buy_stp if o['receivedTime']== openOrders_time_buy_stp_max]])[0]

			openOrders_prcStp_sell_stp= 0 if open_sell_stp== []  else ([ o['stopPrice'] for o in [
					o for o in open_sell_stp if o['receivedTime']== openOrders_time_sell_stp_max]])[0]

			openOrders_prc_buy_stp= 0 if open_buy_stp== []  else ([ o[limitPrice] for o in [
					o for o in open_buy_stp if o['receivedTime']== openOrders_time_buy_stp_max]])[0]

			openOrders_prc_sell_stp= 0 if open_sell_stp== []  else ([ o[limitPrice] for o in [
					o for o in open_sell_stp if o['receivedTime']== openOrders_time_sell_stp_max]])[0]

			openOrders_oid_sell_stp= 0 if open_sell_stp== [] else ([ o[order_id] for o in [
					o for o in open_sell_stp if o['receivedTime']== openOrders_time_sell_stp_max  ]])[0]

			openOrders_oid_buy_stp_len= 0 if openOrders_oid_buy_stp== 0  else len([ o[order_id] for o in [
					o for o in open_buy_stp if o['receivedTime']== openOrders_time_buy_stp_max ]])

			openOrders_oid_sell_stp_len= 0 if openOrders_oid_sell_stp == 0 else len([ o[order_id] for o in [
					o for o in open_sell_stp if o['receivedTime']== openOrders_time_sell_stp_max  ]])

#? URUTAN KERJA
	#? CEK APAKAH SALDO SUDAH SEIMBANG, POSISI/OPEN BUY - SELL = 0?
		#? BILA 0, DEFAULT
		#? BILA YA, CEK WAKTU APAKAH SUDAH SAATNYA ORDER KEMBALI
		#? ORDER KEMBALI:
			#? CEK POSISI DULU, + -> (-), VV
		#? BILA BELUM
			#? BATALKAN SEMUA STOP ORDER DAN PASANGANNYA DULU #FIXME: DONE
			#? EKSEKUSI PARSIAL?
			#? BUAT LAWAN DENGAN MARGIN, QTY MENGIKUIT
	#? CEK APAKAH SALDO SUDAH SEIMBANG, POSISI/OPEN BUY - SELL = 0?

			hold_qty 				 =	 hold_qty_buy - abs(hold_qty_sell) #! kalau 0 bagaimana?
			qty_open_net				=	openOrders_qty_buy_sum - openOrders_qty_sell_sum
			
			#! bila hanya ada satu stop/limit order
				#! len: hanya ada 1 order tersisa
				#! hold: secara net open vs hold, tidak nol (harusnya nol/ada pasangannya)
				#! open: secara net open, mmg hanya tersisa 1
			imbalance_qty_buy			= hold_qty_buy +  openOrders_qty_buy_sum - openOrders_qty_sell_sum  - hold_qty_sell
			imbalance_qty_sell 			= hold_qty_sell +  openOrders_qty_sell_sum - openOrders_qty_buy_sum  - hold_qty_buy

			print(BOLD + str(('open_buy',open_buy  )),ENDC)
			print(BOLD + str(('open_sell',open_sell  )),ENDC)
			print(fut,'open_buy_stp',open_buy_stp)
			print(fut,'open_sell_stp',open_sell_stp)

			print(fut,'qty_open_net',qty_open_net)
			print(fut,'openOrders_qty_buy_sum',openOrders_qty_buy_sum,'openOrders_qty_sell_sum',openOrders_qty_sell_sum)
			print(fut,'imbalance_qty_buy',imbalance_qty_buy,'imbalance_qty_sell',imbalance_qty_sell)

			#! balance_hold...memastika selisih semata dari open 
			imbalance_open				= qty_open_net != 0 and (imbalance_qty_sell  ==0 and imbalance_qty_buy ==0)
			imbalance_open_one			= qty_open_net != 0 and (hold_qty_buy  ==0 and hold_qty_sell ==0)

			#! hold_qty_...konfirmasi kalau selisih mmg disebabkan oleh saldo tanpa lawan, bkn karena saldo hold ada di lawan (makanya 0) 
			imbalance_sell_one	=   imbalance_qty_sell  > 0 and hold_qty_buy == 0 
  
			imbalance_buy_one	= imbalance_qty_buy > 0  and hold_qty_sell ==0  

			print(fut,'imbalance_sell_one',imbalance_sell_one,'imbalance_qty_sell  > 0 ',imbalance_qty_sell  > 0,'hold_qty_sell ==0',hold_qty_sell ==0,
			'imbalance_buy_one',imbalance_buy_one,'imbalance_qty_buy > 0',imbalance_qty_buy > 0,'hold_qty_buy',hold_qty_buy)
			print(fut,'delta_time_sell',delta_time_sell,'delta_time_buy',delta_time_buy)

			cancel_imbalance_sell_one	=  imbalance_sell_one and (openOrders_oid_sell_stp != 0 or openOrders_oid_sell_lmt != 0) 

			cancel_imbalance_buy_one	= imbalance_buy_one and (openOrders_oid_buy_stp != 0 or openOrders_oid_buy_lmt != 0 ) 

			print(fut,'cancel_imbalance_sell_one',cancel_imbalance_sell_one,'cancel_imbalance_buy_one',cancel_imbalance_buy_one)

			imbalance_sell_two	=   imbalance_qty_buy > 0 and openOrders_qty_sell_Len > 1 
			imbalance_buy_two	=  imbalance_qty_sell  > 0  and openOrders_qty_buy_Len > 1  
			
			cancel_imbalance_sell_two	=  imbalance_sell_two and  (openOrders_oid_sell_stp != 0 or openOrders_oid_sell_lmt != 0) 
			cancel_imbalance_buy_two	= imbalance_buy_two and (openOrders_oid_buy_stp != 0 or openOrders_oid_buy_lmt != 0 ) 

		#? BILA BELUM
			#? BATALKAN SEMUA STOP ORDER DAN PASANGANNYA DULU

			cancel_all					= (imbalance_qty_buy > 0 or imbalance_qty_sell  > 0) and min(
											openOrders_oid_buy_stp_len,openOrders_oid_sell_stp_len)>0

			#! tidak berlaku kalau ada eksekusi partial
			cancel_imbalance_sell		=  imbalance_qty_buy > 0 and openOrders_qty_sell_sum > hold_qty_sell and abs(hold_qty_buy-abs(qty_open_net)) == QTY 
			cancel_imbalance_buy		=  imbalance_qty_sell  > 0 and openOrders_qty_buy_sum > hold_qty_buy and  abs(hold_qty_sell- abs(qty_open_net)) == QTY

			cancel_imbalance_buy_match 	=  imbalance_sell_one and (
											openOrders_oid_buy_stp != 0 or openOrders_oid_buy_lmt != 0 ) and delta_time_buy > IDLE_TIME * 10

			cancel_imbalance_sell_match	= imbalance_buy_one and  (
											openOrders_oid_sell_stp != 0 or openOrders_oid_sell_lmt != 0)  and delta_time_sell >  IDLE_TIME * 10


#! CANCEL ORDER 

# tes waktu yang sama

			# memastikan yang kan dicancel adalah psangan stop limit yang diorder bersamaan
			time_delta_sell		= abs(openOrders_time_sell_lmt_max_conv  - openOrders_time_buy_stp_max_conv )
			time_delta_buy	= abs(openOrders_time_buy_lmt_max_conv  - openOrders_time_sell_stp_max_conv )

			matched_buy = (openOrders_oid_buy_stp !=0 and openOrders_oid_sell_lmt !=0)  and (time_delta_sell <= 2)
			matched_sell = (openOrders_oid_sell_stp != 0 and openOrders_oid_buy_lmt != 0 ) and (time_delta_buy <= 2)
			
			print(CYAN + str((fut,'CANCEL DOBEL ORDER'  )),ENDC)
			print(CYAN + str((fut,'time_delta_sell',time_delta_sell,'time_delta_buy',time_delta_buy  )),ENDC)
			print(CYAN + str((fut,'matched_buy',matched_buy,'matched_sell',matched_sell  )),ENDC)

#? *****************************************************************************************************************************************************

#CANCEL ORDER DOBEL
# order dobel dicirikan dengan order di waktu dan harga yang sama

			# menghitung selisih waktu limit dengan stop (harusnya kurang dari 1 detik)
			cancel_double_buy= 	abs(openOrders_time_buy_lmt_max2_conv - openOrders_time_buy_lmt_max1_conv) < 3 and (
								openOrders_time_buy_lmt_max2_conv !=0 and openOrders_time_buy_lmt_max1_conv !=0
								)
			
			cancel_double_sell= abs(openOrders_time_sell_lmt_max2_conv - openOrders_time_sell_lmt_max1_conv) < 3 and (
								openOrders_time_sell_lmt_max2_conv !=0 and openOrders_time_sell_lmt_max1_conv !=0
								)

	#		print(CYAN + str((fut,'cancel_double_buy',cancel_double_buy,'cancel_double_sell',cancel_double_sell  )),ENDC)
	#		print(CYAN + str((fut,'openOrders_time_buy_lmt_max2_conv',openOrders_time_buy_lmt_max2_conv,'openOrders_time_buy_lmt_max2_conv',openOrders_time_buy_lmt_max1_conv  )),ENDC)
	#		print(CYAN + str((fut,'openOrders_time_sell_lmt_max2_conv',openOrders_time_sell_lmt_max2_conv,'openOrders_time_sell_lmt_max1_conv',openOrders_time_sell_lmt_max1_conv  )),ENDC)

#			if cancel_double_buy  and matched_buy: 													

#					print(BLUE + str((fut,'PPP',cfPrivate.cancel_order(
#						openOrders_oid_buy_stp) )),ENDC)

#					print(BLUE + str((fut,'QQQ',cfPrivate.cancel_order(
#						openOrders_oid_sell_lmt) )),ENDC)
#					self.restart_program()

#			if cancel_double_sell and matched_sell :                                                   
	
#					print(BLUE + str((fut,'RRR',cfPrivate.cancel_order(
#						openOrders_oid_sell_stp) )),ENDC)
	
#					print (BLUE + str((fut,'SSS',cfPrivate.cancel_order(
#						openOrders_oid_buy_lmt) )),ENDC)
#					self.restart_program()


#? *****************************************************************************************************************************************************

#! CANCEL ORDER EXPIRED
# expired karena waktu/kuantitas. order book sudah jauh meninggalkan order dan dicancel agar bisa membuat yang baru


# tes waktu order outstanding

			# memastikan yang kan dicancel adalah psangan stop limit yang diorder bersamaan

			time_cancel_buy		=	openOrders_time_buy_stp_max_conv_net  > IDLE_TIME-20
			time_cancel_sell	=	openOrders_time_sell_stp_max_conv_net > IDLE_TIME-20
			qty_cancel_buy = (openOrders_qty_buy_max == QTY and openOrders_qty_sell_max ==QTY)
			qty_cancel_sell =(openOrders_qty_buy_max == QTY and openOrders_qty_sell_max ==QTY)

			print(CYAN + str((fut,'CANCEL ORDER EXPIRED'  )),ENDC)
			print(fut,'QTY',QTY,'time_cancel_buy',time_cancel_buy,'openOrders_qty_sell_max',
					openOrders_qty_sell_max,'openOrders_qty_buy_max',openOrders_qty_buy_max)
			
			print(fut,'qty_cancel_sell',qty_cancel_sell,'qty_cancel_buy',qty_cancel_buy,
			'openOrders_time_sell_stp_max_conv_net',openOrders_time_sell_stp_max_conv_net)
			
			if  ((time_cancel_buy  and qty_cancel_buy) )  and matched_buy: 													

					print(BLUE + str((fut,'AAA',cfPrivate.cancel_order(
						openOrders_oid_buy_stp) )),ENDC)

					print(BLUE + str((fut,'BBB',cfPrivate.cancel_order(
						openOrders_oid_sell_lmt) )),ENDC)
					self.restart_program()

			if  ((time_cancel_sell and qty_cancel_sell) ) and matched_sell :                                                   
	
					print(BLUE + str((fut,'CCC',cfPrivate.cancel_order(
						openOrders_oid_sell_stp) )),ENDC)
	
					print (BLUE + str((fut,'DDD',cfPrivate.cancel_order(
						openOrders_oid_buy_lmt) )),ENDC)
					self.restart_program()


#? *****************************************************************************************************************************************************

#! CANCEL EDIT KARENA MELEBIHI BATASAN ORDER YANG DIIZINKAN (MAKS 10 per instrumen)


			cancel_test					=  (abs(openOrders_qty_sell_Len) + openOrders_qty_buy_Len) >= (FREQ )  and  QTY < 100

			cancel_sell					=  (abs(openOrders_qty_sell_Len) >= (FREQ ) or (cancel_test and max (
											openOrders_qty_buy_Len,abs(
											openOrders_qty_sell_Len))== abs(openOrders_qty_sell_Len))) and (
											len(openOrders_time_sell_lmt) >1 and openOrders_time_sell_max !=0) and QTY < 100
			
			cancel_buy  				=  (openOrders_qty_buy_Len >= (FREQ ) or (cancel_test and max (
											openOrders_qty_buy_Len,abs(
											openOrders_qty_sell_Len))==openOrders_qty_buy_Len)) and (
											len(openOrders_time_buy_lmt) > 1 and openOrders_time_buy_max !=0) and QTY < 100
			print('\n')
			print(CYAN + str((fut,'CANCEL EDIT'  )),ENDC)
			print(fut,'cancel_test',cancel_test,'cancel_sell',cancel_sell,'cancel_buy',cancel_buy)
			print(fut,'openOrders_qty_sell_Len',openOrders_qty_sell_Len,'openOrders_qty_buy_Len',openOrders_qty_buy_Len)



#! *******************************************************************************************************************************************
			cancel_buy = False
			cancel_sell = False
#! *******************************************************************************************************************************************


			if  cancel_buy  == True or cancel_sell == True   :	

				if  openOrders_time_sell_max1 != 0:

					prc=(openOrders_prc_sell_max2 + openOrders_prc_sell_max1)/2
					prc_lmt		= round((round(prc/TICK)*TICK)+TICK,2)
					
					edit 		= {
					"limitPrice": prc_lmt,
					"orderId": openOrders_oid_sell_max1,
					"size": openOrders_qty_sell_max1 + openOrders_qty_sell_max2,
					}
					
					print(BLUE + str((fut,'555B','prc_lmt',prc_lmt,
										'qty',openOrders_qty_sell_max1 + openOrders_qty_sell_max2,
										'openOrders_oid_sell_max1',openOrders_oid_sell_max1,
										'openOrders_qty_sell_max2',openOrders_qty_sell_max2,
										cfPrivate.edit_order(
										edit) )),ENDC)

				if  openOrders_oid_sell_max2 != 0:
					
					print(BLUE + str((fut,'openOrders_oid_sell_max2',
										openOrders_oid_sell_max2,
										cfPrivate.cancel_order(
										openOrders_oid_sell_max2) )),ENDC)

				if  openOrders_oid_buy_max1 != 0 :
    					
					prc=(openOrders_prc_buy_max2 + openOrders_prc_buy_max1)/2
					prc_lmt		= round( (round(prc/TICK)*TICK)-TICK,2)
					
					edit 		= {
					"orderId": openOrders_oid_buy_max1,
					"limitPrice": prc_lmt,
					"size":openOrders_qty_buy_max2 + openOrders_qty_buy_max1,
					}

					print(BLUE + str((fut,'555D','prc_lmt',prc_lmt,
										'openOrders_oid_buy_max1',openOrders_oid_buy_max1,
										'openOrders_qty_buy_max2',openOrders_qty_buy_max2,
										'openOrders_qty_buy_max1',openOrders_qty_buy_max1,
										'qty,',openOrders_qty_buy_max2 + openOrders_qty_buy_max1,
									cfPrivate.edit_order(edit) )),ENDC)
																			
				if  openOrders_oid_buy_max2 != 0 :
					print(BLUE + str((fut,'555C','openOrders_oid_buy_max2',
									openOrders_oid_buy_max2,cfPrivate.cancel_order(
									openOrders_oid_buy_max2) )),ENDC)

#? *****************************************************************************************************************************************************

#! CANCEL KARENA SAAT MENGORDER GAGAL KELUAR SEPASANG (LMT-STOP). SEBABNYA BIASANYA KARENA SALAH HARGA (POST WOULD EXECUTE)

			cancel_reject_buy=time_delta_sell > 1 and (
								openOrders_time_buy_stp_max_conv !=0 or openOrders_oid_sell_lmt !=0) and max(
									imbalance_qty_buy,imbalance_qty_sell) > 0

			cancel_reject_sell=time_delta_buy > 1 and (openOrders_oid_buy_lmt != 0 or
								openOrders_time_sell_stp_max_conv !=0) and max(imbalance_qty_buy,imbalance_qty_sell) > 0

#			print('\n')
#			print(CYAN + str((fut,'CANCEL GAGAL SEPASANG'  )),ENDC)
#			print(fut,'cancel_reject_buy',cancel_reject_buy,'cancel_reject_sell',cancel_reject_sell)

#			print(fut,'openOrders_qty_sell_Len',openOrders_qty_sell_Len,'openOrders_qty_buy_Len',openOrders_qty_buy_Len)


#			if cancel_reject_sell :                                                   
#
#				if openOrders_oid_sell_stp !=0:
#					print(BLUE + str((fut,'MMM2',cfPrivate.cancel_order(
#				openOrders_oid_sell_stp) )),ENDC)
#
#				if openOrders_oid_buy_lmt !=0:

#					print(BLUE + str((fut,'MMM3',cfPrivate.cancel_order(
#				openOrders_oid_buy_lmt) )),ENDC)
#				self.restart_program()


#			if cancel_reject_buy: 													

#				if openOrders_oid_buy_stp !=0:
#					print(BLUE + str((fut,'LLLL2',cfPrivate.cancel_order(
#						openOrders_oid_buy_stp) )),ENDC)

#				if openOrders_oid_sell_lmt !=0:
#					print(BLUE + str((fut,'LLLL3',cfPrivate.cancel_order(
#						openOrders_oid_sell_lmt) )),ENDC)


#				self.restart_program()

	#? CEK APAKAH SALDO SUDAH SEIMBANG, POSISI/OPEN BUY - SELL = 0?
		#? BILA YA, CEK WAKTU APAKAH SUDAH SAATNYA ORDER KEMBALI
		#? ORDER KEMBALI:
			#? CEK POSISI DULU, + -> (-), VV

	
		#? Kontrol kuantitas transaksi, memastikan setiap kondisi hanya 
		#? menghasilkan 1 order, dan setiap eksekusi memiliki hanya 1 lawan

		#? Kontrol kuantitas transaksi berdasarkan waktu/keberadaan stop order (maks 1 per instrumen)
			print('\n')
			print(CYAN + str((fut,'ORDER'  )),ENDC)

			default_order = {
							"symbol": fut.upper(),
							"reduceOnly": "false"
							}						

			default_order_buy= (dict(default_order,**{"side": "buy"}))

			default_order_sell= (dict(default_order,**{"side": "sell"}))

			test_timeQty_buy  	=  	(delta_time_buy > IDLE_TIME or  delta_time_buy == 0 ) and openOrders_oid_sell_stp ==0 
			test_timeQty_sell 	=	(delta_time_sell > IDLE_TIME or delta_time_sell ==0  )  and openOrders_oid_buy_stp ==0 
#			print(fut,'test_timeQty_buy',test_timeQty_buy,'test_timeQty_sell',test_timeQty_sell)

		#?  cek qty

			#! init: awal operasi, ditentukan berdasarkan saldo instrumen  #! benar2 kosong, fill 0. open order 0

			#? awal, posisi 0	

			rasio_buy_sell			= 	(hold_qty_buy_all/ max(QTY,hold_qty_sell_all))
			rasio_sell_buy			= 	(hold_qty_sell_all/ max(QTY,hold_qty_buy_all))

			rasio_buy_sell			= 	rasio_buy_sell > 3
			rasio_sell_buy			= 	rasio_sell_buy >3

			avg_down_qty                = openOrders_qty_sell_Len > 0
			avg_up_qty                = openOrders_qty_buy_Len > 0
			qty_normal          = max(hold_qty_buy,abs(hold_qty_sell)) <  QTY * 3 
			qty_down_buy        = hold_qty_buy >=  QTY * 3
			qty_up_sell        = hold_qty_sell >=  QTY * 3

			avg_down_time                = IDLE_TIME * int(hold_qty_buy/QTY)
			avg_up_time                = IDLE_TIME * (hold_qty_sell/QTY)

			over_inventory_buy                = qty_down_buy and avg_down_time
			over_inventory_sell                = qty_up_sell and avg_up_time

			over_inventory_buy                = over_inventory_buy and avg_up_qty  #PERCOBAAN AVG DOWN 1 GAGAL
			over_inventory_sell                = over_inventory_sell and avg_down_qty

			over_inventory_buy_contra                = over_inventory_buy and avg_up_qty == False #PERCOBAAN AVG DOWN 1
			over_inventory_sell_contra                = over_inventory_sell and avg_down_qty == False



#! ************************************************************************************************************************************
#! anti jual/beli rugi


			openOrders_prc_sell_loss= hold_avgPrc_buy + (hold_avgPrc_buy * one_pct/2)
			openOrders_prc_sell_loss= round( (round(openOrders_prc_sell_loss/TICK)*TICK)-TICK,2)

			openOrders_prc_buy_loss= hold_avgPrc_sell - (hold_avgPrc_sell * one_pct/2)
			openOrders_prc_buy_loss= round( (round(openOrders_prc_buy_loss/TICK)*TICK)-TICK,2)


			editable_prc_buy = qty_up_sell and  openOrders_prc_sell_LmtMinPrc < openOrders_prc_buy_loss 
			editable_prc_sell= qty_down_buy and   openOrders_prc_buy_LmtMinPrc > openOrders_prc_sell_loss 

#! *******************************************************************************************************************************************
			editable_prc_buy = False
			editable_prc_sell = False
#! *******************************************************************************************************************************************

			if editable_prc_sell:
    

				if  openOrders_prc_sell_LmtMinPrc < openOrders_prc_sell_loss and openOrders_qty_sell_Len_lmt > 1  :
        
					print (BLUE + str((fut,'editable_prc_buy',
										cfPrivate.cancel_order(
										openOrders_oid_sell_lmtMinPrc) )),ENDC)
					self.restart_program()

				if  imbalance_qty_sell:
                        
					qty=imbalance_qty_buy
					print(REVERSE + str((fut,'editable_prc_buy',
									cfPrivate.send_order_1(
									dict(default_order_buy,
									**{"size": qty,
									"orderType": "post",
									"limitPrice": openOrders_prc_sell_loss
									})))),ENDC)  


			if editable_prc_buy:
    

				if  openOrders_prc_buy_LmtMinPrc < openOrders_prc_buy_loss and openOrders_qty_buy_Len_lmt > 1  :
        
					print (BLUE + str((fut,'editable_prc_buy',
										cfPrivate.cancel_order(
										openOrders_oid_buy_lmtMinPrc) )),ENDC)
					self.restart_program()

				if  imbalance_qty_buy:
                        
					qty=imbalance_qty_buy
					print(REVERSE + str((fut,'editable_prc_buy',
									cfPrivate.send_order_1(
									dict(default_order_buy,
									**{"size": qty,
									"orderType": "post",
									"limitPrice": openOrders_prc_buy_loss
									})))),ENDC)  



#! ************************************************************************************************************************************
#? NORMAL: qty < X, berperilaku seperti MM 


			zero_buy= ((buyable_test ==1  and  rasio_buy_sell == False) or rasio_sell_buy) and matched_buy == False and hold_qty_buy == 0 and test_timeQty_buy 
			zero_sell= ((sellable_test ==1 and rasio_sell_buy == False) or rasio_buy_sell)and matched_buy == False and hold_qty_sell == 0 and test_timeQty_sell 
			
			test_qty_buy_init  =  ((buyable_test ==1  and  rasio_buy_sell == False) or rasio_sell_buy)  and hold_qty_buy == 0 and openOrders_qty_buy_Len == 0 and openOrders_qty_sell_Len == 0 
			test_qty_sell_init =	 ((sellable_test ==1 and rasio_sell_buy == False) or rasio_buy_sell) and hold_qty_sell == 0	and openOrders_qty_buy_Len == 0 and openOrders_qty_sell_Len == 0   

#			print(fut,'zero_buy',zero_buy,'zero_sell',zero_sell,'rasio_sell_buy',rasio_sell_buy,'rasio_buy_sell',rasio_buy_sell)
#			print(fut,'test_qty_buy_init',test_qty_buy_init,'test_qty_sell_init',test_qty_sell_init)

		#? cek waktu

			#? Transaksi tidak tereksekusi segera, diasumsikan ada yang salah

			test_buy_run			=	openOrders_time_buy_lmt_max_conv_net  > (IDLE_TIME * openOrders_qty_buy_max/QTY) and rasio_sell_buy == False #! berarti order beli tidak tereksekusi. 
																							#! diasumsikan posisi short dah berjalan jauh
																							#! diimbangi dengan buy, sehingga saldo 0, vice versa			
			test_sell_run			=	 openOrders_time_sell_lmt_max_conv_net  > (IDLE_TIME * openOrders_qty_sell_max/QTY)   and rasio_buy_sell == False

#			print(fut,'test_buy_run',test_buy_run,'test_sell_run',test_sell_run)
#			print(fut,'openOrders_time_buy_lmt_max_conv_net',openOrders_time_buy_lmt_max_conv_net,
#			'openOrders_time_sell_lmt_max_conv_net',openOrders_time_sell_lmt_max_conv_net)



			#! qty OK, time OK, freq OK
			order_buy_init		=  (	(((test_buy_run and hold_qty_sell > 0))  and test_timeQty_buy) or (
                                        test_qty_buy_init or zero_buy or  over_inventory_buy or over_inventory_sell_contra))#bisa langsung test_qty_buy_init tanpa test_timeQty_buy?

			order_sell_init		=  (	(( (test_sell_run  and hold_qty_buy > 0)) and test_timeQty_sell ) or (
                                        test_qty_sell_init or zero_sell or over_inventory_sell or over_inventory_buy_contra)	)		

#			print(fut,'order_buy_init',order_buy_init,'order_sell_init',order_sell_init)

			activate_buy = openOrders_time_buy_stp_max_conv_net > IDLE_TIME #and imbalance_qty_buy == 0
			activate_sell = openOrders_time_sell_stp_max_conv_net > IDLE_TIME# and imbalance_qty_sell == 0
#? menentukan prc & qty
			
		#	if order_buy or order_sell:	
		
			print('\n')
			if order_buy_init or order_sell_init or imbalance_qty_buy > 0 or imbalance_qty_sell  > 0 or activate_buy or activate_sell:													
				ord_book        = 	self.get_bbo (fut)  
				print(fut,'ask asli', ord_book['ask'], 'ask asli',ord_book['bid'] )

#			if order_buy_init  or imbalance_qty_sell  > 0 :													
				bid_prc         = (ord_book['ask'] - (2 * TICK) ) if abs( (ord_book['bid'] - (
									abs(ord_book['ask'] - TICK) ) ) > TICK * 2) else ord_book['bid']
				bid_prc	=  ord_book['bid'] if sellable_test == 1 else ((bid_prc)) - TICK 
				bid_prc = round(bid_prc,2)

				print(f'AAA {fut} bid_prc {bid_prc} ')
								
#			if order_sell_init or imbalance_qty_buy > 0:													
				ask_prc         = (ord_book['bid'] + (2 * TICK) ) if  abs((ord_book['ask'] - (
									ord_book['bid'] + TICK)) > TICK * 2) else ord_book['ask']
				ask_prc				= ord_book['ask'] if sellable_test == 1 else  ((ask_prc)) + TICK
				ask_prc = round(ask_prc,2)

				print(f'BBB {fut} ask_prc {ask_prc} ')


			tick_margin= TICK * 5 if curr== 'xbt' else TICK * 6
			prc_imb_buy=0
			prc_imb_sell = 0

			qty = QTY
			self.restart_program()



			if order_buy_init or imbalance_qty_sell > 0 :					
									
				#! menghitung prc imbalance	
				prc_imb_buy			= self.rounding(hold_avgPrc_sell - ( (1/100)/2 * hold_avgPrc_sell), TICK)
				prc_imb_buy			=  0 if hold_avgPrc_sell == 0 else min(bid_prc,(prc_imb_buy))
#				print(GREEN + str((fut,'prc_imb_buy C',prc_imb_buy  )),ENDC)
			
				prc_avg_down		=  self.rounding(hold_avgPrc_buy - hold_avgPrc_buy * (hold_qty_buy/QTY*margin_pct), TICK)

				prc_lmt		= self.rounding((bid_prc + (bid_prc *  margin_pct*(3 if qty_up_sell else 1))), TICK)
				bid_prc 	=  self.rounding( (bid_prc - (TICK * (0 if sellable_test == 1 else 2))), TICK)

				bid_prc_stp 	=  round((bid_prc - TICK),2)
				prc				= 	prc_imb_buy if imbalance_qty_sell > 0 else bid_prc	
				qty				= 	imbalance_qty_sell if imbalance_qty_sell > 0 else qty	
				print(GREEN + str((fut,'prc_lmt',prc_lmt,'triggerPrice',bid_prc  )),ENDC)
				print(GREEN + str((fut,'prc_imb_buy',prc_imb_buy,'qty',qty  )),ENDC)

				if   (imbalance_qty_sell > 0 and abs(prc_imb_buy) != 0 ):
        
					print(REVERSE + str((fut,'prc_imb_buy',prc_imb_buy,
									cfPrivate.send_order_1(
									dict(default_order_buy,
									**{"size": qty,
									"orderType": "post",
									"limitPrice": prc_imb_buy
									})))),ENDC)  						

					sleep(1)
					self.restart_program()

				if  order_buy_init and (bid_prc < prc_avg_down or hold_qty_buy == 0):

					print(REVERSE + str((fut,'prc_lmt',prc_lmt,'bid_prc_stp',bid_prc_stp,
									cfPrivate.send_order_1(
									dict(default_order_sell,
									**{"size": QTY,
									"orderType": "stp",
									"limitPrice":prc_lmt,
									"triggerSignal":"last",
									"reduceOnly":"false",
									"stopPrice":bid_prc_stp
									})))),ENDC)
    
					print(GREEN + str((fut,'bid_prc',bid_prc,
									cfPrivate.send_order_1(
									dict(default_order_buy,
									**{"size": QTY,
									"orderType": "post",
									"limitPrice": bid_prc
									})))),ENDC)  						


					self.restart_program()					

			if order_sell_init  or imbalance_qty_buy  > 0:
									
				#! menghitung prc imbalance	
				prc_imb_sell			= self.rounding(hold_avgPrc_buy + ( (1/100)/2 * hold_avgPrc_buy), TICK)  
				
				prc_imb_sell			=  0 if hold_avgPrc_buy == 0 else max(ask_prc,(prc_imb_sell))
				
				prc_lmt		= self.rounding(ask_prc - (ask_prc *  margin_pct*(3 if qty_down_buy else 1)) , TICK)  
				
				ask_prc 	= self.rounding((ask_prc + (TICK * (0 if sellable_test == 1 else 2))), TICK) 
				
				ask_prc_stp 	=   round((ask_prc + TICK),2)
				prc				= 	prc_imb_sell if imbalance_qty_buy  > 0 else ask_prc	
				qty				= 	imbalance_qty_buy if imbalance_qty_buy > 0 else qty	
				print(GREEN + str((fut,'prc_lmt',prc_lmt,'triggerPrice',ask_prc  )),ENDC)
				print(GREEN + str((fut,'prc_imb_sell',prc_imb_sell,'qty',qty  )),ENDC)

				if  (imbalance_qty_buy > 0 and abs(prc_imb_sell) !=0)  :

					print(REVERSE + str((fut,'prc_imb_sell',prc_imb_sell,
									cfPrivate.send_order_1(dict(default_order_sell,
									**{"size": qty,
									"orderType": "post",
									"limitPrice":prc_imb_sell
									})))),ENDC)

					sleep(1)
					self.restart_program()

				if order_sell_init :
							
					print(REVERSE + str((fut,'prc_lmt',prc_lmt,'ask_prc_stp',ask_prc_stp,
									cfPrivate.send_order_1(dict(default_order_buy,
									**{"size": QTY,
									"orderType": "stp",
									"limitPrice":prc_lmt,
									"reduceOnly":"false",
									"triggerSignal":"last",
									"stopPrice":ask_prc_stp
									})))),ENDC)
	
					print(RED + str((fut,'ask_prc',ask_prc,
									cfPrivate.send_order_1(dict(default_order_sell,
									**{"size": QTY,
									"orderType": "post",
									"limitPrice":ask_prc
									})))),ENDC)

					self.restart_program()

#! aktivasi stop yang tersisa

			print(fut,'openOrders_prc_buy_stp',openOrders_prc_buy_stp,'openOrders_prc_sell_stp',openOrders_prc_sell_stp)
			
			
#			activate_buy = openOrders_time_buy_stp_max_conv_net > IDLE_TIME and imbalance_qty_buy == 0
#			activate_sell = openOrders_time_sell_stp_max_conv_net > IDLE_TIME and imbalance_qty_sell == 0

			if activate_buy or activate_sell:

				if  activate_buy   :
       					
					prc = min (openOrders_prc_buy_stp, bid_prc-TICK)
					prc			= round(prc / TICK)
					prc			= round((prc * TICK),2)
					print(GREEN + str((fut,'activate_buy','prc',prc,
									cfPrivate.send_order_1(dict(default_order_buy,
									**{"size": QTY,
									"orderType": "post",
									"limitPrice":prc
									})))),ENDC)

					print(BLUE + str((fut,'activate_buy',cfPrivate.cancel_order(
				openOrders_oid_buy_stp) )),ENDC)			
					self.restart_program()
						

				if  activate_sell	 :
       					
					prc = max (openOrders_prc_sell_stp, ask_prc+TICK)
					prc			= round(prc / TICK)
					prc			= round((prc * TICK),2)
					print(RED + str((fut,'activate_sell','prc',prc,
									cfPrivate.send_order_1(dict(default_order_sell,
									**{"size": QTY,
									"orderType": "post",
									"limitPrice":prc
									})))),ENDC)

					print(BLUE + str((fut,'activate_sell',cfPrivate.cancel_order(
				openOrders_oid_sell_stp) )),ENDC)
					self.restart_program()

#!menghilangkan order ekstrem
#			print(fut,' prc_min_max_pct > one_pct', prc_min_max_pct > one_pct,'editable',editable,'qty_min_max',qty_min_max)
#			print(fut,' openOrders_time_sell_prcMax_conv_net', openOrders_time_sell_prcMax_conv_net,
#			' openOrders_time_buy_prcMin_conv_net', openOrders_time_buy_prcMin_conv_net)



#			if  (prc_min_max_pct > one_pct or editable)  and openOrders_time_sell_prcMax_conv_net > IDLE_TIME*3 and openOrders_time_buy_prcMin_conv_net > IDLE_TIME*3:

#				if  qty_min_max == 0 and ((openOrders_oid_sell_prcMax !=0 ) and (
#					openOrders_oid_buy_prcMin !=0 ) ):
#					print(BLUE + str((fut,'qty_min_max == 0 ',
#										cfPrivate.cancel_order(
#										openOrders_oid_sell_prcMax) )),ENDC)

#					print(BLUE + str((fut,'qty_min_max == 0 ',
#										cfPrivate.cancel_order(
#										openOrders_oid_buy_prcMin) )),ENDC)

#					self.restart_program()


#				if  qty_min_max != 0 and (openOrders_oid_sell_prcMax !=0  and openOrders_oid_buy_prcMin !=0 ) and editable:
    
					
#					if openOrders_oid_sell_cancel !=0:
 #  						edit_sell 		= {

#					"orderId": openOrders_oid_buy_edit,
#					"size": qty_min_max,
#					}

 #  						print(BLUE + str((fut,'sell_edit',
#										cfPrivate.edit_order(
#										edit_sell) )),ENDC)

 #  						print(BLUE + str((fut,'openOrders_oid_buy_edit',cfPrivate.cancel_order(
#						openOrders_oid_sell_cancel) )),ENDC)
#	

#					self.restart_program()
					
#					if openOrders_oid_buy_cancel !=0:
 #  						edit_sell 		= {

#					"orderId": openOrders_oid_sell_edit,
#					"size": qty_min_max,
#					}


 #  						print(BLUE + str((fut,'openOrders_oid_sell_edit',
#										cfPrivate.edit_order(
#										edit_sell) )),ENDC)


 #  						print(BLUE + str((fut,'openOrders_oid_buy_cancel',cfPrivate.cancel_order(
#						openOrders_oid_buy_cancel) )),ENDC)

#					self.restart_program()


								
			if counter > (COUNTER ):
				while True:
					sleep (10)
					self.restart_program()
				break
								
			print(BOLD + str((fut,'counter',counter)),ENDC)
			print(NOW_TIME)
			print('\n')

	def restart_program(self):

		python = sys.executable
		os.execl(python, python, * sys.argv)

	def run(self):

		self.run_first()

		while True:

			self.place_orders()
	

	def run_first(self):

		self.create_client()
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
			
#TODO:


#FIXME:
