import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/controllers/theme_controller.dart';
import 'package:pokedex_app/firebase_options.dart';
import 'package:pokedex_app/views/screens/home_screen.dart';
import 'package:pokedex_app/views/screens/favorites_screen.dart';
import 'package:pokedex_app/views/screens/profile_screen.dart';
import 'package:pokedex_app/views/screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeController.themeMode,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardTheme: CardThemeData(
          elevation: 2,
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: AuthWrapper(themeController: _themeController),
    );
  }
}

class HomeWrapper extends StatefulWidget {
  final ThemeController themeController;

  const HomeWrapper({super.key, required this.themeController});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int currentPage = 0;
  final FavoritesController _favoritesController = FavoritesController();

  @override
  void initState() {
    super.initState();
    widget.themeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _favoritesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(favoritesController: _favoritesController),
      FavoritesScreen(favoritesController: _favoritesController),
      ProfileScreen(themeController: widget.themeController),
    ];

    return Scaffold(
      body: SafeArea(child: screens[currentPage]),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home',),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
