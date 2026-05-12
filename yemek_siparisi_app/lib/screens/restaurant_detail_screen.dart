import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/cart_manager.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;
  final String restaurantName;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  Map<String, dynamic>? _restaurantDetails;
  List<dynamic> _filteredItems = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final details = await ApiService.getRestaurantDetails(widget.restaurantId);
    if (mounted) {
      setState(() {
        _restaurantDetails = details;
        if (details != null) {
          _filteredItems = details['menuItems'] ?? [];
        }
        _isLoading = false;
      });
    }
  }

  void _filterMenu(String query) {
    if (_restaurantDetails == null) return;
    setState(() {
      _filteredItems = (_restaurantDetails!['menuItems'] as List).where((item) {
        final name = item['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: const Color(0xFF1E1E1E),
                  iconTheme: const IconThemeData(color: Colors.amber),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(widget.restaurantName, 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.deliveryhero.io/image/fd-tr/LH/v238-hero.jpg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Menü Başlığı ve Arama Çubuğu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Restoran Menüsü', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('${_filteredItems.length} Ürün', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterMenu,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Yemek veya içecek ara...',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.search, color: Colors.amber),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _filteredItems.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Text('Aradığınız kriterde ürün bulunamadı.', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = _filteredItems[index];
                              return _buildMenuItemCard(item);
                            },
                            childCount: _filteredItems.length,
                          ),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }

  Widget _buildMenuItemCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.fastfood, color: Colors.amber, size: 35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Ürün Adı',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'] ?? 'Dumanı üstünde taze tarifler.',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (item['discountPrice'] != null) ...[
                      Text(
                        '₺${item['discountPrice']}',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₺${item['price']}',
                        style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 13),
                      ),
                    ] else
                      Text(
                        '₺${item['price']}',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              CartManager().addToCart(item, widget.restaurantId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['name']} sepete eklendi!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            icon: const Icon(Icons.add_circle, color: Colors.amber, size: 32),
          ),
        ],
      ),
    );
  }
}
