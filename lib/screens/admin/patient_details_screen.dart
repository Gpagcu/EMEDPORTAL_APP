import 'package:flutter/material.dart';
import 'admin_drawer.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;
  const PatientDetailsScreen({Key? key, this.patient}) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  late Map<String, dynamic> p;

  @override
  void initState() {
    super.initState();
    p = widget.patient != null ? Map.of(widget.patient!) : {'id': '0', 'name': 'Unknown', 'age': 0, 'contact': 'N/A'};
  }

  void _openEditSheet() {
    final nameController = TextEditingController(text: p['name'] as String);
    final ageController = TextEditingController(text: (p['age'] ?? '').toString());
    final contactController = TextEditingController(text: p['contact'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
              TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact')),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        p['name'] = nameController.text;
                        p['age'] = int.tryParse(ageController.text) ?? p['age'];
                        p['contact'] = contactController.text;
                      });
                      Navigator.pop(ctx);
                      Navigator.pop(context, p); // return updated patient
                    },
                    child: const Text('Save'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'taken':
        return Colors.green;
      case 'missed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);

    final medicalHistory = [
      {'datetime': DateTime(2025, 8, 20, 9, 0), 'med': 'Paracetamol', 'status': 'Taken'},
      {'datetime': DateTime(2025, 8, 21, 9, 0), 'med': 'Amoxicillin', 'status': 'Missed'},
      {'datetime': DateTime(2025, 8, 22, 9, 0), 'med': 'Vitamin D', 'status': 'Skipped'},
    ];

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(title: const Text('Med - Admin'), leading: BackButton(), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Blue header
              Container(
                height: 48,
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Patient Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Age: ${p['age'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Contact: ${p['contact'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.edit), onPressed: _openEditSheet),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // History
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...medicalHistory.map((h) {
                        final dt = h['datetime'] as DateTime;
                        final status = h['status'] as String;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${_formatDateTime(dt)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(h['med'] as String),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    status.toLowerCase() == 'taken'
                                        ? Icons.check_circle
                                        : status.toLowerCase() == 'missed'
                                            ? Icons.cancel
                                            : Icons.remove_circle,
                                    color: statusColor(status),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(status, style: TextStyle(color: statusColor(status), fontWeight: FontWeight.w600)),
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final month = months[dt.month - 1];
    final day = dt.day;
    final year = dt.year;
    int hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '$month $day, $year - $hour:${minute} $ampm';
  }
}
