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
  int _currentIndex = 0;
  List<dynamic> _allOrders = [];
  List<dynamic> _allUsers = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final orders = await ApiService.getAllOrders(widget.token);
      final users = await ApiService.getAllUsers(widget.token);
      final stats = await ApiService.getAdminStats(widget.token);
      
      if (mounted) {
        setState(() {
          _allOrders = orders;
          _allUsers = users;
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(int orderId, String newStatus) async {
    final success = await ApiService.updateOrderStatus(orderId, newStatus, widget.token);
    if (success) {
      _fetchData(); 
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
        title: Text(_currentIndex == 0 ? 'Sipariş Yönetimi' : (_currentIndex == 1 ? 'Kullanıcı Yönetimi' : 'Sistem Analizi'), 
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amber),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white24,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Siparişler'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Kullanıcılar'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'İstatistikler'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: return _buildOrdersTab();
      case 1: return _buildUsersTab();
      case 2: return _buildStatsTab();
      default: return const SizedBox();
    }
  }

  // --- SİPARİŞLER TABI ---
  Widget _buildOrdersTab() {
    return _allOrders.isEmpty
        ? const Center(child: Text('Henüz hiç sipariş verilmemiş.', style: TextStyle(color: Colors.white70)))
        : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: _allOrders.length,
            itemBuilder: (context, index) => _buildOrderCard(_allOrders[index]),
          );
  }

  // --- KULLANICILAR TABI ---
  Widget _buildUsersTab() {
    return _allUsers.isEmpty
        ? const Center(child: Text('Kayıtlı kullanıcı bulunamadı.', style: TextStyle(color: Colors.white70)))
        : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: _allUsers.length,
            itemBuilder: (context, index) {
              final user = _allUsers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.withOpacity(0.1),
                    child: Text(user['fullName'][0], style: const TextStyle(color: Colors.amber)),
                  ),
                  title: Text(user['fullName'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['email'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('${user['province'] ?? '-'} / ${user['district'] ?? '-'}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: user['role'] == 'Admin' ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(user['role'], style: TextStyle(color: user['role'] == 'Admin' ? Colors.red : Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          );
  }

  // --- İSTATİSTİKLER TABI ---
  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard('Toplam Kullanıcı', _stats['totalUsers']?.toString() ?? '0', Icons.people, Colors.blue),
          const SizedBox(height: 15),
          _buildStatCard('Toplam Sipariş', _stats['totalOrders']?.toString() ?? '0', Icons.shopping_basket, Colors.orange),
          const SizedBox(height: 15),
          _buildStatCard('Aktif Restoranlar', _stats['totalRestaurants']?.toString() ?? '0', Icons.restaurant, Colors.green),
          const SizedBox(height: 15),
          _buildStatCard('Toplam Ciro', '${_stats['totalRevenue']?.toStringAsFixed(0) ?? '0'} ₺', Icons.monetization_on, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 5),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
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
