import 'package:dev_sample_app/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  final bool isLoggedIn;

  LandingScreen({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? HomeScreen() : LoginPage();
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebEngage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement login logic
            // Once the user is logged in, navigate to the Home Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
