from flask import Flask
application = Flask(__name__)

@application.route("/")
def hello():
    return "<h1 style='color:blue'>Hello MOTO!!!</h1><p>Powered by Flask</p>"

if __name__ == "__main__":
    application.run(host='0.0.0.0')
