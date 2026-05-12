import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'restaurant_detail_screen.dart';
import 'category_products_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String token;

  const HomeScreen({super.key, required this.userName, required this.userEmail, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _allRestaurants = [];
  List<dynamic> _filteredRestaurants = [];
  List<int> _favoriteIds = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final restaurants = await ApiService.getRestaurants();
      final favorites = await ApiService.getFavorites(widget.token);
      
      if (mounted) {
        setState(() {
          _allRestaurants = restaurants;
          _filteredRestaurants = restaurants;
          _favoriteIds = favorites.map<int>((f) => f['id'] as int).toList();
          _isLoading = false;
          _searchController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Menüler güncellendi!'),
              ],
            ),
            backgroundColor: Colors.amber,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bağlantı hatası oluştu!'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _searchRestaurants(String query) {
    setState(() {
      _filteredRestaurants = _allRestaurants.where((res) {
        final name = res['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _toggleFavorite(int restaurantId) async {
    final result = await ApiService.toggleFavorite(restaurantId, widget.token);
    if (result['success']) {
      setState(() {
        if (result['isFavorite']) {
          _favoriteIds.add(restaurantId);
        } else {
          _favoriteIds.remove(restaurantId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : RefreshIndicator(
              onRefresh: _fetchData,
              color: Colors.amber,
              child: CustomScrollView(
                slivers: [
                  // Üst Header ve Arama
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dumanlı Tarifler', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 22)),
                                  Text('Hoş geldin, ${widget.userName}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.amber),
                                    onPressed: _fetchData,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.notifications_none, color: Colors.amber),
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          // Arama Barı
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _searchRestaurants,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Restoran ara...',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.search, color: Colors.amber),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Kampanya Banner
                          SizedBox(
                            height: 150,
                            child: PageView(
                              children: [
                                _buildPromoCard('DUMANLI FIRSAT', '%30 İndirim', 'Akşam sefasına özel tüm dürümlerde indirim!', const Color(0xFF2C1B1B)),
                                _buildPromoCard('YENİ RESTORAN', 'GastroGo Açıldı', 'Şimdi sipariş ver, GastroPuan kazan!', const Color(0xFF1B2C21)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Kategoriler
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          _buildCategoryItem(context, 'Pizza', Icons.local_pizza),
                          _buildCategoryItem(context, 'Burger', Icons.lunch_dining),
                          _buildCategoryItem(context, 'Döner', Icons.kebab_dining),
                          _buildCategoryItem(context, 'Tatlı', Icons.icecream),
                          _buildCategoryItem(context, 'İçecek', Icons.local_drink),
                        ],
                      ),
                    ),
                  ),

                  // Restoranlar Başlığı
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Popüler Restoranlar', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  // Restoran Listesi
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final res = _filteredRestaurants[index];
                          final isFav = _favoriteIds.contains(res['id']);
                          return _buildRestaurantCard(res, isFav);
                        },
                        childCount: _filteredRestaurants.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryProductsScreen(categoryName: title))),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
              child: Icon(icon, color: Colors.amber, size: 30),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(dynamic res, bool isFavorite) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailScreen(restaurantId: res['id'], restaurantName: res['name']))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    res['logoUrl'] ?? 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.white.withOpacity(0.05),
                      child: const Icon(Icons.restaurant, color: Colors.amber, size: 50),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(res['id']),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.amber, size: 22),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(res['rating']?.toString() ?? '4.8', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(res['name'], 
                          overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(res['description'] ?? 'Taze lezzetler durağı', 
                          overflow: TextOverflow.ellipsis, 
                          maxLines: 1,
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(String label, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
            child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
