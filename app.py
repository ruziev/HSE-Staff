TORUN = 0

from flask import Flask, request
from sqlalchemy import create_engine

app = Flask(__name__)
DB = create_engine(  )


@app.route("/")
def index():
    return "This is the homepage"

@app.route("/method", methods = ["GET", "POST"])
def method():
    if request.method == "POST":
        return "You are using POST"
    if request.method == "GET":
        return "You are using GET"

if __name__ == "__main__" and TORUN:
    app.run(debug=True)
