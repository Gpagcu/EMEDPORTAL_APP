import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';
import 'patient_drawer.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Jane Doe');
  final _emailCtrl = TextEditingController(text: 'jane@gmail.com');
  final _phoneCtrl = TextEditingController(text: '+63 9123456789');
  final _birthCtrl = TextEditingController(text: '01-01-1990');
  String _gender = 'Male';
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _birthCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('EmedPortal'),
        actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})],
      ),
      drawer: const PatientDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // blue header
          Container(
            height: 56,
            decoration: BoxDecoration(color: primary, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const Text('User Information', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(height: 12),

          // profile image
          Center(child: CircleAvatar(radius: 48, backgroundColor: Colors.grey.shade300, child: const Text('IMAGE'))),
          const SizedBox(height: 12),

          Form(
            key: _formKey,
            child: Column(children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Text('Personal Data', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                    const SizedBox(height: 8),
                    TextFormField(controller: _birthCtrl, readOnly: true, decoration: InputDecoration(labelText: 'Birthdate', suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: () async {
                      final d = await showDatePicker(context: context, initialDate: DateTime(1990), firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (d != null) _birthCtrl.text = '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}-${d.year}';
                    }))),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(value: _gender, items: const [DropdownMenuItem(value: 'Female', child: Text('Female')), DropdownMenuItem(value: 'Male', child: Text('Male')), DropdownMenuItem(value: 'Other', child: Text('Other'))], onChanged: (v) => setState(() => _gender = v ?? 'Female'), decoration: const InputDecoration(labelText: 'Gender')),
                    const SizedBox(height: 8),
                    TextFormField(controller: TextEditingController(), obscureText: _obscure, decoration: InputDecoration(labelText: 'Password', suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)))),
                  ]),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Text('Contact Info', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
                    const SizedBox(height: 8),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                  ]),
                ),
              ),

              const SizedBox(height: 12),

              Row(children: [Expanded(child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/medicationHistory'), child: const Text('Medication History'))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/patientInventory'), child: const Text('Patient Inventory')))]),

              const SizedBox(height: 12),

              // Needed Medications
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Text('Needed Medications', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: MockRepository.instance.neededMedications,
                      builder: (context, meds, _) {
                        return Column(children: meds.map((m) => ListTile(
                              title: Text('${m['name']} ${m['dosage']}'),
                              subtitle: Text('${m['frequency']}'),
                              trailing: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/medicationReminder', arguments: m), child: const Text('Add Reminder')),
                            )).toList());
                      },
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/login')), child: const Text('Log out')),
            ]),
          )
        ]),
      ),
    );
  }
}
// end
