import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/cart_manager.dart';

class GlobalSearchScreen extends StatefulWidget {
  final String token;
  const GlobalSearchScreen({super.key, this.token = ''});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  List<dynamic> _results = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  void _onSearch(String query) async {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isLoading = true);
    final data = await ApiService.searchMenuItems(query);
    setState(() {
      _results = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Lezzet Ara', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Pizza, Burger, Kebap...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.amber),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : _results.isEmpty
                    ? const Center(child: Text('Aramaya başla!', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          return _buildResultCard(item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(dynamic item) {
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.fastfood, color: Colors.amber, size: 35),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(item['restaurant']?['name'] ?? 'Bilinmeyen Restoran', style: const TextStyle(color: Colors.amber, fontSize: 12)),
                const SizedBox(height: 5),
                Text('₺${item['price']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              CartManager().addToCart(item, item['restaurantId']);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['name']} sepete eklendi!'), backgroundColor: Colors.green));
            },
            icon: const Icon(Icons.add_circle, color: Colors.amber, size: 30),
          ),
        ],
      ),
    );
  }
}
