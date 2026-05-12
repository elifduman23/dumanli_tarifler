import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    
    // NOT: Kendi telefonunda denemek istersen aşağıdaki ngrok satırını açabilirsin.
    return 'https://unsent-ruckus-icy.ngrok-free.dev/api'; 
  }
  static String get authUrl => '$baseUrl/auth';

  // KAYIT OL
  static Future<Map<String, dynamic>> register(String fullName, String email, String password, {String? province, String? district, String? neighborhood}) async {
    try {
      final response = await http.post(
        Uri.parse('$authUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'FullName': fullName,
          'Email': email,
          'Password': password,
          'Province': province,
          'District': district,
          'Neighborhood': neighborhood
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Kayıt başarılı.'};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Kayıt başarısız.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Bağlantı hatası: $e'};
    }
  }

  // GİRİŞ YAP
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'E-posta veya şifre hatalı.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Bağlantı hatası: $e'};
    }
  }

  // PROFİL GÜNCELLE
  static Future<Map<String, dynamic>> updateProfile(String token, String? province, String? district, String? neighborhood) async {
    try {
      final response = await http.patch(
        Uri.parse('$authUrl/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'Province': province,
          'District': district,
          'Neighborhood': neighborhood
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Profil güncellenemedi.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Bağlantı hatası: $e'};
    }
  }

  // TÜM RESTORANLARI GETİR
  static Future<List<dynamic>> getRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Restaurant'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Restoran getirme hatası: $e');
      return [];
    }
  }

  // RESTORAN DETAYI GETİR
  static Future<Map<String, dynamic>?> getRestaurantDetails(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Restaurant/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // SİPARİŞ OLUŞTUR (VERİTABANINA KAYDET)
  static Future<Map<String, dynamic>> createOrder(int restaurantId, List<Map<String, dynamic>> items, String token, {String? couponCode}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'RestaurantId': restaurantId,
          'CouponCode': couponCode,
          'Items': items.map((e) => {
            'MenuItemId': e['id'],
            'Quantity': e['quantity']
          }).toList(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Siparişiniz başarıyla alındı.'};
      }
      return {'success': false, 'message': 'Sipariş verilirken hata oluştu.'};
    } catch (e) {
      return {'success': false, 'message': 'Teknik Hata: $e'};
    }
  }

  // SİPARİŞ GEÇMİŞİNİ GETİR
  static Future<List<dynamic>> getOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Order/my-orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Sipariş geçmişi hatası: $e');
      return [];
    }
  }

  // TÜM SİPARİŞLERİ GETİR (ADMIN)
  static Future<List<dynamic>> getAllOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Order/all-orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Tüm siparişler hatası: $e');
      return [];
    }
  }

  // SİPARİŞ DURUMUNU GÜNCELLE (ADMIN)
  static Future<bool> updateOrderStatus(int orderId, String status, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/Order/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(status),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Durum güncelleme hatası: $e');
      return false;
    }
  }

  // KATEGORİYE GÖRE YEMEK GETİR
  static Future<List<dynamic>> getMenuItemsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/MenuItem/category/$category'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // TÜM KATEGORİLERİ GETİR (DİNAMİK)
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/MenuItem/categories'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Kategori getirme hatası: $e');
      return [];
    }
  }

  // FAVORİ EKLE/KALDIR
  static Future<Map<String, dynamic>> toggleFavorite(int restaurantId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Favorite/$restaurantId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      return {
        'success': response.statusCode == 200,
        'isFavorite': response.statusCode == 200 ? jsonDecode(response.body)['isFavorite'] : false,
      };
    } catch (e) {
      return {'success': false, 'isFavorite': false};
    }
  }

  // FAVORİLERİ GETİR
  static Future<List<dynamic>> getFavorites(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Favorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ARAMA YAP
  static Future<List<dynamic>> searchMenuItems(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/MenuItem/search/$query'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // TÜM KULLANICILARI GETİR (ADMIN)
  static Future<List<dynamic>> getAllUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Admin/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Tüm kullanıcılar hatası: $e');
      return [];
    }
  }

  // SİSTEM İSTATİSTİKLERİNİ GETİR (ADMIN)
  static Future<Map<String, dynamic>> getAdminStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Admin/stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {};
    } catch (e) {
      print('İstatistik hatası: $e');
      return {};
    }
  }

  // BİLDİRİMLERİ GETİR
  static Future<List<dynamic>> getNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Notification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Bildirim hatası: $e');
      return [];
    }
  }

  // KUPONLARI GETİR
  static Future<List<dynamic>> getCoupons(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$authUrl/my-coupons'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Kupon hatası: $e');
      return [];
    }
  }
}
