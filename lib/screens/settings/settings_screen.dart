import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer2<AuthProvider, ThemeProvider>(
          builder: (context, authProvider, themeProvider, _) {
            final user = authProvider.currentUser;
            if (user == null) {
              return const Center(child: Text('Please log in'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(context, user),
                const SizedBox(height: 32),
                _buildAppearanceSection(context, themeProvider),
                const SizedBox(height: 32),
                _buildPreferencesSection(context, user),
                const SizedBox(height: 32),
                _buildAboutSection(context),
                const SizedBox(height: 32),
                _buildSignOutButton(context, authProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  (user.displayName ?? 'U')[0].toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? 'User',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showEditProfileDialog(context, user),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        themeProvider.isDarkMode ? 'Enabled' : 'Disabled',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.setDarkMode(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSettingItem(
                context,
                'Monthly Budget',
                '\$${user.monthlyBudget.toStringAsFixed(2)}',
                onTap: () => _showBudgetDialog(context, user),
              ),
              Divider(color: Colors.grey.withOpacity(0.2)),
              _buildSettingItem(
                context,
                'Currency',
                user.currency ?? 'USD',
                onTap: () => _showCurrencyDialog(context),
              ),
              Divider(color: Colors.grey.withOpacity(0.2)),
              _buildSettingItem(
                context,
                'Language',
                user.language ?? 'English',
                onTap: () => _showLanguageDialog(context),
              ),
              Divider(color: Colors.grey.withOpacity(0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Switch(
                    value: user.notificationsEnabled,
                    onChanged: (value) {
                      // TODO: Update user notifications setting
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String value, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAboutItem(context, 'App Version', '1.0.0'),
              Divider(color: Colors.grey.withOpacity(0.2)),
              _buildAboutItem(context, 'Built with', 'Flutter'),
              Divider(color: Colors.grey.withOpacity(0.2)),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms & Privacy'),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Terms & Privacy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => _confirmSignOut(context, authProvider),
        child: const Text('Sign Out'),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, dynamic user) {
    final nameController = TextEditingController(text: user.displayName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Display Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthProvider>().updateUserProfile(
                      nameController.text,
                      null,
                    );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showBudgetDialog(BuildContext context, dynamic user) {
    _budgetController.text = user.monthlyBudget.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Monthly Budget'),
          content: TextField(
            controller: _budgetController,
            decoration: const InputDecoration(
              labelText: 'Budget Amount',
              prefixText: '\$ ',
            ),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Update budget
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: currencies
                  .map((currency) => ListTile(
                        title: Text(currency),
                        onTap: () {
                          // TODO: Update currency
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: languages
                  .map((language) => ListTile(
                        title: Text(language),
                        onTap: () {
                          // TODO: Update language
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out?'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                authProvider.signOut().then((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                });
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
