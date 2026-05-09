import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_provider.dart';
import 'add_product_screen.dart';

class ShopOwnerScreen extends StatefulWidget {
  @override
  _ShopOwnerScreenState createState() => _ShopOwnerScreenState();
}

class _ShopOwnerScreenState extends State<ShopOwnerScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadProducts();
    });
  }

  Future<void> _handleRoleSwitch() async {
    try {
      await Provider.of<AppProvider>(context, listen: false).switchRole('buyer');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to Buyer role')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to switch role: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          children: [
            // Shop Info Card
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appProvider.currentShop?.name ?? 'My Shop',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'switch') {
                              _handleRoleSwitch();
                            } else if (value == 'logout') {
                              appProvider.logout();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'switch',
                              child: Text('Switch to Buyer'),
                            ),
                            PopupMenuItem(
                              value: 'logout',
                              child: Text('Logout'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      appProvider.currentShop?.description ?? '',
                      style: TextStyle(color: Colors.grey),
                    ),
                    if (appProvider.currentShop?.websiteUrl != null) ...[
                      SizedBox(height: 4),
                      Text(
                        appProvider.currentShop!.websiteUrl!,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'Products',
                          appProvider.products.length.toString(),
                          Icons.inventory,
                        ),
                        _buildStatCard(
                          'Available',
                          appProvider.products.where((p) => p.isAvailable).length.toString(),
                          Icons.check_circle,
                        ),
                        _buildStatCard(
                          'Sold',
                          appProvider.products.where((p) => !p.isAvailable).length.toString(),
                          Icons.sell,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Add Product Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AddProductScreen()),
                    );
                  },
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Add New Product (Snap & Upload)'),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Products List
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
                                'No products yet',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap the button above to add your first product',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await appProvider.loadProducts();
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: appProvider.products.length,
                            itemBuilder: (context, index) {
                              final product = appProvider.products[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: product.imageUrl.isNotEmpty
                                        ? Image.network(
                                            product.imageUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.image_not_supported),
                                            ),
                                          )
                                        : Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.camera_alt),
                                          ),
                                  ),
                                  title: Text(product.name),
                                  subtitle: Text(
                                    '\$${product.price.toStringAsFixed(2)} - ${product.category}',
                                  ),
                                  trailing: Switch(
                                    value: product.isAvailable,
                                    onChanged: (value) {
                                      appProvider.updateProductAvailability(
                                        product.id,
                                        value,
                                      );
                                    },
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
