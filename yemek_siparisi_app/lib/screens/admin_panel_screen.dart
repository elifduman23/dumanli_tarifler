import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  final String token;
  const AdminPanelScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetici Paneli')),
      body: const Center(child: Text('Yönetici Paneli Yakında Hizmetinizde')),
    );
  }
}
