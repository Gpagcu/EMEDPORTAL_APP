import 'package:flutter/material.dart';
import 'patient_drawer.dart';

class PatientUserInfoScreen extends StatelessWidget {
  const PatientUserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy patient info
    final patient = {
      'name': 'Jane Doe',
      'email': 'jane.doe@email.com',
      'age': 28,
      'gender': 'Female',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      drawer: const PatientDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(patient['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Email: ${patient['email'] as String}'),
                const SizedBox(height: 4),
                Text('Age: ${(patient['age'] as int).toString()}'),
                const SizedBox(height: 4),
                Text('Gender: ${patient['gender'] as String}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
