import 'package:flutter/material.dart';
import 'package:pokedex_app/views/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Center(child: HomeScreen())),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            // Handle navigation bar item selection
            setState(() {
              currentPage = index;
            });
          },
          indicatorColor: Colors.red[400]!,
          selectedIndex: currentPage,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
