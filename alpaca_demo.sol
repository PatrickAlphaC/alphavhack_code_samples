# add your api key in a config.py file

from config import *
import requests
import json
import click
BASE_URL = "https://paper-api.alpaca.markets"
HEADERS = {"APCA-API-KEY-ID": API_KEY, "APCA-API-SECRET-KEY": SECRET_KEY}
ACCOUNTS_URL = "{}/v2/account".format(BASE_URL)
ORDERS_URL = "{}/v2/orders".format(BASE_URL)


@click.command(help='Connects to alpaca API and executes orders and gets portfolio/account informaiton')
@click.option('--action', type=click.Choice(['buy', 'sell', 'get-orders', 'get-account']), help='Execute a buy, account orders, etc')
@click.option('--symbol', help='Symbol/Ticker to buy or sell')
@click.option('--qty', help='Quantity of shares to buy/sell')
def paper_trade_bot(action, symbol, qty):
    if action == 'get-account':
        print(get_accounts())
    if action == 'get-order':
        print(get_orders())
    if action == 'buy' or action == 'sell':
        print(create_order(symbol, qty, action))


def get_accounts():
    request = requests.get(ACCOUNTS_URL, headers=HEADERS)
    return json.loads(request.content)


def get_orders():
    request = requests.get(ORDERS_URL, headers=HEADERS)
    return json.loads(request.content)


def create_order(symbol, qty, side, type="market", time_in_force="gtc"):
    data = {
        "symbol": symbol,
        "qty": qty,
        "side": side,
        "type": type,
        "time_in_force": time_in_force
    }
    request = requests.post(ORDERS_URL, json=data, headers=HEADERS)
    return json.loads(request.content)


def main():
    paper_trade_bot()


if __name__ == '__main__':
    main()
