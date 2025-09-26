import 'package:flutter/material.dart';
import 'patient_drawer.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  const AppointmentConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final appointment = args ?? {};
    final patient = appointment['patient'] ?? 'N/A';
    final age = appointment['age']?.toString() ?? 'N/A';
    final contact = appointment['contact'] ?? 'N/A';
    final symptoms = appointment['symptoms'] ?? 'N/A';
    final priority = appointment['priority'] ?? 'N/A';
    final date = appointment['date'] != null ? DateTime.parse(appointment['date']).toLocal().toString().split(' ')[0] : 'N/A';
    final time = appointment['time'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context)), title: const Text('EmedPortal'), actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})]),
      drawer: const PatientDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Appointment Confirmed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Patient: $patient'),
                Text('Age: $age'),
                Text('Contact: $contact'),
                Text('Symptoms: $symptoms'),
                Text('Priority: $priority'),
                Text('Date: $date'),
                Text('Time: $time'),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/patientDashboard');
            },
            child: const Text('Home Page'),
          )
        ]),
      ),
    );
  }
}
