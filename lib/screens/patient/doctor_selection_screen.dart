import 'package:flutter/material.dart';
import 'patient_drawer.dart';

class DoctorSelectionScreen extends StatelessWidget {
  const DoctorSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {'name': 'Dr. Smith', 'specialty': 'Cardiology'},
      {'name': 'Dr. Lee', 'specialty': 'Dermatology'},
      {'name': 'Dr. Patel', 'specialty': 'Pediatrics'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Select Doctor')),
      drawer: const PatientDrawer(),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(doc['name']!),
              subtitle: Text(doc['specialty']!),
              onTap: () {
                Navigator.pushNamed(context, '/appointmentConfirmation', arguments: {
                  'doctorName': doc['name'],
                  'specialty': doc['specialty'],
                });
              },
            ),
          );
        },
      ),
    );
  }
}
