import 'package:flutter/material.dart';
import 'patient_drawer.dart';

class MedicationHistoryScreen extends StatelessWidget {
  const MedicationHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // sample logs grouped by date
    final logs = [
      {'name': 'Paracetamol', 'dosage': '500mg', 'date': DateTime(2025, 9, 1), 'status': 'Taken', 'note': 'After meal'},
      {'name': 'Ibuprofen', 'dosage': '400mg', 'date': DateTime(2025, 9, 1), 'status': 'Missed', 'note': ''},
      {'name': 'Amoxicillin', 'dosage': '250mg', 'date': DateTime(2025, 8, 15), 'status': 'Late', 'note': 'Traffic'},
    ];

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var l in logs) {
      final date = l['date'] as DateTime;
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(l);
    }

    Color statusColor(String s) {
      switch (s) {
        case 'Taken':
          return Colors.green;
        case 'Missed':
          return Colors.red;
        case 'Skipped':
          return Colors.orange;
        case 'Late':
          return Colors.amber;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context)), title: const Text('Medication History')),
      drawer: const PatientDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((e) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...e.value.map((entry) {
              final status = entry['status'] as String; 
              return Card(
                child: ListTile(
                  title: Text('${entry['name']} ${entry['dosage']}'),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Status: $status', style: TextStyle(color: statusColor(status))), if ((entry['note'] as String).isNotEmpty) Text('Note: ${entry['note']}')]),
                ),
              );
            })
          ]);
        }).toList(),
      ),
    );
  }
}
