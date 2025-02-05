import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'events/create_event.dart';
import 'auth/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'events/event_list_page.dart';
import 'users/user_profile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        await _auth.signOut();
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } // Sign out the user
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to log out: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to UserProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventListPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Call the logout function
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Henüz etkinlik yok.'));
          }

          var events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index].data() as Map<String, dynamic>;

              String title = event.containsKey('name')
                  ? event['name']
                  : "Bilinmeyen Etkinlik";
              dynamic date = event.containsKey('date') ? event['date'] : null;

              String formattedDate = "Tarih bilgisi yok";
              if (date != null) {
                if (date is Timestamp) {
                  formattedDate =
                      "Tarih: ${date.toDate()}"; // Eğer Timestamp ise direkt çevir
                } else if (date is String) {
                  try {
                    formattedDate =
                        "Tarih: ${DateTime.parse(date)}"; // Eğer String ise DateTime'a çevir
                  } catch (e) {
                    formattedDate = "Geçersiz tarih formatı";
                  }
                }
              }

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: ListTile(
                  title: Text(title, style: TextStyle(fontSize: 18)),
                  subtitle: Text(formattedDate),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreationPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
