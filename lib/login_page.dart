import 'package:flutter/material.dart';
import 'signup_page.dart'; // Import the Sign Up Page
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, Key? key_});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Perform login action
      String email = _emailController.text;
      String password = _passwordController.text;

      // Here you can add your authentication logic
      print('Email: $email');
      print('Password: $password');

      // Navigate to the next screen or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //     title: Text('Welcome'),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
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
          // Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Add your logo or other widgets here
                    Image.asset(
                      'images/logo.png',
                      height: 100,
                    ),
                    SizedBox(height: 50.0),
                    Text(
                      'What are we doing\n on Sunday?',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: WidgetStateTextStyle.resolveWith(
                          (Set<WidgetState> states) {
                            final Color color =
                                states.contains(WidgetState.error)
                                    ? Theme.of(context).colorScheme.error
                                    : const Color.fromARGB(255, 20, 19, 17);
                            return TextStyle(color: color, letterSpacing: 1.3);
                          },
                        ),
                        border: OutlineInputBorder(),
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
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: WidgetStateTextStyle.resolveWith(
                          (Set<WidgetState> states) {
                            final Color color =
                                states.contains(WidgetState.error)
                                    ? Theme.of(context).colorScheme.error
                                    : const Color.fromARGB(255, 20, 19, 17);
                            return TextStyle(color: color, letterSpacing: 1.3);
                          },
                        ),
                        border: OutlineInputBorder(),
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
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      //onPressed: _login,
                      onPressed: () {
                        // Perform login logic here
                        // For now, just navigate to the home page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 226, 176, 59),
                        padding:
                            EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                      ),
                      child: Text('Login',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255))),
                    ),
                    SizedBox(height: 2.0),
                    TextButton(
                      onPressed: () {
                        // Navigate to the Sign Up Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
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
