import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_event.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lastest Events')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index].data();
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(event['name']),
                  subtitle: Text(
                      '${event['date']} at ${event['time']}\n${event['location']}\n${event['category']}'),
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
