import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/home.dart';
import '/login_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  // initially,show the LogIn Page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user != null) {
            if (user.emailVerified) {
              // Email is verified, allow access to the home page
              return HomePage();
            } else {
              // Email is not verified, show a message
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Please verify your email to continue.'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await user.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Verification email sent!')),
                          );
                        },
                        child: Text('Resend Verification Email'),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(showRegisterPage: toggleScreens)),
                          );
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            // User is not logged in, redirect to login page
            return LoginPage(showRegisterPage: toggleScreens);
          }
        } else {
          // Show a loading indicator
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
