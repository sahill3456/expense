import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 24),
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: Text(
                  'Join us and start tracking your expenses today',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                duration: const Duration(milliseconds: 1100),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                  ),
                  obscureText: !_showPassword,
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 1700),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(
                            () => _showConfirmPassword = !_showConfirmPassword);
                      },
                    ),
                  ),
                  obscureText: !_showConfirmPassword,
                ),
              ),
              const SizedBox(height: 32),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () => _handleSignUp(context),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Create Account'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 2100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUpWithEmail(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
    );

    if (success) {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Sign up failed')),
        );
      }
    }
  }
}
