import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class AWSServices {
  final userPool = CognitoUserPool(
    'ap-southeast-2_6R3whsPNf', '6iuist4oh0p3c1h9mhg1qoi469',
    // clientSecret: '11uc8dhqse1ba2eanmf7p5d9h5n9c0pqbipdkha871qm501682h0'
  );

  final userAttributes = [
    const AttributeArg(name: 'email', value: 'penguinlover@gmail.com'),
    // Include any other required attributes here
    const AttributeArg(name: 'name', value: 'Penguin Lover'),
  ];

  registerUser() async {
    var data;

    try {
      data = await userPool.signUp(
        'myUsername',
        'Password@001',
        userAttributes: userAttributes,
      );
      print('User registered successfully: $data');
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  // Function to login a user
  Future<void> loginUser(String email, String password) async {
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );

    try {
      final session = await cognitoUser.authenticateUser(authDetails);
      print('Login successful!');
      print('Access Token: ${session?.accessToken.jwtToken}');
      print('ID Token: ${session?.idToken.jwtToken}');
      print('Refresh Token: ${session?.refreshToken?.token}');
    } catch (e) {
      print('Error logging in: $e');
    }
  }
}
