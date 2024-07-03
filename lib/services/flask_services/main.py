from flask import Flask, request, jsonify
from config import Config
from book_service import books_service
from user_service import user_service
from models import db

app= Flask(__name__)

app.config.from_object(Config)
db.init_app(app)

app.register_blueprint(books_service)
app.register_blueprint(user_service)

if __name__ == '__main__':
    app.run(debug=True)