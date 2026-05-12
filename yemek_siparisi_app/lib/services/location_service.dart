import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _baseUrl = 'https://turkiyeapi.dev/api/v1';

  static Future<List<dynamic>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/provinces'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getDistricts(int provinceId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/districts?provinceId=$provinceId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getNeighborhoods(int districtId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/neighborhoods?districtId=$districtId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
