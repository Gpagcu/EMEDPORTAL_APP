import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../data/mock_repository.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final primary = const Color(0xFF1976D2);

  DateTime selectedDate = DateTime.now();
  String? filterDoctorId;

  bool _isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
  // filter or use selection as needed when rendering; selectedDate is used below

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('doctorId')) {
      filterDoctorId = args['doctorId'] as String;
    }

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(title: const Text('Schedule')),
      body: Column(
        children: [
          // Tab Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {}, // already on schedules
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Text('Schedules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/doctorsList'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: primary)),
                      child: Center(child: Text('Available Doctors', style: TextStyle(color: primary, fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Calendar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                currentDate: DateTime.now(),
                onDateChanged: (d) => setState(() => selectedDate = d),
              ),
            ),
          ),

          // Main Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    // Blue header
                    Container(
                      height: 48,
                      decoration: BoxDecoration(color: primary, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                      child: const Center(child: Text('Schedules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                    ),

                    // List
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                          valueListenable: MockRepository.instance.appointments,
                          builder: (context, appointments, _) {
                            final list = filterDoctorId == null
                                ? appointments
                                : appointments.where((a) => a['doctorId'] == filterDoctorId).toList();
                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final appt = list[index];
                                final apptDate = appt['datetime'] as DateTime;
                                final isSelected = _isSameDate(apptDate, selectedDate);
                                return GestureDetector(
                                  // tap now opens the edit modal (same as Edit button); long-press kept for compatibility
                                  onTap: () async {
                                    await _openEditAppointmentModal(context, appt);
                                    setState(() {});
                                  },
                                  child: InkWell(
                                    onLongPress: () async {
                                      // open edit modal for this appointment as well
                                      await _openEditAppointmentModal(context, appt);
                                      setState(() {});
                                    },
                                    child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? primary.withOpacity(0.2) : primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: isSelected ? Border.all(color: primary, width: 1.5) : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text('Patient Name: ${appt['patient']}', style: const TextStyle(fontWeight: FontWeight.bold))),
                                            Text('#${appt['queue']}', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text('Priority: ${appt['priority']}', style: const TextStyle(color: Colors.red)),
                                        const SizedBox(height: 6),
                                        Text('Date & Time: ${_formatDateTime(apptDate)}'),
                                        const SizedBox(height: 6),
                                        Text('Symptoms: ${appt['symptoms']}'),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                await _openEditAppointmentModal(context, appt);
                                              },
                                              child: const Text('Edit'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    // Simple formatter
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

  Future<void> _openEditAppointmentModal(BuildContext context, Map<String, dynamic> appt) async {
    final patientController = TextEditingController(text: appt['patient'] as String? ?? '');
    String priority = appt['priority'] as String? ?? 'Normal';
    final symptomsController = TextEditingController(text: appt['symptoms'] as String? ?? '');
    DateTime dt = appt['datetime'] as DateTime;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Edit Appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextFormField(controller: patientController, decoration: InputDecoration(labelText: 'Patient Name', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: const [DropdownMenuItem(value: 'Urgent', child: Text('Urgent')), DropdownMenuItem(value: 'Normal', child: Text('Normal'))],
                  onChanged: (v) => priority = v ?? priority,
                  decoration: InputDecoration(labelText: 'Priority', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                TextFormField(controller: symptomsController, maxLines: 3, decoration: InputDecoration(labelText: 'Symptoms', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () async {
                          final newDate = await showDatePicker(context: context, initialDate: dt, firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (newDate != null) {
                            dt = DateTime(newDate.year, newDate.month, newDate.day, dt.hour, dt.minute);
                          }
                        },
                        child: Text('Date: ${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(dt));
                          if (t != null) dt = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
                        },
                        child: Text('Time: ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}')),
                  ),
                ]),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                      onPressed: () {
                        final updated = Map.of(appt);
                        updated['patient'] = patientController.text;
                        updated['priority'] = priority;
                        updated['symptoms'] = symptomsController.text;
                        updated['datetime'] = dt;
                        MockRepository.instance.updateAppointment(appt['id'] as String, updated);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Save'))
                ])
              ],
            ),
          ),
        );
      },
    );
  }
}
