import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';
import 'package:core/assets/core_localizations.dart';

void main() {
  runApp(const MonorepoApp());
}

class MonorepoApp extends StatefulWidget {
  const MonorepoApp({super.key});

  @override
  State<MonorepoApp> createState() => _MonorepoAppState();
}

class _MonorepoAppState extends State<MonorepoApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monorepo Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizationsExtension.delegate,
        CoreLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: MonorepoHomePage(onLanguageChange: _changeLanguage),
    );
  }
}

class MonorepoHomePage extends StatelessWidget {
  final Function(Locale) onLanguageChange;

  const MonorepoHomePage({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context);
    final coreL10n = CoreLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Monorepo Architecture'),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: 'Language',
            onSelected: onLanguageChange,
            itemBuilder: (BuildContext context) => [
              _buildLanguageMenuItem(
                const Locale('en'),
                'English',
                currentLocale,
              ),
              _buildLanguageMenuItem(
                const Locale('id'),
                'Indonesia',
                currentLocale,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Architecture Banner
            _buildArchitectureBanner(),
            const SizedBox(height: 24),

            // App Package Section
            PackageCard(
              packageName: 'App Package',
              packageType: 'Main Application',
              icon: Icons.phone_android,
              color: Colors.deepPurple,
              children: [
                ModuleSectionHeader(
                  title: 'Auth Module',
                  icon: Icons.lock,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(appL10n.login.title),
                Text(appL10n.login.email),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.login, size: 16),
                  label: Text(appL10n.login.button),
                ),
                const SizedBox(height: 16),
                ModuleSectionHeader(
                  title: 'Home Module',
                  icon: Icons.home,
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                Text(appL10n.welcome),
                Text(appL10n.welcome_user(name: 'Bob')),
                Text(appL10n.discount(value: '30')),
                const SizedBox(height: 16),
                ModuleSectionHeader(
                  title: 'Settings Module',
                  icon: Icons.settings,
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                Text('Profile: ${appL10n.profile.title}'),
                Text('Language: ${appL10n.preferences.language}'),
                const SizedBox(height: 12),
                Text(
                  '📦 AppLocalizations\n'
                  '📁 app_auth_en.json, app_home_en.json, app_settings_en.json',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Core Package Section
            PackageCard(
              packageName: 'Core Package',
              packageType: 'Shared Library',
              icon: Icons.extension,
              color: Colors.teal,
              children: [
                _buildCoreSetupInstructions(),
                const SizedBox(height: 16),
                ModuleSectionHeader(
                  title: 'Widgets Module',
                  icon: Icons.widgets_outlined,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 8),
                Text('• loading: "${coreL10n.loading}"'),
                Text('• error: "${coreL10n.error}"'),
                Text('• retry: "${coreL10n.retry}"'),
                const SizedBox(height: 16),
                ModuleSectionHeader(
                  title: 'Buttons Module',
                  icon: Icons.smart_button,
                  color: Colors.pink,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(coreL10n.save)),
                    Chip(label: Text(coreL10n.cancel)),
                    Chip(label: Text(coreL10n.delete)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '📦 CoreLocalizations\n'
                  '📁 core_widgets_en.json, core_buttons_en.json',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Benefits Card
            _buildBenefitsCard(),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<Locale> _buildLanguageMenuItem(
    Locale locale,
    String label,
    Locale currentLocale,
  ) {
    return PopupMenuItem<Locale>(
      value: locale,
      child: Row(
        children: [
          Text(label),
          if (currentLocale.languageCode == locale.languageCode) ...[
            const Spacer(),
            const Icon(Icons.check, color: Colors.green),
          ],
        ],
      ),
    );
  }

  Widget _buildArchitectureBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree, color: Colors.purple.shade700),
              const SizedBox(width: 8),
              Text(
                'Monorepo Architecture',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Multi-package project structure:\n'
            '📦 App Package - Main application with app-specific features\n'
            '📦 Core Package - Shared library with common components\n\n'
            'Each package has independent localization management.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreSetupInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Core Package Active!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '✅ CoreLocalizations generated and active\n'
            '✅ Shared across multiple apps in monorepo\n'
            '✅ Independent versioning and deployment',
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Monorepo Benefits',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('✓ Independent package management'),
            const Text('✓ Shared core library across multiple apps'),
            const Text('✓ Separate versioning per package'),
            const Text('✓ Clear separation of concerns'),
            const Text('✓ Scalable for enterprise applications'),
          ],
        ),
      ),
    );
  }
}

// Package Card Widget
class PackageCard extends StatelessWidget {
  final String packageName;
  final String packageType;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const PackageCard({
    super.key,
    required this.packageName,
    required this.packageType,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          packageName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          packageType,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

// Module Section Header Widget
class ModuleSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const ModuleSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
