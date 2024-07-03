from flask import Flask, request, jsonify, Blueprint
from config import Config
from models import db, Book, Author, Category, User
import uuid
from werkzeug.security import generate_password_hash, check_password_hash


user_service= Blueprint("users", __name__)

@user_service.route("/users", methods=["GET"])
def get_all_users():
    users= User.query.all()
    output_users=[]

    for user in users:
        user_data={}
        user_data["id"]= user.id
        user_data["name"]= user.name
        user_data["email"]= user.email
        user_data["password"]= user.password
        output_users.append(user_data)
    
    return jsonify({"users": output_users})

@user_service.route("/users/<user_id>", methods=["GET"])
def get_user(user_id):
    user= User.query.filter_by(id=user_id ).first()
    
    if not user:
        return jsonify({'message': "No user found"})
    
    user_data={}
    user_data["id"]= user.id
    user_data["name"]= user.name
    user_data["email"]= user.email
    user_data["password"]= user.password
    
    return jsonify({'user': user_data})
  
@user_service.route("/users", methods=["POST"])
def create_user():
    data= request.get_json()
    name=data["name"]
    email= data["email"]
    hashed_password= generate_password_hash(data["password"], method= "pbkdf2:sha256")
    admin= False
    new_user= User(name= name, email= email, password= hashed_password, admin= admin)
    db.session.add(new_user)
    db.session.commit()
    
    return jsonify({f'message': 'New user created '})

@user_service.route("/users/<int:user_id>/books_started", methods=["POST"])
def add_user_books_started(user_id):
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return jsonify({'message': "No user found"})    
    
    data = request.get_json()
    books_started_ids = data.get("books_started", [])

    try:
        for book_id in books_started_ids:
            book = Book.query.get(book_id)
            if book and book not in user.books_started:
                user.books_started.append(book)
        
        db.session.commit()
        return jsonify({'message': f'User {user.name} books started updated'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
    


@user_service.route("/users/<user_id>", methods=["PUT"])
def update_users():
    pass