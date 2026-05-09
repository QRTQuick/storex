import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'admin_panel_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return FutureBuilder(
      future: appProvider.loadCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final appProvider = Provider.of<AppProvider>(context);
        
        if (!appProvider.isLoggedIn) {
          return LoginScreen();
        }

        // Check if user is admin
        if (appProvider.isAdmin) {
          return AdminPanelScreen();
        }

        return HomeScreen();
      },
    );
  }
}
