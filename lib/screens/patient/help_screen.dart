import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'patient_drawer.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  Future<void> _launchMail(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Future<void> _launchTel(String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Widget _category(BuildContext context, String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1976D2), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap ?? () => Navigator.pushNamed(context, '/faqDetail', arguments: {'title': title}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context)), title: const Text('EmedPortal'), actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})]),
      drawer: const PatientDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _category(context, 'FAQ (Frequently Asked Questions)', [
            _item(context, 'How do I make Medication Reminder?'),
            _item(context, 'How do I edit a reminder?'),
            _item(context, 'What happens if I miss a dose?'),
            _item(context, 'How do I book or cancel an appointment?'),
            _item(context, 'How do I reset my password?'),
          ]),

          _category(context, 'Tips & Guides', [
            _item(context, 'How to stay on track with your meds'),
            _item(context, 'Setting up refill reminders'),
            _item(context, 'How to prepare for a doctor\'s appointment'),
          ]),

          _category(context, 'Contact Support', [
            _item(context, 'Chat with Support', onTap: () => Navigator.pushNamed(context, '/chatSupport')),
            ListTile(contentPadding: EdgeInsets.zero, title: const Text('Email us (supportemed@gmail.com)', style: TextStyle(color: Colors.white)), onTap: () => _launchMail('supportemed@gmail.com')),
          ]),

          _category(context, 'Emergency Section', [
            ListTile(contentPadding: EdgeInsets.zero, title: const Text('Call Emergency Hotline (911)', style: TextStyle(color: Colors.white)), onTap: () => _launchTel('911')),
          ]),

          _category(context, 'Policies', [
            _item(context, 'Privacy Policy'),
            _item(context, 'Terms of Use'),
          ]),
        ]),
      ),
    );
  }
}
