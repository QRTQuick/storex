import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/shop.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/insforge_service.dart';

class AppProvider with ChangeNotifier {
  final InsForgeService _insForgeService = InsForgeService();
  final AuthService _authService = AuthService();

  User? _currentUser;
  Shop? _currentShop;
  List<Product> _products = [];
  List<Shop> _shops = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  Shop? get currentShop => _currentShop;
  List<Product> get products => _products;
  List<Shop> get shops => _shops;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isOwner => _currentUser?.role == 'owner';
  bool get isBuyer => _currentUser?.role == 'buyer';
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _insForgeService.signIn(email: email, password: password);
      
      final token = response['token'] ?? response['access_token'];
      final userData = response['user'] ?? response;
      
      if (token != null) {
        await _authService.saveToken(token);
      }
      
      _currentUser = User.fromJson(userData);
      await _authService.saveUserId(_currentUser!.id);
      await _authService.saveUserEmail(_currentUser!.email);
      await _authService.saveUserRole(_currentUser!.role);

      if (_currentUser!.role == 'owner') {
        await loadUserShop();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'buyer',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _insForgeService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );

      final token = response['token'] ?? response['access_token'];
      final userData = response['user'] ?? response;
      
      if (token != null) {
        await _authService.saveToken(token);
      }

      _currentUser = User.fromJson(userData);
      await _authService.saveUserId(_currentUser!.id);
      await _authService.saveUserEmail(_currentUser!.email);
      await _authService.saveUserRole(_currentUser!.role);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      final userId = await _authService.getUserId();
      final email = await _authService.getUserEmail();
      final role = await _authService.getUserRole();
      final token = await _authService.getToken();

      if (userId != null && email != null && role != null) {
        _currentUser = User(
          id: userId,
          email: email,
          fullName: '',
          role: role,
          createdAt: DateTime.now(),
        );

        if (_currentUser!.role == 'owner' && token != null) {
          await loadUserShop();
        }
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> switchRole(String newRole) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      if (token != null) {
        await _insForgeService.updateUserRole(_currentUser!.id, newRole, token);
        
        _currentUser = User(
          id: _currentUser!.id,
          email: _currentUser!.email,
          fullName: _currentUser!.fullName,
          role: newRole,
          createdAt: _currentUser!.createdAt,
        );
        
        await _authService.saveUserRole(newRole);

        if (newRole == 'owner') {
          await loadUserShop();
        } else {
          _currentShop = null;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createShop({
    required String name,
    required String description,
    String? websiteUrl,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final shopData = await _insForgeService.createShop(
        ownerId: _currentUser!.id,
        name: name,
        description: description,
        websiteUrl: websiteUrl,
        token: token,
      );

      _currentShop = Shop.fromJson(shopData);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadUserShop() async {
    if (_currentUser == null) return;

    try {
      final token = await _authService.getToken();
      if (token == null) return;

      final shopsData = await _insForgeService.getShops(token);
      
      final userShopData = shopsData.firstWhere(
        (shop) => shop['owner_id'] == _currentUser!.id,
        orElse: () => null,
      );

      if (userShopData != null) {
        _currentShop = Shop.fromJson(userShopData);
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadProducts({String? shopId}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return;

      final productsData = await _insForgeService.getProducts(
        shopId: shopId ?? _currentShop?.id,
        token: token,
      );

      _products = productsData.map((p) => Product.fromJson(p)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
  }) async {
    if (_currentShop == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final productData = await _insForgeService.createProduct(
        shopId: _currentShop!.id,
        name: name,
        description: description,
        price: price,
        category: category,
        imageUrl: imageUrl,
        token: token,
      );

      _products.add(Product.fromJson(productData));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProductAvailability(String productId, bool isAvailable) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _insForgeService.updateProduct(
        productId,
        {'is_available': isAvailable},
        token,
      );

      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = _products[index].copyWith(isAvailable: isAvailable);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _currentShop = null;
    _products = [];
    _shops = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _insForgeService.dispose();
    super.dispose();
  }
}
