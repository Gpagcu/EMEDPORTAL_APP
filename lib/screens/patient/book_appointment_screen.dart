import 'package:flutter/material.dart';
import 'patient_drawer.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _symptomsCtrl = TextEditingController();
  String _priority = 'Normal';
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _contactCtrl.dispose();
    _symptomsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final appointment = {
      'patient': _nameCtrl.text.trim(),
      'age': int.tryParse(_ageCtrl.text) ?? 0,
      'contact': _contactCtrl.text.trim(),
      'symptoms': _symptomsCtrl.text.trim(),
      'priority': _priority,
      'date': _date?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'time': _time != null ? '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}' : '',
    };
    Navigator.pushNamed(context, '/appointmentConfirmation', arguments: appointment);
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context)), title: const Text('EmedPortal'), actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})]),
      drawer: const PatientDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Book Appointment', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Patient Name'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _ageCtrl, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _contactCtrl, decoration: const InputDecoration(labelText: 'Contact'), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _symptomsCtrl, decoration: const InputDecoration(labelText: 'Symptoms'), maxLines: 3, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(value: _priority, items: ['Normal', 'Urgent', 'Emergency'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => setState(() => _priority = v ?? 'Normal'), decoration: const InputDecoration(labelText: 'Priority')),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Date', suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate)),
                    controller: TextEditingController(text: _date == null ? '' : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Time', suffixIcon: IconButton(icon: const Icon(Icons.access_time), onPressed: _pickTime)),
                    controller: TextEditingController(text: _time == null ? '' : _time!.format(context)),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
