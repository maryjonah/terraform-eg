from flask import Flask, render_template
import requests

app = Flask(__name__)

API_URL = "https://zenquotes.io/api/today"


@app.route("/")
def index():
    quote_of_day_data = requests.get(API_URL).json()
    quote = quote_of_day_data[0]["q"]
    return render_template("index.html", quote=quote)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
