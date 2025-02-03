import 'package:app/auth/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

String getTime() {
  String hours = DateTime.now().hour.toString().padLeft(2, '0');
  String minutes = DateTime.now().minute.toString().padLeft(2, '0');
  String seconds = DateTime.now().second.toString().padLeft(2, '0');
  String currentTime = '$hours:$minutes:$seconds';
  return currentTime;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'What time is it?',
      theme: ThemeData.dark().copyWith(
        // Update the dark theme
        primaryColor: Colors.blueGrey, // Update the primary color
      ),
      home: const MyHomePage(title: 'What time is it?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, Key? key_, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String timeVar = getTime();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _incrementCounter);
  }

  void _incrementCounter(Timer timer) {
    setState(() {
      timeVar = getTime();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future _logout(BuildContext context) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmLogout == true) {
      try {
        await _auth.signOut(); // Sign out the user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email!),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Call the logout function
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              timeVar,
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
