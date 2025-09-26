import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  void _navigateAndClose(BuildContext context, String route) {
    Navigator.pop(context); // close drawer
    Navigator.pushNamed(context, route);
  }

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
        title: const Text('Med - Admin'),
        actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('eMedsPortal', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Administrator', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () => _navigateAndClose(context, '/adminDashboard')),
              ListTile(leading: const Icon(Icons.people), title: const Text('Patients List'), onTap: () => _navigateAndClose(context, '/patientsList')),
              ListTile(leading: const Icon(Icons.medical_services), title: const Text('Doctors List'), onTap: () => _navigateAndClose(context, '/doctorsList')),
              ListTile(leading: const Icon(Icons.inventory), title: const Text('Inventory'), onTap: () => _navigateAndClose(context, '/inventory')),
              ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Schedule'), onTap: () => _navigateAndClose(context, '/schedule')),
              ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => _navigateAndClose(context, '/settings')),
              const Spacer(),
              ListTile(leading: const Icon(Icons.logout), title: const Text('Log Out'), onTap: () => Navigator.popUntil(context, ModalRoute.withName('/login'))),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Container(
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome to EMedPortal', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Comprehensive Healthcare Management System', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, minimumSize: const Size(140, 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () => Navigator.pushNamed(context, '/schedule'),
                        child: const Text('View Schedule'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, minimumSize: const Size(160, 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () => Navigator.pushNamed(context, '/doctorsList'),
                        child: const Text('Available Doctors'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Active appointments & patients
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MockRepository.instance.appointments,
              builder: (context, appts, _) {
                final now = DateTime.now();
                final active = appts.where((a) => (a['resolved'] as bool? ?? false) == false).toList();
                final upcoming = active.where((a) => (a['datetime'] as DateTime).isAfter(now.subtract(const Duration(days: 1)))).toList();
                final uniquePatients = upcoming.map((a) => a['patient'] as String).toSet().toList();

                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/schedule'),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(Icons.calendar_today, color: primary),
                                const SizedBox(height: 8),
                                Text('${upcoming.length} Active Appointments', textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/patientsList', arguments: {'activeOnly': true}),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(Icons.person, color: primary),
                                const SizedBox(height: 8),
                                Text('${uniquePatients.length} Active Patients', textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Low stock notification
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MockRepository.instance.inventory,
              builder: (context, inv, _) {
                final low = inv.where((i) => (i['quantity'] as int? ?? 0) <= 50).toList();
                if (low.isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/inventory', arguments: {'filter': 'Low Stock'}),
                  child: Card(
                    color: Colors.red.shade50,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.inventory, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Low stock alert: ${low.length} items need restocking', style: const TextStyle(fontWeight: FontWeight.bold))),
                          const Icon(Icons.chevron_right, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, color: primary),
                          const SizedBox(height: 8),
                          const Text('12 Total Appointments', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: primary),
                          const SizedBox(height: 8),
                          const Text('6 Active Patients', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
