import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:pokedex_app/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:pokedex_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:pokedex_app/core/theme/app_theme_data.dart';
import 'package:pokedex_app/firebase_options.dart';
import 'package:pokedex_app/presentation/screens/home_screen.dart';
import 'package:pokedex_app/presentation/screens/favorites_screen.dart';
import 'package:pokedex_app/presentation/screens/profile_screen.dart';
import 'package:pokedex_app/presentation/screens/auth_wrapper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Pokedex',
            debugShowCheckedModeBanner: false,
            themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int currentPage = 0;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;

    // Listen to auth state changes and reinitialize favorites
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && _currentUser != null) {
        // User signed out - reinitialize to clear favorites
        if (mounted) {
          context.read<FavoritesViewModel>().reinitialize();
        }
      } else if (user != null && _currentUser?.uid != user.uid) {
        // User signed in or switched - reinitialize for new user
        if (mounted) {
          context.read<FavoritesViewModel>().reinitialize();
        }
      }
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
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
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
