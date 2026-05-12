import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class CouponsScreen extends StatefulWidget {
  final String token;
  const CouponsScreen({super.key, required this.token});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  List<dynamic> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoupons();
  }

  Future<void> _fetchCoupons() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getCoupons(widget.token);
    if (mounted) {
      setState(() {
        _coupons = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Kuponlarım', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _coupons.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = _coupons[index];
                    return _buildCouponCard(coupon);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('Aktif kuponunuz bulunmamaktadır.', style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 10),
          const Text('Yeni kampanyalar yakında burada olacak!', style: TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCouponCard(dynamic coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.celebration, color: Colors.amber, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon['discountType'] == 'Percentage' ? '%${coupon['discountValue']} İndirim' : '${coupon['discountValue']} TL İndirim',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(coupon['description'] ?? 'Tüm siparişlerde geçerli!', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.white12, height: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('KUPON KODU', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
                    const SizedBox(height: 5),
                    Text(coupon['code'], style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: coupon['code']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kupon kodu kopyalandı!'), backgroundColor: Colors.amber, duration: Duration(seconds: 1)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('KOPYALA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
