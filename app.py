import os
import requests
from flask import Flask, render_template, request

app = Flask(__name__)

API_KEY = os.environ.get('OPENWEATHER_API_KEY')
BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

@app.route('/', methods=['GET', 'POST'])
def index():
    weather = None
    error = None

    if request.method == 'POST':
        city = request.form.get('city')
        try:
            response = requests.get(BASE_URL, params={
                'q': city,
                'appid': API_KEY,
                'units': 'metric'
            })
            data = response.json()

            if response.status_code == 200:
                weather = {
                    'city': data['name'],
                    'country': data['sys']['country'],
                    'temperature': round(data['main']['temp']),
                    'feels_like': round(data['main']['feels_like']),
                    'humidity': data['main']['humidity'],
                    'description': data['weather'][0]['description'].capitalize(),
                    'wind_speed': data['wind']['speed'],
                    'icon': data['weather'][0]['icon']
                }
            else:
                error = f"City '{city}' not found. Please try again."
        except Exception as e:
            error = "Could not connect to weather service. Please try again."

    return render_template('index.html', weather=weather, error=error)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)