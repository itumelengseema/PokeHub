import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/theme_controller.dart';
import 'package:pokedex_app/controllers/auth_controller.dart';
import 'package:pokedex_app/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';

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
    _loadUserProfile();
  }

  void _loadUserProfile() {
    // Reload Firebase user to get latest data
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userProfile = UserProfile(
          name: user.displayName ?? 'Pokémon Trainer',
          email: user.email ?? '', // bugfix notes , this defaults to a string when email is null 
          joinedDate: user.metadata.creationTime ?? DateTime.now(),
          bio: 'Gotta catch \'em all!',
          profileImageUrl: user.photoURL,
        );
      });
    } else {
      setState(() {
        _userProfile = UserProfile.fromJson({});
      });
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
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              try {
                await _authController.logout();
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
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
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final cardColor = isDark ? Colors.grey[850] : Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtextColor = isDark ? Colors.grey[400] : Colors.black54;
    final size = context.responsive;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: size.responsiveHorizontalPadding(
              mobile: 16.0,
              tablet: 32.0,
              desktop: 48.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.responsiveValue(
                  mobile: double.infinity,
                  tablet: 500.0,
                  desktop: 450.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.responsiveValue(
                      mobile: 20.0,
                      tablet: 16.0,
                      desktop: 12.0,
                    ),
                  ),
                  // Profile Image
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: size.responsiveValue(
                        mobile: 60.0,
                        tablet: 55.0,
                        desktop: 50.0,
                      ),
                      backgroundColor: cardColor,
                      backgroundImage: _userProfile.profileImageUrl != null
                          ? NetworkImage(_userProfile.profileImageUrl!)
                          : null,
                      child: _userProfile.profileImageUrl == null
                          ? Icon(
                              Icons.person,
                              size: size.responsiveValue(
                                mobile: 60.0,
                                tablet: 55.0,
                                desktop: 50.0,
                              ),
                              color: textColor,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: size.responsiveValue(
                      mobile: 24.0,
                      tablet: 20.0,
                      desktop: 16.0,
                    ),
                  ),
                  Text(
                    _userProfile.name,
                    style: TextStyle(
                      fontSize: size.responsiveValue(
                        mobile: 28.0,
                        tablet: 26.0,
                        desktop: 24.0,
                      ),
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _userProfile.email,
                    style: TextStyle(
                      fontSize: size.responsiveValue(
                        mobile: 16.0,
                        tablet: 15.0,
                        desktop: 14.0,
                      ),
                      color: subtextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (_userProfile.bio != null) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _userProfile.bio!,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtextColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                SizedBox(height: 12),
                Text(
                  'Member since ${_formatDate(_userProfile.joinedDate)}',
                  style: TextStyle(fontSize: 13, color: subtextColor),
                ),
                SizedBox(height: 40),

                SizedBox(height: 40),

                // Settings Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Theme Toggle
                      _buildSettingItem(
                        icon: widget.themeController.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        iconColor: widget.themeController.isDarkMode
                            ? Colors.orange[300]
                            : Colors.amber[700],
                        title: 'Dark Mode',
                        subtitle: widget.themeController.isDarkMode
                            ? 'Enabled'
                            : 'Disabled',
                        trailing: Switch(
                          value: widget.themeController.isDarkMode,
                          onChanged: (value) {
                            widget.themeController.toggleTheme();
                          },
                          activeTrackColor: Colors.black87,
                        ),
                        isDark: isDark,
                        textColor: textColor,
                        subtextColor: subtextColor,
                      ),
                      SizedBox(height: 12),

                      // // Edit Profile
                      // _buildSettingItem(
                      //   icon: Icons.edit_outlined,
                      //   iconColor: Colors.green[600],
                      //   title: 'Edit Profile',
                      //   subtitle: 'Update your information',
                      //   trailing: Icon(
                      //     Icons.arrow_forward_ios,
                      //     size: 16,
                      //     color: subtextColor,
                      //   ),
                      //   onTap: () {
                      //     final messenger = ScaffoldMessenger.of(context);
                      //     messenger.showSnackBar(
                      //       SnackBar(
                      //         content: Text('Edit profile - Coming soon!'),
                      //         backgroundColor: Colors.black87,
                      //       ),
                      //     );
                      //   },
                      //   isDark: isDark,
                      //   textColor: textColor,
                      //   subtextColor: subtextColor,
                      // ),
                    ],
                  ),
                ),
                  SizedBox(
                    height: size.responsiveValue(
                      mobile: 20.0,
                      tablet: 16.0,
                      desktop: 12.0,
                    ),
                  ),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: size.responsiveValue(
                      mobile: 56.0,
                      tablet: 50.0,
                      desktop: 48.0,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _showLogoutDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        side: BorderSide(color: Colors.red, width: 1),
                      ),
                      icon: Icon(Icons.logout),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: size.responsiveValue(
                            mobile: 18.0,
                            tablet: 16.0,
                            desktop: 15.0,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.responsiveValue(
                      mobile: 32.0,
                      tablet: 24.0,
                      desktop: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color? iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    required bool isDark,
    required Color textColor,
    required Color? subtextColor,
  }) {
    final cardBg = isDark ? Colors.grey[800] : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor?.withValues(alpha: 0.2) ?? Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: subtextColor),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
