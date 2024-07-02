import 'package:book_frontend/services/auth_services/authServices.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSubmit() {
    AuthService.login().then((value) => print(value?.body));
    // if (_formKey.currentState!.validate()) {
    //   final email = _emailController.text;
    //   final password = _passwordController.text;
    //
    //   // print('Email: $email');
    //   // print('Password: $password');
    //   // AWSServices().registerUser();
    //   // AWSServices().loginUser();
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? userInfo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  try {
                    _handleSubmit();
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Login with Google'),
              ),
              ElevatedButton(
                onPressed: () async {
                  userInfo = await AuthService.getProfile();
                  setState(() {});
                },
                child: Text('Get User Info'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.logout();
                  userInfo = null;
                  setState(() {});
                },
                child: Text('Logout'),
              ),
              if (userInfo != null) ...[
                Text('Name: ${userInfo!['name']}'),
                Text('Email: ${userInfo!['email']}'),
                Image.network(userInfo!['picture']),
              ],
            ],
          ),
        ),
        // child: Form(
        //   key: _formKey,
        //   child: Column(
        //     children: <Widget>[
        //       TextFormField(
        //         controller: _emailController,
        //         decoration: InputDecoration(labelText: 'Email'),
        //         validator: (value) {
        //           if (value == null || value.isEmpty) {
        //             return 'Please enter your email';
        //           }
        //           return null;
        //         },
        //       ),
        //       TextFormField(
        //         controller: _passwordController,
        //         decoration: InputDecoration(labelText: 'Password'),
        //         obscureText: true,
        //         validator: (value) {
        //           if (value == null || value.isEmpty) {
        //             return 'Please enter your password';
        //           }
        //           return null;
        //         },
        //       ),
        //       SizedBox(height: 20),
        //       ElevatedButton(
        //         onPressed: _handleSubmit,
        //         child: Text('Submit'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
