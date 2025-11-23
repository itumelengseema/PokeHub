import 'package:flutter/material.dart';
import 'package:pokedex_app/views/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Center(child: HomeScreen())),
      ),
    );
  }
}
