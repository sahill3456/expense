import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/home');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      '💰',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'Expense Tracker',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: Text(
                  'Track your spending smarter',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 64),
              FadeInUp(
                duration: const Duration(milliseconds: 1100),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
