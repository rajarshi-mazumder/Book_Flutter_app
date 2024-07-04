from flask import Flask, request, jsonify, Blueprint, make_response
from config import Config
from models import db, Book, Author, Category, User
import uuid
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
from datetime import datetime, timezone, timedelta
from flask_jwt_extended import JWTManager, create_access_token, jwt_required,  get_jwt_identity
from functools import wraps


auth_service= Blueprint("auth", __name__)

def auth_required(f):
    @wraps(f)
    @jwt_required()
    def decorated(*args, **kwargs):
        current_user_id = get_jwt_identity()
        current_user= User.query.filter_by(id= current_user_id["id"]).first()
        if not current_user:
            return jsonify({'message':'user not found'})
        
        print(current_user) 
        return f(current_user, *args, **kwargs)
    
    return decorated
    


@auth_service.route("/login")
def login():
    auth = request.authorization
    
    if not auth or not auth.username or not auth.password:
        print(auth)
        return make_response('Could not verify 1st', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})
    
    user = User.query.filter_by(email=auth.username).first()
    if not user:
        return make_response('Could not verify 2nd', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})
    
    if check_password_hash(user.password, auth.password):
        token = create_access_token(identity={'id': user.id}, expires_delta= timedelta(minutes=300))
        return jsonify({'token': token})
    
    return make_response('Could not verify 3rd', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})
