import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/controllers/theme_controller.dart';
import 'package:pokedex_app/core/theme/app_theme_data.dart';
import 'package:pokedex_app/firebase_options.dart';
import 'package:pokedex_app/services/favorites_service.dart';
import 'package:pokedex_app/views/screens/home_screen.dart';
import 'package:pokedex_app/views/screens/favorites_screen.dart';
import 'package:pokedex_app/views/screens/profile_screen.dart';
import 'package:pokedex_app/views/screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) { // this will prevent re-initialization error
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }


  // FlutterNativeSplash.preserve(
  //   widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  // );
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
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: _themeController.themeNotifier,
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Pokedex',
          debugShowCheckedModeBanner: false,
          themeMode: theme.themeMode,
          theme: AppThemeData.lightTheme,
          darkTheme: AppThemeData.darkTheme,
          home: child,
        );
      },
      child: AuthWrapper(themeController: _themeController),
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
  late final FavoritesController _favoritesController;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _favoritesController = FavoritesController(FavoritesService());

    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && _currentUser != null) {
        // User signed out, clear favorites
        _favoritesController.clearFavorites();
      } else if (user != null && _currentUser?.uid != user.uid) {
        // User signed in or switched, reload favorites
        _favoritesController.reloadFavorites();
      }
      _currentUser = user;
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
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
