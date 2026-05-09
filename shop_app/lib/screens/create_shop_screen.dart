import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CreateShopScreen extends StatefulWidget {
  @override
  _CreateShopScreenState createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteUrlController = TextEditingController();

  @override
  void dispose() {
    _shopNameController.dispose();
    _descriptionController.dispose();
    _websiteUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateShop() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AppProvider>(context, listen: false).createShop(
          name: _shopNameController.text.trim(),
          description: _descriptionController.text.trim(),
          websiteUrl: _websiteUrlController.text.trim().isEmpty 
              ? null 
              : _websiteUrlController.text.trim(),
        );

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop created successfully!')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create shop: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Shop'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.store,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 24),
              Text(
                'Set up your online store',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Fill in the details below to create your shop and start selling products.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _shopNameController,
                decoration: InputDecoration(
                  labelText: 'Shop Name',
                  prefixIcon: Icon(Icons.storefront),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a shop name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _websiteUrlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Website URL (Optional)',
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  return SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: appProvider.isLoading ? null : _handleCreateShop,
                      child: appProvider.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Create Shop'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
