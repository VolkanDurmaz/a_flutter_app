import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({super.key, required this.showLoginPage});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );

    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Mail Verification
        await userCredential.user!.sendEmailVerification();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Sign Up Successful')),
        // );

        if (userCredential.user != null) {
          await userCredential.user!.sendEmailVerification();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Sign Up Successful! Please check your email for verification.')),
            );
            Navigator.pop(context);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (_passwordController.text.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Password must be at least 6 characters long.')),
          );
          return;
        }
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('An account already exists for this email.')),
          );
        }
        bool isValidEmail(String email) {
          return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
        }

        if (!isValidEmail(_emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter a valid email address.')),
          );
          return;
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Sign Up Failed: ${e.toString()}')),
        // );
      }
    }
  }

  void resendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Semi-transparent Overlay
          Container(
            color: const Color.fromARGB(255, 63, 55, 55).withOpacity(0.5),
          ),
          Positioned(
              top: 70,
              left: 30,
              right: 30,
              child: Image.asset('images/logo.png', height: 200)),
          Positioned(
            top: 225,
            left: 30,
            right: 30,
            child: Text(
              'What are we doing\n on Sunday?',
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          // Sign Up Form

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 110, left: 32, right: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Add your logo or other widgets here
                    // Image.asset('images/logo.png', height: 200),
                    // SizedBox(height: 50.0),

                    // Text(
                    //   'What are we doing\n on Sunday?',
                    //   style: TextStyle(color: Colors.white, fontSize: 25),
                    //   textAlign: TextAlign.center,
                    // ),
                    SizedBox(height: 50.0),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      style: TextStyle(color: Colors.black),
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
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter password',
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
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
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
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 226, 176, 59),
                        padding:
                            EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                      ),
                      child: Text('Sign Up',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255))),
                    ),

                    // TextButton(
                    //   onPressed: resendVerificationEmail,
                    //   child: Text(
                    //     'Resend Verification Email',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),

                    TextButton(
                      onPressed: widget.showLoginPage,
                      // onPressed: () {
                      //   // Navigate back to the login page
                      //   Navigator.pop(context);
                      // },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
