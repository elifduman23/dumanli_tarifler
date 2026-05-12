import 'package:flutter/material.dart';
import '../services/cart_manager.dart';
import '../services/api_service.dart';

class CartScreen extends StatefulWidget {
  final String token;
  const CartScreen({super.key, this.token = ''});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  double _discountAmount = 0;
  String? _appliedCoupon;
  bool _isOrdering = false;

  @override
  Widget build(BuildContext context) {
    final cart = CartManager();
    final items = cart.items;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Sepetim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.white10),
                  const SizedBox(height: 16),
                  const Text('Henüz sepetinde bir duman yok!', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hemen Lezzetleri Keşfet', style: TextStyle(color: Colors.amber)),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildCartItem(item);
                    },
                  ),
                ),
                _buildSummary(cart),
              ],
            ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.fastfood, color: Colors.amber),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('₺${item['price']}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 24),
                onPressed: () {
                  setState(() {
                    CartManager().removeFromCart(item['id']);
                    _calculateDiscount(CartManager().totalPrice);
                  });
                },
              ),
              Text('x${item['quantity']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.amber, size: 24),
                onPressed: () {
                  setState(() {
                    CartManager().addToCart(item, item['restaurantId']);
                    _calculateDiscount(CartManager().totalPrice);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _calculateDiscount(double total) {
    if (_appliedCoupon == 'BEDAVA2344' || _appliedCoupon == 'DUMANLI50') {
      _discountAmount = total * 0.5;
    } else if (_appliedCoupon == 'LEZZET25' && total >= 100) {
      _discountAmount = 25;
    } else {
      _discountAmount = 0;
    }
  }

  Widget _buildSummary(CartManager cart) {
    double finalTotal = cart.totalPrice - _discountAmount;
    if (finalTotal < 0) finalTotal = 0;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // KUPON ALANI
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _couponController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Kupon Kodun Var mı?',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _appliedCoupon = _couponController.text.toUpperCase();
                      _calculateDiscount(cart.totalPrice);
                    });
                    if (_discountAmount > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kupon Başarıyla Uygulandı!'), backgroundColor: Colors.green),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Geçersiz Kupon veya Alt Limit Yetersiz.'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.withOpacity(0.1),
                    foregroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: const BorderSide(color: Colors.amber),
                  ),
                  child: const Text('UYGULA'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_discountAmount > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ara Toplam', style: TextStyle(color: Colors.grey)),
                  Text('₺${cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('İndirim', style: TextStyle(color: Colors.green)),
                  Text('-₺${_discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                ],
              ),
              const Divider(color: Colors.white12, height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ödenecek Tutar', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('₺${finalTotal.toStringAsFixed(2)}', 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isOrdering ? null : () async {
                  setState(() => _isOrdering = true);
                  
                  // Restoranlara göre ürünleri grupla
                  Map<int, List<Map<String, dynamic>>> groupedItems = {};
                  for (var item in cart.items) {
                    int resId = item['restaurantId'];
                    if (!groupedItems.containsKey(resId)) groupedItems[resId] = [];
                    groupedItems[resId]!.add(item);
                  }

                  bool allSuccess = true;
                  String lastError = "";

                  // Her restoran için ayrı sipariş oluştur
                  for (var entry in groupedItems.entries) {
                    final resId = entry.key;
                    final resItems = entry.value;

                    final result = await ApiService.createOrder(
                      resId,
                      resItems,
                      widget.token,
                      couponCode: _appliedCoupon,
                    );

                    if (!result['success']) {
                      allSuccess = false;
                      lastError = result['message'];
                    }
                  }

                  setState(() => _isOrdering = false);

                  if (allSuccess) {
                    cart.clear();
                    if (mounted) {
                      _showSuccessDialog();
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(lastError), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  shadowColor: Colors.amber.withOpacity(0.3),
                ),
                child: _isOrdering 
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('SİPARİŞİ TAMAMLA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide(color: Colors.amber.withOpacity(0.2))),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 20),
            const Text('Sipariş Alındı!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Tarifler dumanı üstünde hazırlanmaya başladı. Afiyet olsun!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Harika!', style: TextStyle(fontSize: 18, color: Colors.amber, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
