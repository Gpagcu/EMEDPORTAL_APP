import 'package:flutter/material.dart';
import 'admin_drawer.dart';

class AdminUserInfoScreen extends StatelessWidget {
  const AdminUserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final admin = {
      'name': 'Admin User',
      'email': 'admin@email.com',
      'phone': '+1 (555) 123-4567',
      'role': 'Administrator',
    };

    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
            drawer: const AdminDrawer(),
            appBar: AppBar(title: const Text('Admin Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(admin['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text('Email: ${admin['email'] as String}'),
                          const SizedBox(height: 4),
                          Text('Phone: ${admin['phone'] as String}'),
                          const SizedBox(height: 4),
                          Text('Role: ${admin['role'] as String}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit action (mock)')));
              },
              child: const Text('Edit Info'),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Pop back to admin login
                Navigator.pop(context);
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
