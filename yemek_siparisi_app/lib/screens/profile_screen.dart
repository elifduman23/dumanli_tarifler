import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'orders_screen.dart';
import 'coupons_screen.dart';
import 'notifications_screen.dart';
import 'admin_panel_screen.dart';
import 'support_screen.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String token;
  final String userRole;
  final String userAddress;

  const ProfileScreen({
    super.key, 
    this.userName = 'Kullanıcı', 
    this.userEmail = '', 
    this.token = '',
    this.userRole = 'Customer',
    this.userAddress = ''
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 30),
                  _buildMenuItem(context, 'Favorilerim', Icons.favorite_border, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(token: token)));
                  }),
                  _buildMenuItem(context, 'Adreslerim', Icons.location_on_outlined, () {
                    _showAddresses(context);
                  }),
                  _buildMenuItem(context, 'Sipariş Geçmişi', Icons.history, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen(token: token)));
                  }),
                  _buildMenuItem(context, 'Kuponlarım', Icons.confirmation_number_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CouponsScreen()));
                  }),
                  _buildMenuItem(context, 'Bildirimler', Icons.notifications_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                  }),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 20),
                  if (userRole == 'Admin')
                    _buildMenuItem(context, 'Yönetici Paneli', Icons.admin_panel_settings_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanelScreen(token: token)));
                    }),
                  _buildMenuItem(context, 'Destek', Icons.support_agent, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                  }),
                  _buildMenuItem(context, 'Çıkış Yap', Icons.logout, () {
                    // Tüm sayfaları temizle ve giriş ekranına dön
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }, isDestructive: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: const Color(0xFF1E1E1E),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Profilim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.amber.withOpacity(0.1),
          child: const Icon(Icons.person, size: 40, color: Colors.amber),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(userEmail, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.amber, size: 22),
      ),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.white, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: isDestructive ? Colors.red.withOpacity(0.5) : Colors.white24, size: 14),
    );
  }

  void _showAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kayıtlı Adreslerim', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home_outlined, color: Colors.amber),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      userAddress.isNotEmpty && userAddress.trim() != '/' ? userAddress : 'Henüz bir adres tanımlanmamış.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Yeni Adres Ekle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
