import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';

void main() {
  runApp(const ModularLocalizationApp());
}

class ModularLocalizationApp extends StatefulWidget {
  const ModularLocalizationApp({super.key});

  @override
  State<ModularLocalizationApp> createState() => _ModularLocalizationAppState();
}

class _ModularLocalizationAppState extends State<ModularLocalizationApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Localization Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: ModularHomePage(onLanguageChange: _changeLanguage),
    );
  }
}

class ModularHomePage extends StatelessWidget {
  final Function(Locale) onLanguageChange;

  const ModularHomePage({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Modular Localization'),
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
            // Architecture Info Banner
            _buildArchitectureBanner(context),
            const SizedBox(height: 24),

            // Auth Module
            ModuleCard(
              moduleName: 'Auth Module',
              moduleFile: 'app_auth_en.json',
              icon: Icons.lock,
              color: Colors.blue,
              child: AuthModuleWidget(appLocalizations: appLocalizations),
            ),
            const SizedBox(height: 16),

            // Home Module
            ModuleCard(
              moduleName: 'Home Module',
              moduleFile: 'app_home_en.json',
              icon: Icons.home,
              color: Colors.purple,
              child: HomeModuleWidget(appLocalizations: appLocalizations),
            ),
            const SizedBox(height: 16),

            // Common Module
            ModuleCard(
              moduleName: 'Common Module',
              moduleFile: 'app_common_en.json',
              icon: Icons.widgets,
              color: Colors.orange,
              child: CommonModuleWidget(appLocalizations: appLocalizations),
            ),
            const SizedBox(height: 16),

            // Settings Module
            ModuleCard(
              moduleName: 'Settings Module',
              moduleFile: 'app_settings_en.json',
              icon: Icons.settings,
              color: Colors.teal,
              child: SettingsModuleWidget(locale: currentLocale),
            ),
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

  Widget _buildArchitectureBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                'Modular Organization',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Translations organized by feature modules:\n'
            '• Each module has its own JSON file\n'
            '• Better for large projects with multiple teams\n'
            '• Easier to maintain and scale',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Module Card Widget
class ModuleCard extends StatelessWidget {
  final String moduleName;
  final String moduleFile;
  final IconData icon;
  final Color color;
  final Widget child;

  const ModuleCard({
    super.key,
    required this.moduleName,
    required this.moduleFile,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moduleName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        '📁 $moduleFile',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

// Auth Module Widget
class AuthModuleWidget extends StatelessWidget {
  final AppLocalizations appLocalizations;

  const AuthModuleWidget({super.key, required this.appLocalizations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).login.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).login.email,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).login.password,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context).login.button),
        ),
        const SizedBox(height: 8),
        Text(
          'Errors:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red.shade700,
          ),
        ),
        const SizedBox(height: 4),
        _buildErrorChip(AppLocalizations.of(context).errors.invalid_email),
        const SizedBox(height: 4),
        _buildErrorChip(AppLocalizations.of(context).errors.weak_password),
      ],
    );
  }

  Widget _buildErrorChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 14, color: Colors.red.shade700),
          const SizedBox(width: 4),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }
}

// Home Module Widget
class HomeModuleWidget extends StatelessWidget {
  final AppLocalizations appLocalizations;

  const HomeModuleWidget({super.key, required this.appLocalizations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context).welcome),
        const SizedBox(height: 4),
        Text(AppLocalizations.of(context).welcome_user(name: 'Alice')),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context).item_count(count: '15')),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).discount(value: '25'),
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Common Module Widget
class CommonModuleWidget extends StatelessWidget {
  final AppLocalizations appLocalizations;

  const CommonModuleWidget({super.key, required this.appLocalizations});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(label: Text(AppLocalizations.of(context).hello)),
        Chip(label: Text(AppLocalizations.of(context).yes)),
        Chip(label: Text(AppLocalizations.of(context).no)),
        Chip(label: Text(AppLocalizations.of(context).save)),
        Chip(label: Text(AppLocalizations.of(context).cancel)),
      ],
    );
  }
}

// Settings Module Widget
class SettingsModuleWidget extends StatelessWidget {
  final Locale locale;

  const SettingsModuleWidget({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.person),
          title: Text(AppLocalizations.of(context).profile.title),
          subtitle: Text(AppLocalizations.of(context).profile.edit_profile),
          dense: true,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.palette),
          title: Text(AppLocalizations.of(context).preferences.theme),
          dense: true,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.language),
          title: Text(AppLocalizations.of(context).preferences.language),
          dense: true,
        ),
      ],
    );
  }
}
