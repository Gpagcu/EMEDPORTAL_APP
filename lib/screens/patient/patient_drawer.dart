import 'package:flutter/material.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Drawer(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primary),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: const [
              Text('eMedsPortal', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('Patient', style: TextStyle(color: Colors.white70)),
            ]),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Back to Dashboard'), onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(leading: const Icon(Icons.person), title: const Text('View Profile'), onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/patientProfile');
          }),
          const Divider(),
          ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Book Appointment'), onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/bookAppointment');
          }),
          const Divider(),
          ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help'), onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/help');
          }),
          const Spacer(),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Log Out'), onTap: () => Navigator.popUntil(context, ModalRoute.withName('/login'))),
        ]),
      ),
    );
  }
}
