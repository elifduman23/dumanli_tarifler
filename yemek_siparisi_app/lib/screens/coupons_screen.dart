import 'package:flutter/material.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuponlarım')),
      body: const Center(child: Text('Aktif Kuponunuz Bulunmamaktadır')),
    );
  }
}
