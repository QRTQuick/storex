import 'dart:convert';
import 'package:http/http.dart' as http;

class InsForgeService {
  // TODO: Replace with your actual InsForge API endpoint
  static const String baseUrl = 'https://api.insforge.dev';
  
  final http.Client _client = http.Client();
  
  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Authentication
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'buyer',
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _getHeaders(null),
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
        'role': role,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: _getHeaders(null),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign in: ${response.body}');
    }
  }

  // User operations
  Future<Map<String, dynamic>> getUser(String userId, String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateUserRole(String userId, String role, String token) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl/users/$userId/role'),
      headers: _getHeaders(token),
      body: jsonEncode({'role': role}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user role: ${response.body}');
    }
  }

  // Shop operations
  Future<Map<String, dynamic>> createShop({
    required String ownerId,
    required String name,
    required String description,
    String? websiteUrl,
    required String token,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/shops'),
      headers: _getHeaders(token),
      body: jsonEncode({
        'owner_id': ownerId,
        'name': name,
        'description': description,
        'website_url': websiteUrl,
        'is_online': true,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create shop: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getShops(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/shops'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to get shops: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getShopById(String shopId, String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/shops/$shopId'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get shop: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateShop(String shopId, Map<String, dynamic> data, String token) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl/shops/$shopId'),
      headers: _getHeaders(token),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update shop: ${response.body}');
    }
  }

  // Product operations
  Future<Map<String, dynamic>> createProduct({
    required String shopId,
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required String token,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/products'),
      headers: _getHeaders(token),
      body: jsonEncode({
        'shop_id': shopId,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image_url': imageUrl,
        'is_available': true,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getProducts({
    String? shopId,
    String? category,
    bool? isAvailable,
    required String token,
  }) async {
    var url = Uri.parse('$baseUrl/products');
    final queryParams = <String, String>{};
    
    if (shopId != null) queryParams['shop_id'] = shopId;
    if (category != null) queryParams['category'] = category;
    if (isAvailable != null) queryParams['is_available'] = isAvailable.toString();
    
    if (queryParams.isNotEmpty) {
      url = url.replace(queryParameters: queryParams);
    }

    final response = await _client.get(
      url,
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to get products: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> data, String token) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl/products/$productId'),
      headers: _getHeaders(token),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct(String productId, String token) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/products/$productId'),
      headers: _getHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  // Admin operations
  Future<List<Map<String, dynamic>>> getAllUsers(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to get users: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllShops(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/admin/shops'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to get shops: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}
