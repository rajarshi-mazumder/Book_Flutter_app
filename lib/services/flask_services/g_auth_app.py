from flask import Flask, redirect, request, jsonify, session, url_for, make_response
import requests
import os
from flask_cors import CORS

app = Flask(__name__)
app.secret_key = os.urandom(24)

CORS(app, supports_credentials=True, resources={r"/*": {"origins": "http://localhost:50267"}})


# Google OAuth configuration
CLIENT_ID = '510659721706-ir21bh5mu75e5is2csppai7upedkh0ov.apps.googleusercontent.com'
CLIENT_SECRET = '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'
REDIRECT_URI = 'http://localhost:5000/callback'
SCOPE = 'openid email profile'

@app.route('/')
def home():
    return '''
        <h1>Google OAuth Sign-In</h1>
        <ul>
            <li><a href="/login">Login with Google</a></li>
        </ul>
    '''

@app.route('/login')
def login():
    google_auth_url = (
        "https://accounts.google.com/o/oauth2/v2/auth"
        "?response_type=code"
        f"&client_id={CLIENT_ID}"
        f"&redirect_uri={REDIRECT_URI}"
        f"&scope={SCOPE}"
        "&access_type=offline"
    )
    return redirect(google_auth_url)

@app.route('/callback')
def callback():
    code = request.args.get('code')

    # Exchange code for tokens
    token_url = "https://oauth2.googleapis.com/token"
    token_data = {
        "code": code,
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "redirect_uri": REDIRECT_URI,
        "grant_type": "authorization_code"
    }
    token_headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    token_response = requests.post(token_url, data=token_data, headers=token_headers)
    token_response_json = token_response.json()

    # Get user info
    user_info_url = "https://www.googleapis.com/oauth2/v3/userinfo"
    user_info_response = requests.get(user_info_url, headers={
        "Authorization": f"Bearer {token_response_json['access_token']}"
    })
    user_info = user_info_response.json()

    # Store user info in session
    session['user_info'] = user_info

    response = make_response(redirect(url_for('profile')))
    response.set_cookie('session', user_info['sub'])  # Set a cookie for the session
    return response

@app.route('/profile')
def profile():
    user_info = session.get('user_info')
    if user_info:
        return jsonify(user_info)
    else:
        return jsonify({'error': 'User not logged in'}), 401

@app.route('/logout')
def logout():
    session.pop('user_info', None)
    response = make_response(jsonify({'message': 'Logged out successfully'}))
    response.delete_cookie('session')  # Delete the session cookie
    return response

if __name__ == '__main__':
    app.run(debug=True)
