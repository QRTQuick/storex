import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.store), text: 'Shops'),
            Tab(icon: Icon(Icons.inventory), text: 'Products'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await appProvider.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(),
          _buildShopsTab(),
          _buildProductsTab(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // In production, you would fetch users from the backend
        final users = [
          {'email': 'chisomlifeeke@gamil.com', 'role': 'admin', 'name': 'Admin User'},
          // Add more users as needed
        ];

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings, size: 48, color: Colors.blue),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Access',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'You have full administrative access to manage all users, shops, and products.',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'System Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: user['role'] == 'admin' ? Colors.red : Colors.blue,
                          child: Text(
                            (user['name'] as String)[0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user['name'] as String),
                        subtitle: Text(user['email'] as String),
                        trailing: Chip(
                          label: Text(
                            (user['role'] as String).toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: user['role'] == 'admin' ? Colors.red : Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopsTab() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Shops',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: appProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : appProvider.shops.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'No shops registered yet',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: appProvider.shops.length,
                            itemBuilder: (context, index) {
                              final shop = appProvider.shops[index];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: shop.isOnline ? Colors.green : Colors.grey,
                                    child: Icon(
                                      shop.isOnline ? Icons.check : Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(shop.name),
                                  subtitle: Text(shop.description),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        shop.isOnline ? 'Online' : 'Offline',
                                        style: TextStyle(
                                          color: shop.isOnline ? Colors.green : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Owner: ${shop.ownerId}',
                                        style: TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsTab() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final totalProducts = appProvider.products.length;
        final availableProducts = appProvider.products.where((p) => p.isAvailable).length;
        final soldProducts = totalProducts - availableProducts;

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Total', totalProducts.toString(), Icons.inventory),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard('Available', availableProducts.toString(), Icons.check_circle),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard('Sold', soldProducts.toString(), Icons.sell),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'All Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: appProvider.isLoading && appProvider.products.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : appProvider.products.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'No products in the system',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: appProvider.products.length,
                            itemBuilder: (context, index) {
                              final product = appProvider.products[index];
                              return Card(
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: product.imageUrl.isNotEmpty
                                        ? Image.network(
                                            product.imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.image_not_supported),
                                            ),
                                          )
                                        : Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.camera_alt),
                                          ),
                                  ),
                                  title: Text(product.name),
                                  subtitle: Text('${product.category} - \$${product.price.toStringAsFixed(2)}'),
                                  trailing: Chip(
                                    label: Text(
                                      product.isAvailable ? 'Available' : 'Sold',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: product.isAvailable ? Colors.green : Colors.red,
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
