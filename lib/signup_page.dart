import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-up action
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      // Here you can add your sign-up logic
      print('Name: $name');
      print('Email: $email');
      print('Password: $password');

      // Navigate back to the login page or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up Successful')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign Up'),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
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
          // Sign Up Form
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
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
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
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
                      onPressed: _signUp,
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

                    TextButton(
                      onPressed: () {
                        // Navigate back to the login page
                        Navigator.pop(context);
                      },
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
