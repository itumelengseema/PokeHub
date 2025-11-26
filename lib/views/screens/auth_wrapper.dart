import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex_app/views/screens/login_screen.dart';
import 'package:pokedex_app/main.dart';
import 'package:pokedex_app/controllers/theme_controller.dart';

class AuthWrapper extends StatelessWidget {
  final ThemeController themeController;

  const AuthWrapper({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEF5350),
                    Color(0xFFE53935),
                    Color(0xFFC62828),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://cdn.brandfetch.io/idyp519aAf/w/1024/h/1022/theme/dark/symbol.png?c=1bxid64Mup7aczewSAYMX&t=1721651819488',
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.catching_pokemon,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // User is signed in
        if (snapshot.hasData) {
          return HomeWrapper(themeController: themeController);
        }

        // User is not signed in
        return LoginScreen();
      },
    );
  }
}
