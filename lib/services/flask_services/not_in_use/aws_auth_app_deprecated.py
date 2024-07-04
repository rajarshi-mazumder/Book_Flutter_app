from flask import Flask, request, jsonify, render_template_string
import boto3
from botocore.exceptions import ClientError
import uuid

app = Flask(__name__)


# USER_POOL_ID = 'us-east-1_ubkKtZmFw'
USER_POOL_ID = 'ap-southeast-2_6R3whsPNf'
# CLIENT_ID = '5mmnrdscf08ahlhgb5cuolm53u'
CLIENT_ID = '6iuist4oh0p3c1h9mhg1qoi469'
# REGION= 'us-east-1'
REGION= 'ap-southeast-2'
# CLIENT_SECRET = 'your_client_secret'  # Uncomment if using a client secret



cognito_client = boto3.client('cognito-idp', region_name=REGION)

@app.route('/')
def home():
    return render_template_string("""
        <h1>Welcome to AWS Cognito Authentication</h1>
        <ul>
            <li><a href="/signup">Sign Up</a></li>
            <li><a href="/signin">Sign In</a></li>
        </ul>
    """)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        try:
            email = request.form['email']
            password = request.form['password']

            # Generate a unique username (UUID can be used)
            username = str(uuid.uuid4())

            response = cognito_client.sign_up(
                ClientId=CLIENT_ID,
                Username=username,
                Password=password,
                UserAttributes=[
                    {
                        'Name': 'Email',
                        'Value': email
                    },
                    {
                        'Name':'Name',
                        'Value': 'Heat'
                    }
                ]
            )
            return jsonify({'message': 'User signed up successfully', 'response': response}), 200
        except ClientError as e:
            error_message = e.response['Error']['Message']
            return jsonify({'error': error_message}), 400
    return render_template_string("""
        <h1>Sign Up</h1>
        <form method="post">
            Email: <input type="email" name="email" required><br>
            Password: <input type="password" name="password" required><br>
            <input type="submit" value="Sign Up">
        </form>
        <a href="/">Back to Home</a>
    """)

@app.route('/signin', methods=['GET', 'POST'])
def signin():
    if request.method == 'POST':
        try:
            email = request.form['email']
            password = request.form['password']

            response = cognito_client.initiate_auth(
                ClientId=CLIENT_ID,
                AuthFlow='USER_PASSWORD_AUTH',
                AuthParameters={
                    'USERNAME': email,
                    'PASSWORD': password
                }
            )
            return jsonify({
                'message': 'User signed in successfully',
                'id_token': response['AuthenticationResult']['IdToken'],
                'access_token': response['AuthenticationResult']['AccessToken'],
                'refresh_token': response['AuthenticationResult']['RefreshToken']
            }), 200
        except ClientError as e:
            error_message = e.response['Error']['Message']
            return jsonify({'error': error_message}), 400
    return render_template_string("""
        <h1>Sign In</h1>
        <form method="post">
            Email: <input type="email" name="email" required><br>
            Password: <input type="password" name="password" required><br>
            <input type="submit" value="Sign In">
        </form>
        <a href="/">Back to Home</a>
    """)

if __name__ == '__main__':
    app.run(debug=True)