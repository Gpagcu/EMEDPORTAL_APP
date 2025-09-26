import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';
import 'patient_drawer.dart';

class MedicationReminderScreen extends StatefulWidget {
  final Map<String, dynamic>? prefill;
  const MedicationReminderScreen({Key? key, this.prefill}) : super(key: key);

  @override
  State<MedicationReminderScreen> createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  TimeOfDay? _time;
  DateTime? _date;
  String _frequency = 'Once';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.prefill != null) {
      _nameCtrl.text = widget.prefill!['name'] ?? '';
      _dosageCtrl.text = widget.prefill!['dosage'] ?? '';
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: now.add(const Duration(days: 365)));
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final reminder = {
      'id': id,
      'name': _nameCtrl.text.trim(),
      'dosage': _dosageCtrl.text.trim(),
      'date': _date ?? DateTime.now(),
      'time': _time != null ? '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}' : '',
      'frequency': _frequency,
      'status': 'upcoming'
    };
    MockRepository.instance.addReminder(reminder);
    Navigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Reminder Setup')),
      drawer: const PatientDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Medication Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter medication name' : null,
              ),
              TextFormField(
                controller: _dosageCtrl,
                decoration: const InputDecoration(labelText: 'Dosage'),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Text(_date == null ? 'No date chosen' : 'Date: ${_date!.toLocal().toIso8601String().split('T').first}')),
                TextButton(onPressed: _pickDate, child: const Text('Pick Date'))
              ]),
              Row(children: [
                Expanded(child: Text(_time == null ? 'No time chosen' : 'Time: ${_time!.format(context)}')),
                TextButton(onPressed: _pickTime, child: const Text('Pick Time'))
              ]),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _frequency,
                items: ['Once', 'Daily', 'Weekly', 'Monthly'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => setState(() => _frequency = v ?? 'Once'),
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: const Text('Set Reminder'))
            ],
          ),
        ),
      ),
    );
  }
}
