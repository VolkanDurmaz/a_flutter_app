import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'home.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn() async {
    //loading...
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.orangeAccent,
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //   },
    // );

    try {
      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      String errorMessage = 'Email or password are incorrect.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            color: const Color.fromARGB(255, 63, 55, 55).withOpacity(0.5),
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
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Logo
                    // Image.asset(
                    //   'images/logo.png',
                    //   height: 200,
                    // ),
                    // SizedBox(height: 50.0),
                    Text(
                      'What are we doing\n on Sunday?',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),

                    // Email TextField
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                        fillColor: Colors.white.withOpacity(0.8),
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

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
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
                      style: TextStyle(color: Colors.black), // Text color
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 1.0),

                    //Forgot Password
                    TextButton(
                      onPressed: () {
                        // Navigate to the Forgot Password Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Your Password?',
                          // textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color.fromARGB(255, 69, 183, 225),
                          ),
                        ),
                      ),
                    ),
                    // Login Button
                    ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 226, 176, 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),

                    // Sign Up Button
                    TextButton(
                      onPressed: widget.showRegisterPage,
                      // onPressed: () {
                      //   // Navigate to the Sign Up Page
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => SignUpPage()),
                      //   );
                      // },
                      child: Text(
                        'Don\'t have an account? Sign up',
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
