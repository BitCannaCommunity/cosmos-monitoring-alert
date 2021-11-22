#python3

import requests
import datetime
import time
import os

time_msg = 60

url_cosmos = 'http://seed2.bitcanna.io:16657/block'

#address monitoring variables
validators_to_mon_bitcanna = [
    {"name": 'Cibdol', "validator": '6925C5BFFD3FC2B26E034B50C159FD33428F5017', "telegram": '@Raul_BitCannaES'},
    {"name": 'Otro', "validator": 'dfgdsfgtye', "telegram": '@Raul_BitCannaES'},
    {"name": 'Raul', "validator": '296A4A9CECB5DEABBA0DE91FB43D5A18B1DA6A73', "telegram": '@Raul_BitCannaES'}]

def welcome_msg():
    msg = ''
    msg_intro = '*Bot started, we are going to check some VALIDATORS every ' + str(time_msg) + ' seconds*\n\n'
    for validators in validators_to_mon_bitcanna:
        msg += "Checking: " + validators['validator'] + " - " + validators['name'] + '\n'
    msg_formated = msg_intro + msg
    print(msg_formated)

def check_signers():
    try:
        response_check = requests.get(url_cosmos, headers={"Accept": "application/json"},)
    except:
        conn_error = 'An error occurred getting the balance for Faucet'
        print("\n"+conn_error)
    else:
        signers=''
        json_response = response_check.json()
        signatures = json_response["result"]["block"]["last_commit"]["signatures"]
        for validators_signers in signatures:
            signers+= validators_signers["validator_address"]
        for validators in validators_to_mon_bitcanna:
            print ( validators['validator'] in signers)
            if ( validators['validator'] in signers):
                print('👍 '+ str( validators['validator']) + ' is signing \n' )
            else:
                print('❌ ' + str( validators['validator']) + ' is not signing!! ' + str( validators['telegram']) + ' \n')

if __name__ == "__main__":
    welcome_msg()
    while 1==1:
        check_signers()
        time.sleep(time_msg)
