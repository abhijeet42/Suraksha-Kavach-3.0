import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
           const Text('Suraksha Kavach FAQ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           _buildHelpItem(
             'How does it detect scams?',
             'The app uses an AI engine that scans for suspicious keywords, urgent language, and known phishing link patterns locally on your device.'
           ),
           _buildHelpItem(
             'Is my data private?',
             'Yes! Suraksha Kavach processes all SMS scans entire on-device. No private message content is ever uploaded to our servers.'
           ),
           _buildHelpItem(
             'How to add family members?',
             'Admin users can generate a unique invite code in the Family tab (This feature is currently being built).'
           ),
           const Divider(height: 48),
           const Text('Contact Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           const ListTile(leading: Icon(Icons.email), title: Text('support@surakshakavach.app')),
           const ListTile(leading: Icon(Icons.phone), title: Text('+91 1800-SAFE-EYE')),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String q, String a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(a, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
