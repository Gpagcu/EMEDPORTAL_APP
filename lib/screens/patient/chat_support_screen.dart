import 'package:flutter/material.dart';

class ChatSupportScreen extends StatelessWidget {
  const ChatSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context)), title: const Text('Chat Support')),
      body: const Center(child: Text('Chat with Support (placeholder)', style: TextStyle(fontSize: 18))),
    );
  }
}
