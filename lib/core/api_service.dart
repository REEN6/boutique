import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api'; // Use your IP for physical devices
  static String? token;

  static Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token'];
      return data;
    }
    return null;
  }

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createSale(Map<String, dynamic> saleData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(saleData),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getDashboardSummary() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/summary'));
    return jsonDecode(response.body);
  }
}
