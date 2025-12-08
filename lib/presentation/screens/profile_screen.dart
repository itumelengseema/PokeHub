import 'package:flutter/material.dart';
import 'package:pokedex_app/presentation/viewmodels/profile_viewmodel.dart';
import 'package:pokedex_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:pokedex_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _viewModel = ProfileViewModel(user: user);
    _viewModel.loadUserProfile();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              try {
                await context.read<AuthViewModel>().signOut();
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(
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
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: _viewModel,
          child: Consumer<ProfileViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.state == ProfileViewState.error) {
                return Center(
                  child: Text('Error: ${viewModel.errorMessage}'),
                );
              }

              final profile = viewModel.userProfile;
              if (profile == null) {
                return const Center(child: Text('No profile data'));
              }

              return ResponsiveBuilder(
                builder: (context, deviceType, size) {
                  return SingleChildScrollView(
                    padding: size.responsivePadding(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.responsiveValue(
                            mobile: double.infinity,
                            tablet: 600.0,
                            desktop: 650.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: profile.profileImageUrl != null
                                  ? NetworkImage(profile.profileImageUrl!)
                                  : null,
                              child: profile.profileImageUrl == null
                                  ? Text(
                                      viewModel.getUserInitials(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Joined ${viewModel.getFormattedJoinDate()}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Consumer<ThemeViewModel>(
                              builder: (context, themeViewModel, child) {
                                return Card(
                                  margin: size.responsiveHorizontalPadding(
                                    mobile: 16.0,
                                    tablet: 0.0,
                                    desktop: 0.0,
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      themeViewModel.isDarkMode
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                    ),
                                    title: const Text('Dark Mode'),
                                    trailing: Switch(
                                      value: themeViewModel.isDarkMode,
                                      onChanged: (_) => themeViewModel.toggleTheme(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Card(
                              margin: size.responsiveHorizontalPadding(
                                mobile: 16.0,
                                tablet: 0.0,
                                desktop: 0.0,
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.logout, color: Colors.red),
                                title: const Text('Logout'),
                                onTap: _showLogoutDialog,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
