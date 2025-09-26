import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  TimeOfDay? _start;
  TimeOfDay? _end;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 9, minute: 0));
    if (t != null) setState(() => _start = t);
  }

  Future<void> _pickEnd() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 17, minute: 0));
    if (t != null) setState(() => _end = t);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final doc = {
      'id': id,
      'name': _nameCtrl.text.trim(),
      'specialty': _specCtrl.text.trim(),
      'availStart': _start,
      'availEnd': _end,
      'notes': '',
    };
    MockRepository.instance.addDoctor(doc);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Doctor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: 'Doctor Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter doctor name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _specCtrl,
                decoration: InputDecoration(labelText: 'Specialty', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter specialty' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickStart,
                      child: Text(_start == null ? 'Availability Start Time' : 'Start: \\${MockRepository.formatTimeOfDay(_start!)}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickEnd,
                      child: Text(_end == null ? 'Availability End Time' : 'End: \\${MockRepository.formatTimeOfDay(_end!)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Doctor', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
