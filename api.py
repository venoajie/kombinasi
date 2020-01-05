# -*- coding: utf-8 -*-

import time, hashlib, requests, base64#, json, hmac, sys,
from collections import OrderedDict

#import json
#import hashlib
#import base64
#import hmac
#import sys
#import websocket

#from threading import Thread
#from cfLogging import CfLogger

#def __init__(self, base_url, api_key="", api_secret="", timeout=5, trace=False):

class RestClient(object):
    def __init__(self, key=None, secret=None, url=None):
        self.key = key
        self.secret = secret
        self.session = requests.Session()

        if url:
            self.url = url
    
        else:
            self.url = "https://www.deribit.com"

    def request(self, action, data):
        response = None

        if action.startswith("/api/v1/private/"):
            if self.key is None or self.secret is None:
                raise Exception("Key or secret empty")

            signature = self.generate_signature(action, data)
            response = self.session.post(self.url + action, data=data, headers={'x-deribit-sig': signature}, verify=True)	
        else:
            response = self.session.get(self.url + action, params=data, verify=True)

        if response.status_code != 200:
            raise Exception("Wrong response code: {0}".format(response.status_code))

        json = response.json()

        if json["success"] == False:
            raise Exception("Failed: " + json["message"])

        if "result" in json:
            return json["result"]
        elif "message" in json:
            return json["message"]
        else:
            return "Ok"

    def generate_signature(self, action, data):
        tstamp = int(time.time()* 1000)
        signature_data = {
            '_': tstamp,
            '_ackey': self.key,
            '_acsec': self.secret,
            '_action': action
        }
        signature_data.update(data)
        sorted_signature_data = OrderedDict(sorted(signature_data.items(), key=lambda t: t[0]))


        def converter(data):
            key = data[0]
            value = data[1]
            if isinstance(value, list):
                return '='.join([str(key), ''.join(value)])
            else:
                return '='.join([str(key), str(value)])

        items = map(converter, sorted_signature_data.items())

        signature_string = '&'.join(items)

        sha256 = hashlib.sha256()
        sha256.update(signature_string.encode("utf-8"))
        sig = self.key + "." + str(tstamp) + "."
        sig += base64.b64encode(sha256.digest()).decode("utf-8")
        return sig

    def getpositions(self):
        return self.request("/api/v1/private/positions", {})
		


    def getorderbook(self, instrument):
        return self.request("/api/v1/public/getorderbook", {'instrument': instrument})


    def getinstruments(self):
        return self.request("/api/v1/public/getinstruments", {})

    def gettime(self):
        return self.request("/api/v1/public/time", {})


    def getcurrencies(self):
        return self.request("/api/v1/public/getcurrencies", {})

    def getlasttrades(self, instrument, count=None, since=None):
        options = {
            'instrument': instrument
        }

        if since:
            options['since'] = since

        if count:
            options['count'] = count

        return self.request("/api/v1/public/getlasttrades", options)


    def getsummary(self, instrument):
        return self.request("/api/v1/public/getsummary", {"instrument": instrument})


    def index(self):
        return self.request("/api/v1/public/index", {})


    def stats(self):
        return self.request("/api/v1/public/stats", {})


    def account(self):
        return self.request("/api/v1/private/account",  {"ext": 'true'})
				
    def subaccounts(self):
        return self.request("/api/v2/private/get_subaccounts",  {"with_portfolio": 'true'})


    def buy(self, instrument, quantity, price, postOnly=None, label=None):
        options = {
            "instrument": instrument,
            "quantity": quantity,
            "price": price
        }

        if label:
            options["label"] = label

        if postOnly:
            options["postOnly"] = postOnly

        return self.request("/api/v1/private/buy", options)


    def sell(self, instrument, quantity, price, postOnly=None, label=None):
        options = {
            "instrument": instrument,
            "quantity": quantity,
            "price": price
        }

        if label:
            options["label"] = label
        if postOnly:
            options["postOnly"] = postOnly

        return self.request("/api/v1/private/sell", options)
	
        if label:
            options["label"] = label
        if postOnly:
            options["postOnly"] = postOnly

        return self.request("/api/v1/private/sell", options)

    def cancel(self, orderId):
        options = {
            "orderId": orderId
        }

        return self.request("/api/v1/private/cancel", options)


    def cancelall(self, typeDef="all"):
        return self.request("/api/v1/private/cancelall", {"type": typeDef})


    def edit(self, orderId, quantity, price):
        options = {
            "orderId": orderId,
            "quantity": quantity,
            "price": price
        }

        return self.request("/api/v1/private/edit", options)


    def getopenorders(self, instrument=None, orderId=None):
        options = {}

        if instrument:
            options["instrument"] = instrument
        if orderId:
            options["orderId"] = orderId

        return self.request("/api/v1/private/getopenorders", options)


    def positions(self):
        return self.request("/api/v1/private/positions", {})

    def orderhistory(self, count=None):
        options = {}
        if count:
            options["count"] = count

        return self.request("/api/v1/private/orderhistory", options)


    def tradehistory(self, countNum=None, instrument="all", startTradeId=None):
        options = {
            "instrument": instrument
        }

        if countNum:
            options["count"] = countNum
        if startTradeId:
            options["startTradeId"] = startTradeId

        return self.request("/api/v1/private/tradehistory", options)
