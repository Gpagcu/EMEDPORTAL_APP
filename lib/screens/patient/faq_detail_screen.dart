import 'package:flutter/material.dart';

class FaqDetailScreen extends StatelessWidget {
  const FaqDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final title = args != null ? (args['title'] as String? ?? 'Detail') : 'Detail';
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context)), title: Text(title)),
      body: Center(child: Text('$title content (placeholder)', style: const TextStyle(fontSize: 18))),
    );
  }
}
