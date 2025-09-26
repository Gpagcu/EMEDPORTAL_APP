import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';
import 'patient_drawer.dart';

class PatientsDashboardScreen extends StatelessWidget {
  const PatientsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('EmedPortal'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: const PatientDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MockRepository.instance.reminders,
              builder: (context, reminders, _) {
                if (reminders.isEmpty) return const SizedBox.shrink();
                // pick the first upcoming reminder
                final reminder = reminders.firstWhere(
                  (r) => r['status'] == 'upcoming',
                  orElse: () => {},
                );
                if (reminder.isEmpty) return const SizedBox.shrink();
                return Card(
                  color: Colors.yellow.shade50,
                  child: ListTile(
                    title: Text('Reminder: ${reminder['name']}'),
                    subtitle: Text('Time: ${reminder['time']}'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Snooze: push time by 10 minutes
                            final idx = MockRepository.instance.reminders.value
                                .indexWhere((r) => r['id'] == reminder['id']);
                            if (idx >= 0) {
                              final list = List.of(
                                MockRepository.instance.reminders.value,
                              );
                              final updated = Map.of(list[idx]);
                              if (updated['date'] is DateTime)
                                updated['date'] = (updated['date'] as DateTime)
                                    .add(const Duration(minutes: 10));
                              list[idx] = updated;
                              MockRepository.instance.reminders.value = list;
                            }
                          },
                          child: const Text('Snooze'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Mark as taken -> remove
                            if (reminder['id'] != null)
                              MockRepository.instance.removeReminder(
                                reminder['id'],
                              );
                          },
                          child: const Text('Mark as Taken'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to EMedPortal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Comprehensive Healthcare Management System',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(140, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/bookAppointment'),
                        child: const Text('Book Appointment'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(140, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/patientProfile'),
                        child: const Text('Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Queue status (uses same appointments data source)
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MockRepository.instance.appointments,
              builder: (context, appts, _) {
                final active = appts
                    .where((a) => (a['resolved'] as bool? ?? false) == false)
                    .toList();
                // assume queue is sorted by 'queue' field
                active.sort(
                  (a, b) => (a['queue'] as int).compareTo(b['queue'] as int),
                );
                final current = active.isNotEmpty ? active.first : null;
                final waiting = active.length - (current != null ? 1 : 0);
                final onSite = active
                    .where(
                      (a) => (a['datetime'] as DateTime).isBefore(
                        DateTime.now().add(const Duration(hours: 2)),
                      ),
                    )
                    .length;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Queue Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (current != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#${current['queue']} Serving',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (current['priority'] == 'Urgent')
                                      ? Colors.red.shade100
                                      : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  current['priority'] ?? 'Normal',
                                  style: TextStyle(
                                    color: (current['priority'] == 'Urgent')
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Patient: ${current['patient']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text('Condition: ${current['symptoms'] ?? 'N/A'}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('$waiting patients waiting'),
                              const SizedBox(width: 12),
                              Text('$onSite on site patients'),
                            ],
                          ),
                        ] else ...[
                          const Text('No active queue currently.'),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Stats
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MockRepository.instance.appointments,
              builder: (context, appts, _) {
                final active = appts
                    .where((a) => (a['resolved'] as bool? ?? false) == false)
                    .toList();
                final upcoming = active
                    .where(
                      (a) => (a['datetime'] as DateTime).isAfter(
                        DateTime.now().subtract(const Duration(days: 1)),
                      ),
                    )
                    .toList();
                final uniquePatients = upcoming
                    .map((a) => a['patient'] as String)
                    .toSet()
                    .toList();

                return Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today, color: primary),
                              const SizedBox(height: 8),
                              Text(
                                '${upcoming.length} Total Appointments',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.person, color: primary),
                              const SizedBox(height: 8),
                              Text(
                                '${uniquePatients.length} Active Patients',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
