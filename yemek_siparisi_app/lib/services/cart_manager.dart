class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _items = [];
  int? _currentRestaurantId;

  List<Map<String, dynamic>> get items => _items;

  void addToCart(dynamic product, int restaurantId) {
    if (_currentRestaurantId != null && _currentRestaurantId != restaurantId) {
      _items.clear(); // Farklı restorandan ürün eklenirse sepeti temizle
    }
    _currentRestaurantId = restaurantId;

    // Ürün zaten sepette mi kontrol et
    int index = _items.indexWhere((item) => item['id'] == product['id']);
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
      });
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item['id'] == productId);
    if (_items.isEmpty) _currentRestaurantId = null;
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
