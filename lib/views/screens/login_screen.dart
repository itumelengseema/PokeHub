import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/auth_controller.dart';
import 'package:pokedex_app/views/screens/signup_screen.dart';
import 'package:pokedex_app/views/screens/forgot_password_screen.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final messenger = ScaffoldMessenger.of(context);

      setState(() {
        _isLoading = true;
      });

      try {
        await _authController.login(
          emailController.text.trim(),
          passwordController.text,
        );

        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Login failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  void _handleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authController.signInWithGoogle();

      if (user != null && mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Signed in with Google successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Google sign-in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.responsive;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: size.responsiveHorizontalPadding(
              mobile: 24.0,
              tablet: 48.0,
              desktop: 64.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.responsiveValue(
                  mobile: double.infinity,
                  tablet: 500.0,
                  desktop: 450.0,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.responsiveValue(
                        mobile: 40.0,
                        tablet: 32.0,
                        desktop: 24.0,
                      ),
                    ),
                    // Logo
                    Container(
                      padding: EdgeInsets.all(size.responsiveValue(
                        mobile: 16.0,
                        tablet: 14.0,
                        desktop: 12.0,
                      )),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        'https://cdn.brandfetch.io/idyp519aAf/w/1024/h/1022/theme/dark/symbol.png?c=1bxid64Mup7aczewSAYMX&t=1721651819488',
                        width: size.responsiveValue(
                          mobile: 80.0,
                          tablet: 70.0,
                          desktop: 60.0,
                        ),
                        height: size.responsiveValue(
                          mobile: 80.0,
                          tablet: 70.0,
                          desktop: 60.0,
                        ),
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.catching_pokemon,
                            size: size.responsiveValue(
                              mobile: 80.0,
                              tablet: 70.0,
                              desktop: 60.0,
                            ),
                            color: Colors.red[400],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: 32.0,
                      tablet: 28.0,
                      desktop: 24.0,
                    )),
                    // Title
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: size.responsiveValue(
                          mobile: 32.0,
                          tablet: 28.0,
                          desktop: 26.0,
                        ),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: size.responsiveValue(
                          mobile: 16.0,
                          tablet: 15.0,
                          desktop: 14.0,
                        ),
                        color: const Color(0xFF636E72),
                      ),
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: 48.0,
                      tablet: 40.0,
                      desktop: 32.0,
                    )),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.black87, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.responsiveValue(
                            mobile: 20.0,
                            tablet: 18.0,
                            desktop: 16.0,
                          ),
                          vertical: size.responsiveValue(
                            mobile: 18.0,
                            tablet: 16.0,
                            desktop: 14.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: 20.0,
                      tablet: 18.0,
                      desktop: 16.0,
                    )),

                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF636E72),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.responsiveValue(
                            mobile: 20.0,
                            tablet: 18.0,
                            desktop: 16.0,
                          ),
                          vertical: size.responsiveValue(
                            mobile: 18.0,
                            tablet: 16.0,
                            desktop: 14.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: 12.0,
                      tablet: 10.0,
                      desktop: 8.0,
                    )),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleForgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: 24.0,
                      tablet: 20.0,
                      desktop: 16.0,
                    )),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: size.responsiveValue(
                        mobile: 56.0,
                        tablet: 50.0,
                        desktop: 48.0,
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Login',
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
                    SizedBox(height: size.responsiveValue(
                      mobile: 32.0,
                      tablet: 28.0,
                      desktop: 24.0,
                    )),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: const Color(0xFF636E72),
                            fontSize: size.responsiveValue(
                              mobile: 16.0,
                              tablet: 15.0,
                              desktop: 14.0,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _handleSignUp,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: size.responsiveValue(
                                mobile: 16.0,
                                tablet: 15.0,
                                desktop: 14.0,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: 40.0,
                      tablet: 32.0,
                      desktop: 24.0,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
