import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrdersScreen extends StatefulWidget {
  final String token;

  const OrdersScreen({super.key, required this.token});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final orders = await ApiService.getOrders(widget.token);
    if (mounted) {
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Siparişlerim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.amber),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      const Text('Henüz hiç sipariş vermemişsin.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return _buildOrderCard(order);
                  },
                ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['restaurant']?['name'] ?? 'Restoran', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(order['status']).withOpacity(0.3)),
                ),
                child: Text(
                  order['status'] ?? 'Beklemede',
                  style: TextStyle(color: _getStatusColor(order['status']), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${_formatDate(order['orderDate'])} • ₺${order['totalAmount']}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Divider(color: Colors.white10, height: 25),
          
          // Sipariş İçeriği
          Column(
            children: (order['orderItems'] as List).map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item['quantity']}x ${item['menuItem']?['name']}', style: const TextStyle(color: Colors.white70)),
                    Text('₺${item['unitPrice']}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 15),
          
          // Takip Çubuğu (Dumanlı Tarifler Style)
          _buildTrackingProgress(order['status']),
        ],
      ),
    );
  }

  Widget _buildTrackingProgress(String status) {
    int currentStep = 0;
    if (status == 'Hazırlanıyor') currentStep = 1;
    if (status == 'Yolda') currentStep = 2;
    if (status == 'Teslim Edildi') currentStep = 3;

    return Row(
      children: [
        _stepIcon(Icons.check_circle, currentStep >= 1),
        _stepLine(currentStep >= 2),
        _stepIcon(Icons.delivery_dining, currentStep >= 2),
        _stepLine(currentStep >= 3),
        _stepIcon(Icons.home, currentStep >= 3),
      ],
    );
  }

  Widget _stepIcon(IconData icon, bool active) {
    return Icon(icon, color: active ? Colors.amber : Colors.white10, size: 24);
  }

  Widget _stepLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? Colors.amber : Colors.white10,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hazırlanıyor': return Colors.orange;
      case 'Yolda': return Colors.blue;
      case 'Teslim Edildi': return Colors.green;
      default: return Colors.amber;
    }
  }

  String _formatDate(String dateStr) {
    final dt = DateTime.parse(dateStr);
    return '${dt.day}.${dt.month}.${dt.year} ${dt.hour}:${dt.minute}';
  }
}
