from flask import Flask, request, jsonify
from config import Config
from flask_apps.book_service import books_service
from flask_apps.user_service import user_service
from flask_apps.auth_service import auth_service
from models import db, User
from flask_jwt_extended import JWTManager, decode_token, jwt_required, get_jwt_identity
from functools import wraps

app= Flask(__name__)

app.config['SECRET_KEY'] = 'your_secret_key'
app.config['JWT_SECRET_KEY'] = 'your_jwt_secret_key'

jwt = JWTManager(app)
                        
app.config.from_object(Config)
db.init_app(app)

app.register_blueprint(books_service)
app.register_blueprint(user_service)
app.register_blueprint(auth_service)

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token= None
        
        if 'x-access-token' in request.headers:
            token= request.headers["x-access-token"]
            
        if not token:
            return jsonify({"message": "Token is missing"})
        
        try:
            # data= jwt.decode(token,"your_secret_key" )
            data= decode_token(token)
            
            print(data["sub"])
            # use id here as in auth_service.login(), we use id as the identity
            current_user = User.query.filter_by(id=int(data["sub"])).first() #<- INVALID TOKEN CAUSED HERE
        
            print(current_user)
            
        except:
            return jsonify({"message": "Token is invalid"}), 401
        
        return f(current_user, *args, **kwargs)
    
    return decorated




@app.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user = get_jwt_identity()
    return jsonify(logged_in_as=current_user), 200



if __name__ == '__main__':
    app.run(debug=True)