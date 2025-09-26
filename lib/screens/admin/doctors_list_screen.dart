import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../data/mock_repository.dart';

class DoctorsListScreen extends StatelessWidget {
  const DoctorsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(title: const Text('Med - Admin')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Doctor',
        onPressed: () => Navigator.pushNamed(context, '/addDoctorScreen'),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tab Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/schedule'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primary),
                        ),
                        child: Center(
                          child: Text(
                            'Schedules',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {}, // already on doctors
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Available Doctors',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Blue header
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Available Doctors',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    // List
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                        valueListenable: MockRepository.instance.doctors,
                        builder: (context, doctors, _) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: doctors.length,
                            itemBuilder: (context, index) {
                              final d = doctors[index];
                              final start = (d['availStart'] as TimeOfDay?);
                              final end = (d['availEnd'] as TimeOfDay?);
                              final availText = start != null && end != null
                                  ? '${MockRepository.formatTimeOfDay(start)} - ${MockRepository.formatTimeOfDay(end)}'
                                  : 'N/A';
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  d['name'] as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(d['specialty'] as String),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Availability: $availText',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/schedule',
                                                      arguments: {
                                                        'doctorId': d['id'],
                                                      },
                                                    ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Reschedule',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    _openEditModal(context, d),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  minimumSize: const Size(
                                                    120,
                                                    44,
                                                  ),
                                                ),
                                                child: const Text('Edit'),
                                              ),
                                              const SizedBox(height: 8),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () => MockRepository
                                                    .instance
                                                    .deleteDoctor(
                                                      d['id'] as String,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditModal(BuildContext context, Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final nameController = TextEditingController(
          text: doctor['name'] as String,
        );
        final specController = TextEditingController(
          text: doctor['specialty'] as String,
        );
        TimeOfDay start =
            doctor['availStart'] as TimeOfDay? ??
            const TimeOfDay(hour: 9, minute: 0);
        TimeOfDay end =
            doctor['availEnd'] as TimeOfDay? ??
            const TimeOfDay(hour: 17, minute: 0);
        final notesController = TextEditingController(
          text: doctor['notes'] as String? ?? '',
        );

        return StatefulBuilder(
          builder: (context, setModalState) {
            final appts = MockRepository.instance.getAppointmentsForDoctor(
              doctor['id'] as String,
            );
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit Doctor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Doctor Name',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: specController,
                      decoration: InputDecoration(
                        labelText: 'Specialization',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: context,
                                initialTime: start,
                              );
                              if (t != null) setModalState(() => start = t);
                            },
                            child: Text(
                              'Start: ${MockRepository.formatTimeOfDay(start)}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: context,
                                initialTime: end,
                              );
                              if (t != null) setModalState(() => end = t);
                            },
                            child: Text(
                              'End: ${MockRepository.formatTimeOfDay(end)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rescheduling section
                    const Text(
                      'Appointments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...appts.map((a) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a['patient'] as String),
                                    Text(
                                      _formatDateTime(
                                        a['datetime'] as DateTime,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final newDate = await showDatePicker(
                                    context: context,
                                    initialDate: a['datetime'] as DateTime,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (newDate == null) return;
                                  final newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      a['datetime'] as DateTime,
                                    ),
                                  );
                                  if (newTime == null) return;
                                  final newDt = DateTime(
                                    newDate.year,
                                    newDate.month,
                                    newDate.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                  MockRepository.instance.rescheduleAppointment(
                                    a['id'] as String,
                                    newDt,
                                  );
                                  setModalState(() {});
                                },
                                child: const Text('Reschedule'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final updated = Map.of(doctor);
                            updated['name'] = nameController.text;
                            updated['specialty'] = specController.text;
                            updated['availStart'] = start;
                            updated['availEnd'] = end;
                            updated['notes'] = notesController.text;
                            MockRepository.instance.updateDoctor(
                              doctor['id'] as String,
                              updated,
                            );
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
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
