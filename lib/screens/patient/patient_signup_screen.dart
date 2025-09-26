import 'package:flutter/material.dart';
import 'patient_login_signup_screen.dart';

class PatientSignUpScreen extends StatelessWidget {
  const PatientSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect to the combined login/signup screen and open in sign-up mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PatientLoginSignUpScreen(initialSignUp: true),
        ),
      );
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
