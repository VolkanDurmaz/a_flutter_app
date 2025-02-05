import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! Check your Email'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  e.message.toString(),
                ),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent Overlay
          Container(
            color: const Color.fromARGB(255, 63, 55, 55).withValues(alpha: 0.5),
          ),
          Positioned(
              top: 70,
              left: 30,
              right: 30,
              child: Image.asset('images/logo.png', height: 200)),
          // Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'What are we doing\n on Sunday?',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),

                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle:
                            TextStyle(color: Colors.grey), // Hint text color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color: Colors.yellow,
                              width: 2.0), // Active border color
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.8),
                      ),
                      style: TextStyle(color: Colors.black), // Text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),

                    // Reset Button
                    ElevatedButton(
                      onPressed: passwordReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 226, 176, 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
