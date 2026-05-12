import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class AdminPanelScreen extends StatefulWidget {
  final String token;
  const AdminPanelScreen({super.key, required this.token});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<dynamic> _allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final orders = await ApiService.getAllOrders(widget.token);
    if (mounted) {
      setState(() {
        _allOrders = orders;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(int orderId, String newStatus) async {
    final success = await ApiService.updateOrderStatus(orderId, newStatus, widget.token);
    if (success) {
      _fetchOrders(); // Listeyi yenile
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sipariş durumu "$newStatus" olarak güncellendi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Sipariş Yönetimi', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amber),
            onPressed: _fetchOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _allOrders.isEmpty
              ? const Center(child: Text('Henüz hiç sipariş verilmemiş.', style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: _allOrders.length,
                  itemBuilder: (context, index) {
                    final order = _allOrders[index];
                    return _buildOrderCard(order);
                  },
                ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    final DateTime date = DateTime.parse(order['orderDate']).toLocal();
    final String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
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
              Text('Sipariş #${order['id']}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
              _buildStatusBadge(order['status']),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoRow(Icons.person_outline, 'Müşteri: ${order['user']?['fullName'] ?? 'Bilinmiyor'}'),
          _buildInfoRow(Icons.restaurant_menu, 'Restoran: ${order['restaurant']?['name'] ?? 'Bilinmiyor'}'),
          _buildInfoRow(Icons.calendar_today_outlined, 'Tarih: $formattedDate'),
          const Divider(color: Colors.white12, height: 30),
          const Text('Ürünler:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...((order['orderItems'] as List).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• ${item['menuItem']?['name']} x${item['quantity']}',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ))),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Toplam: ${order['totalAmount']} TL', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              _buildActionButton(order),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Hazırlanıyor': color = Colors.orange; break;
      case 'Yolda': color = Colors.blue; break;
      case 'Teslim Edildi': color = Colors.green; break;
      case 'İptal Edildi': color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.5))),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton(dynamic order) {
    String currentStatus = order['status'];
    String? nextStatus;
    String btnText = '';
    Color btnColor = Colors.amber;

    if (currentStatus == 'Hazırlanıyor') {
      nextStatus = 'Yolda';
      btnText = 'Yola Çıkar';
      btnColor = Colors.blue;
    } else if (currentStatus == 'Yolda') {
      nextStatus = 'Teslim Edildi';
      btnText = 'Teslim Et';
      btnColor = Colors.green;
    }

    if (nextStatus == null) return const SizedBox();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => _updateStatus(order['id'], nextStatus!),
      child: Text(btnText, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
