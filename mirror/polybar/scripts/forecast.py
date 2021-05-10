#!/bin/python/
import click
import requests
import json

# Use your own API key pls
API_KEY = '348664baf80b144f7bde2675044e031d'

def map_icon(code: str) -> str:
    # Map the OWM icon code to a unicode icon
    # https://openweathermap.org/weather-conditions#How-to-get-icon-URL
    if code == '01d' or code == '01n': return u'%{T2}%{T-}'
    if code == '02d' or code == '02n': return u'%{T2}%{T-}'
    if code == '03d' or code == '03n': return u'%{T2}%{T-}'
    if code == '04d' or code == '04n': return u'%{T2}%{T-}'
    if code == '09d' or code == '09n': return u'%{T2}%{T-}'
    if code == '10d' or code == '10n': return u'%{T2}%{T-}'
    if code == '11d' or code == '11n': return u'%{T2}%{T-}'
    if code == '13d' or code == '1dn': return u'%{T2}%{T-}'

@click.command()
@click.option('--lat', default=51.509865, help='Latitude')
@click.option('--lon', default=-0.118092, help='Longitude')
@click.option('--unit', default='metric', help='Unit for temperature measurements')
@click.option('--show-icon', is_flag=True,help='Whether to show the appropriate icon')
def get_weather(lat, lon, show_icon, unit):
    endpoint = f'https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&units={unit}&appid={API_KEY}'

    req = requests.get(endpoint)
    data = req.json()

    if req.status_code != 200:
        # Handle if there's an error while fetching the API
        return 'error'

    temp = int(data['current']['temp']) # round up from eg 20.93 to 21 c
    humidity = data['current']['humidity']
    name = data['current']['weather'][0]['main']

    icon = map_icon(data['current']['weather'][0]['icon'])
    if unit == 'metric':
        unit_icon = '°C'
    if unit == 'imperial':
        unit_icon = '°F'

    if show_icon:
        print(f' {icon} {temp}{unit_icon}')
    else:
        print(f' {temp}{unit_icon}')

if __name__ == '__main__':
    get_weather()
