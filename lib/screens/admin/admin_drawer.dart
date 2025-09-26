import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF1976D2);
    return Drawer(
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
            ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () => _navigate(context, '/adminDashboard')),
            ListTile(leading: const Icon(Icons.people), title: const Text('Patients List'), onTap: () => _navigate(context, '/patientsList')),
            ListTile(leading: const Icon(Icons.medical_services), title: const Text('Doctors List'), onTap: () => _navigate(context, '/doctorsList')),
            ListTile(leading: const Icon(Icons.inventory), title: const Text('Inventory'), onTap: () => _navigate(context, '/inventory')),
            ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Schedule'), onTap: () => _navigate(context, '/schedule')),
            ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => _navigate(context, '/settings')),
            const Spacer(),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Log Out'), onTap: () => Navigator.popUntil(context, ModalRoute.withName('/login'))),
          ],
        ),
      ),
    );
  }
}
