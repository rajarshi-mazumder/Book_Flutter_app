import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/authentication/signin_page.dart';
import 'package:book_frontend/views/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';

class SilentSignInPage extends StatefulWidget {
  const SilentSignInPage({super.key});

  @override
  _SilentSignInPageState createState() => _SilentSignInPageState();
}

class _SilentSignInPageState extends State<SilentSignInPage> {
  @override
  void initState() {
    super.initState();
    _attemptSilentLogin();
  }

  void _attemptSilentLogin() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.silentLogin();
    _navigateBasedOnLoginStatus(userProvider.isLoggedIn);
  }

  void _navigateBasedOnLoginStatus(bool isLoggedIn) {
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ), // Show a loading indicator while attempting silent login
      ),
    );
  }
}
