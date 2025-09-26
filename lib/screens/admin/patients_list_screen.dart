import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';
import 'patient_details_screen.dart';
import 'admin_drawer.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({Key? key}) : super(key: key);

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  final primary = const Color(0xFF1976D2);

  List<Map<String, dynamic>> patients = [
    {'id': '1', 'name': 'Jane Doe', 'age': 28, 'contact': '0917-123-4567'},
    {'id': '2', 'name': 'John Smith', 'age': 35, 'contact': '0917-555-8888'},
  ];

  bool showActiveOnly = false;

  void _loadPatientsFromAppointments() {
    final appts = MockRepository.instance.appointments.value.where((a) => (a['resolved'] as bool? ?? false) == false).toList();
    final names = appts.map((a) => a['patient'] as String).toSet();
    final List<Map<String, dynamic>> built = [];
    for (final n in names) {
      final existing = patients.firstWhere((p) => p['name'] == n, orElse: () => {});
      if (existing.isNotEmpty) {
        built.add(existing);
      } else {
        built.add({'id': 'p_${n.hashCode}', 'name': n, 'age': null, 'contact': ''});
      }
    }
    setState(() => patients = built);
  }

  Future<void> _onViewOrEdit(int index) async {
    final selected = Map<String, dynamic>.from(patients[index]);
    final updated = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => PatientDetailsScreen(patient: selected)),
    );
    if (updated != null) {
      setState(() {
        final i = patients.indexWhere((p) => p['id'] == updated['id']);
        if (i >= 0) {
          patients[i] = updated;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['activeOnly'] == true) {
      showActiveOnly = true;
      _loadPatientsFromAppointments();
    }
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Med - Admin'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search)), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue header
            Container(
              height: 48,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Patients', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            ),

            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return InkWell(
                  onTap: () => _onViewOrEdit(index),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(patient['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text('Age: ${patient['age'] ?? 'N/A'}'),
                                const SizedBox(height: 4),
                                Text('Contact: ${patient['contact'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                onPressed: () => _onViewOrEdit(index),
                              ),
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _onViewOrEdit(index)),
                              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
