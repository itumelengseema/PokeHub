import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/theme_controller.dart';
import 'package:pokedex_app/controllers/auth_controller.dart';
import 'package:pokedex_app/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final ThemeController themeController;

  const ProfileScreen({super.key, required this.themeController});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _userProfile;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    // Load user data from Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userProfile = UserProfile(
        name: user.displayName ?? 'Pokémon Trainer',
        email: user.email ?? '',
        joinedDate: user.metadata.creationTime ?? DateTime.now(),
        bio: 'Gotta catch \'em all!',
        profileImageUrl: user.photoURL,
      );
    } else {
      _userProfile = UserProfile.dummy();
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _authController.logout();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.grey[800]!, Colors.grey[900]!]
                        : [
                            const Color.fromARGB(255, 243, 77, 65),
                            const Color.fromARGB(255, 156, 30, 13),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Profile Image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _userProfile.profileImageUrl != null
                              ? NetworkImage(_userProfile.profileImageUrl!)
                              : null,
                          child: _userProfile.profileImageUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _userProfile.name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _userProfile.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      if (_userProfile.bio != null) ...[
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _userProfile.bio!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 12),
                      Text(
                        'Member since ${_formatDate(_userProfile.joinedDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Settings Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Theme Toggle
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          widget.themeController.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: widget.themeController.isDarkMode
                              ? Colors.orange
                              : Colors.blue,
                        ),
                        title: Text('Dark Mode'),
                        subtitle: Text(
                          widget.themeController.isDarkMode
                              ? 'Switch to light theme'
                              : 'Switch to dark theme',
                        ),
                        trailing: Switch(
                          value: widget.themeController.isDarkMode,
                          onChanged: (value) {
                            widget.themeController.toggleTheme();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Edit Profile
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.green),
                        title: Text('Edit Profile'),
                        subtitle: Text('Update your profile information'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to edit profile screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Edit profile - Coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),

                    // Notifications
                    SizedBox(height: 24),

                    // Account Section
                    Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Logout Button
                    Card(
                      elevation: 2,
                      color: Colors.red[50],
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Sign out of your account'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.red,
                        ),
                        onTap: _showLogoutDialog,
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
