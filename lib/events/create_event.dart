import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});
  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;
  String? _selectedTime;
  int? _selectedDuration;

  final List<String> _categories = ['Playing', 'Riding', 'Walking', 'Drinking'];
  final List<String> _times = ['10:00 AM', '12:00 PM', '02:00 PM', '04:00 PM'];
  final List<int> _durations = [1, 2, 3, 4, 5];

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_eventNameController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedDuration == null ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    await FirebaseFirestore.instance.collection('events').add({
      'name': _eventNameController.text,
      'category': _selectedCategory,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      'time': _selectedTime,
      'location': _locationController.text,
      'duration': _selectedDuration,
      'description': _descriptionController.text,
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),
              DropdownButtonFormField<String>(
                value: _selectedTime,
                decoration: InputDecoration(labelText: 'Time'),
                items: _times
                    .map((time) =>
                        DropdownMenuItem(value: time, child: Text(time)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTime = value),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              DropdownButtonFormField<int>(
                value: _selectedDuration,
                decoration: InputDecoration(labelText: 'Duration (hours)'),
                items: _durations
                    .map((duration) => DropdownMenuItem(
                        value: duration, child: Text('$duration hours')))
                    .toList(),
                onChanged: (value) => setState(() => _selectedDuration = value),
              ),
              TextField(
                controller: _descriptionController,
                maxLength: 200,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
