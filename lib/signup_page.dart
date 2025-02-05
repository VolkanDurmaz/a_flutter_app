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
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters long.')),
      );
      return;
    }

    bool isValidEmail(String email) {
      return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.sendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Sign Up Successful! Please check your email for verification.')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for this email.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  // void signUp() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       UserCredential userCredential =
  //           await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: _emailController.text,
  //         password: _passwordController.text,
  //       );

  //       // Mail Verification

  //       if (userCredential.user != null) {
  //         await userCredential.user!.sendEmailVerification();

  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //                 content: Text(
  //                     'Sign Up Successful! Please check your email for verification.')),
  //           );
  //           Navigator.pop(context);
  //         }
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       if (_passwordController.text.length < 6) {
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //                 content:
  //                     Text('Password must be at least 6 characters long.')),
  //           );
  //         }
  //         return;
  //       }
  //       if (e.code == 'email-already-in-use') {
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //                 content: Text('An account already exists for this email.')),
  //           );
  //         }
  //       }
  //       bool isValidEmail(String email) {
  //         return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  //       }

  //       if (!isValidEmail(_emailController.text)) {
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Please enter a valid email address.')),
  //           );
  //         }
  //         return;
  //       }
  //     }
  //   }
  // }

  void resendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            color: const Color.fromARGB(255, 63, 55, 55).withValues(alpha: 0.5),
          ),

          // Logo
          Positioned(
            top: screenHeight * 0.05, // 5% from the top
            left: screenWidth * 0.1, // 10% from the left
            right: screenWidth * 0.1, // 10% from the right
            child: AspectRatio(
              aspectRatio: 16 / 9, // Maintain aspect ratio
              child: Image.asset('images/logo.png'),
            ),
          ),

          // Motto
          Positioned(
            top: screenHeight * 0.25, // 25% from the top
            left: screenWidth * 0.1, // 10% from the left
            right: screenWidth * 0.1, // 10% from the right
            child: Text(
              'What are we doing\n on Sunday?',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.06, // 6% of screen width
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Sign Up Form
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: screenHeight * 0.3, // 30% from the top
                left: screenWidth * 0.1, // 10% padding
                right: screenWidth * 0.1, // 10% padding
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Email TextField
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.8),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% spacing

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.8),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% spacing

                    // Confirm Password TextField
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.8),
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

                    SizedBox(height: screenHeight * 0.03), // 3% spacing

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 226, 176, 59),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.3, // 30% of screen width
                          vertical: screenHeight * 0.02, // 2% of screen height
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: screenWidth * 0.04, // 4% of screen width
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02), // 2% spacing

                    // Login Button
                    TextButton(
                      onPressed: widget.showLoginPage,
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04, // 4% of screen width
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
