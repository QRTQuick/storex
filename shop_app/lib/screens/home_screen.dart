import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_provider.dart';
import 'create_shop_screen.dart';
import 'shop_owner_screen.dart';
import 'buyer_screen.dart';
import 'admin_panel_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
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
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          // Admin users go directly to admin panel
          if (appProvider.isAdmin) {
            return AdminPanelScreen();
          }

          // Owners see their shop management
          if (appProvider.isOwner) {
            if (appProvider.currentShop == null) {
              return CreateShopScreen();
            }
            return ShopOwnerScreen();
          }

          // Buyers see marketplace
          return BuyerScreen();
        },
      ),
    );
  }
}
