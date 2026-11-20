import requests

# 1. Informacije o svemirskoj stanici
# Napisati funkciju get_space_station() -> dict koja preko Open
# Notify API-ja (http://api.open-notify.org/iss-now.json) preuzima
# trenutnu poziciju Međunarodne svemirske stanice (ISS) i vraća
# rečnik koji sadrži:
# geografsku širinu (latitude),
# geografsku dužinu (longitude)
def get_space_station() -> dict:
    r = requests.get('http://api.open-notify.org/iss-now.json')
    r.raise_for_status()

    return r.json()['iss_position']


get_space_station()


# 2. Pretraga univerziteta
# Napisati funkciju get_universities(country: str) -> list koja preko
# Hipolabs API-ja (http://universities.hipolabs.com/search) preuzima
# univerzitete iz zadate države i vraća listu njihovih naziva.
# Koristiti params={'country': country} za prosleđivanje naziva države
# API-ju.
def get_universities(country: str) -> list:
    r = requests.get('http://universities.hipolabs.com/search', params={'country': country})
    r.raise_for_status()

    return [uni['name'] for uni in r.json()]


get_universities('Serbia')


# 3. Informacije o kursu valuta
# Napisati funkciju get_exchange_rate(base: str, target: str) -> float
# koja preko Frankfurter API-ja (https://api.frankfurter.dev/v1/latest)
# preuzima kurs između dve valute.
# Funkcija treba da vrati koliko jedinica ciljne valute (target) se dobija
# za jednu jedinicu početne valute (base).
# Input: get_exchange_rate("EUR", "RSD")
# Output: 117.2
def get_exchange_rate(base: str, target: str) -> float:
    r = requests.get('https://api.frankfurter.dev/v1/latest', params={'base': {base}})
    r.raise_for_status()

    return r.json()['rates'][target]


get_exchange_rate("EUR", "USD")
# preko ovog url-a imamo podatke samo za mali broj kurseva a npr za dinare nemamo,
# pa smo dosta ograničeni. Zato postoji v2/rates koji nam to omogucava

def get_exchange_rate(base: str, target: str) -> float:
    r = requests.get('https://api.frankfurter.dev/v2/rates', params={'base': {base}, 'quotes': {target}})
    r.raise_for_status()

    return r.json()[0]['rate']


get_exchange_rate("EUR", "RSD")