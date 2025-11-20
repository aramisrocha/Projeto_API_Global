import requests
from datetime import datetime

def get_bitcoin_price():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {
        "ids": "bitcoin",
        "vs_currencies": "usd,brl"
    }

    try:
        response = requests.get(url, params=params, timeout=10)
        data = response.json()

        usd = data["bitcoin"]["usd"]
        brl = data["bitcoin"]["brl"]

        return usd, brl

    except Exception as e:
        print(f"Erro ao buscar cotação: {e}")
        return None, None


if __name__ == "__main__":
    print("Buscando cotação do Bitcoin...\n")

    usd, brl = get_bitcoin_price()

    # Data e hora no formato brasileiro
    agora = datetime.now().strftime("%d/%m/%Y %H:%M:%S")

    if usd is not None:
        print("=== Cotação Atual do Bitcoin ===")
        print(f"Data e hora: {agora}")
        print(f"USD: $ {usd}")
        print(f"BRL: R$ {brl}")
        print("================================\n")
    else:
        print("Não foi possível obter o valor do Bitcoin.")

