import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/home.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isEmailVerified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    setState(() {
      _isLoading = true;
    });

    // Reload the user to get the latest email verification status
    await _user?.reload();
    _user = _auth.currentUser;

    setState(() {
      _isEmailVerified = _user?.emailVerified ?? false;
      _isLoading = false;
    });

    if (_isEmailVerified) {
      // Navigate to the homepage if email is verified
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _user?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification email: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please verify your email address.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendVerificationEmail,
                    child: Text('Resend Verification Email'),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkEmailVerification,
              child: Text('Check Verification Status'),
            ),
          ],
        ),
      ),
    );
  }
}
