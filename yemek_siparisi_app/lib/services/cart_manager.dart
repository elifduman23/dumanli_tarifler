class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _items = [];
  int? _currentRestaurantId;

  List<Map<String, dynamic>> get items => _items;

  void addToCart(dynamic product, int restaurantId) {
    // Ürün zaten sepette mi kontrol et
    int index = _items.indexWhere((item) => item['id'] == product['id'] && item['restaurantId'] == restaurantId);
    if (index != -1) {
      _items[index]['quantity'] += 1;
    } else {
      // İndirimli fiyat varsa onu kullan, yoksa normal fiyatı
      double effectivePrice = (product['discountPrice'] ?? product['price']).toDouble();
      
      _items.add({
        'id': product['id'],
        'name': product['name'],
        'price': effectivePrice,
        'quantity': 1,
        'restaurantId': restaurantId,
      });
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item['id'] == productId);
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void clear() {
    _items.clear();
    _currentRestaurantId = null;
  }

  int? get restaurantId => _currentRestaurantId;
}
