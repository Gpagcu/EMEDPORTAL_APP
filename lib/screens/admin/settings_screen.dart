import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final primary = const Color(0xFF1976D2);

  // Mock local user data
  String name = 'Admin User';
  DateTime? birthdate = DateTime(1990, 1, 1);
  String gender = 'Other';
  String password = 'password123';
  String phone = '0917-000-0000';
  String email = 'admin@meds.test';
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Med - Admin'),
        actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})],
      ),
      drawer: const SizedBox.shrink(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue header
            Container(
              height: 48,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('User Information', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            ),

            const SizedBox(height: 16),

            // Profile image placeholder
            Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 40, backgroundColor: Colors.grey.shade200, child: const Text('IMAGE')),
                  const SizedBox(height: 8),
                  const Text('Profile Image', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Personal Data Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Personal Data', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextFormField(initialValue: name, decoration: const InputDecoration(labelText: 'Name'), onChanged: (v) => setState(() => name = v)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        final d = await showDatePicker(context: context, initialDate: birthdate ?? DateTime(1990), firstDate: DateTime(1900), lastDate: DateTime.now());
                        if (d != null) setState(() => birthdate = d);
                      },
                      child: Text('Birthdate: ${birthdate != null ? '${birthdate!.year}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}' : 'Select'}'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(value: gender, items: const [DropdownMenuItem(value: 'Male', child: Text('Male')), DropdownMenuItem(value: 'Female', child: Text('Female')), DropdownMenuItem(value: 'Other', child: Text('Other'))], onChanged: (v) => setState(() => gender = v ?? 'Other')),
                    const SizedBox(height: 12),
                    TextFormField(initialValue: password, obscureText: obscure, decoration: InputDecoration(labelText: 'Password', suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscure = !obscure))), onChanged: (v) => setState(() => password = v)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Contact Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Contact Info', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextFormField(initialValue: phone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, onChanged: (v) => setState(() => phone = v)),
                    const SizedBox(height: 12),
                    TextFormField(initialValue: email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, onChanged: (v) => setState(() => email = v)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                // mock enable 2FA
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('2FA Enabled (mock)')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: primary, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Enable 2FA'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                // mock logout
                Navigator.popUntil(context, ModalRoute.withName('/login'));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Log out?'),
            ),
          ],
        ),
      ),
    );
  }
}
