import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  final String token;
  const AdminOrdersScreen({super.key, required this.token});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<dynamic> _allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllOrders();
  }

  Future<void> _fetchAllOrders() async {
    // Bu metod tüm siparişleri çeker (Admin yetkisi gerekir)
    // Şu anlık getOrders kullanıyoruz ama normalde tüm restoranlarınkini çeken ayrı bir endpoint olmalı
    final data = await ApiService.getOrders(widget.token);
    if (mounted) {
      setState(() {
        _allOrders = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _changeStatus(int orderId, String newStatus) async {
    final success = await ApiService.updateOrderStatus(
      orderId,
      newStatus,
      widget.token,
    );
    if (success) {
      _fetchAllOrders(); // Listeyi yenile
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Durum güncellendi: $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Yönetici Paneli',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.amber),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _allOrders.length,
              itemBuilder: (context, index) {
                final order = _allOrders[index];
                return _buildAdminOrderCard(order);
              },
            ),
    );
  }

  Widget _buildAdminOrderCard(dynamic order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sipariş #${order['id']}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order['status'],
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Müşteri: ${order['user']?['fullName'] ?? 'Bilinmiyor'}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Divider(color: Colors.white10, height: 25),

          // Durum Güncelleme Butonları
          const Text(
            'Durumu Güncelle:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _statusButton(order['id'], 'Hazırlanıyor', Colors.orange),
                const SizedBox(width: 10),
                _statusButton(order['id'], 'Yolda', Colors.blue),
                const SizedBox(width: 10),
                _statusButton(order['id'], 'Teslim Edildi', Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusButton(int orderId, String status, Color color) {
    return ElevatedButton(
      onPressed: () => _changeStatus(orderId, status),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.3)),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(status),
    );
  }
}
