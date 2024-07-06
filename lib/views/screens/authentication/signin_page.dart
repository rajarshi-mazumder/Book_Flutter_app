import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/services/auth_services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      AuthService.login(email, password);
    }
  }

  void _silentLogin({required UserProvider userProvider}) {
    userProvider.silentLogin();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? userInfo;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(userProvider.user.toString()),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    // obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () => _silentLogin(userProvider: userProvider),
                    child: Text('Silent loginn'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
