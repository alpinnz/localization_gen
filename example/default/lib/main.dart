import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';

void main() {
  runApp(const DefaultLocalizationApp());
}

class DefaultLocalizationApp extends StatefulWidget {
  const DefaultLocalizationApp({super.key});

  @override
  State<DefaultLocalizationApp> createState() => _DefaultLocalizationAppState();
}

class _DefaultLocalizationAppState extends State<DefaultLocalizationApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Default Localization Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
      home: DefaultHomePage(onLanguageChange: _changeLanguage),
    );
  }
}

class DefaultHomePage extends StatefulWidget {
  final Function(Locale) onLanguageChange;

  const DefaultHomePage({super.key, required this.onLanguageChange});

  @override
  State<DefaultHomePage> createState() => _DefaultHomePageState();
}

class _DefaultHomePageState extends State<DefaultHomePage> {
  int _itemCount = 5;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context).settings.title),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: AppLocalizations.of(context).settings.preferences.language,
            onSelected: widget.onLanguageChange,
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
              _buildLanguageMenuItem(
                const Locale('es'),
                'Español',
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
            // Info Banner
            _buildInfoBanner(context),
            const SizedBox(height: 24),

            // Welcome Section
            _buildSection(
              context,
              title: AppLocalizations.of(context).home.welcome,
              icon: Icons.home,
              children: [
                Text(AppLocalizations.of(context).home.welcome_user(name: 'John Doe')),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context).home.discount(value: '20')),
              ],
            ),
            const SizedBox(height: 16),

            // Item Counter Section
            _buildSection(
              context,
              title: 'Item Counter',
              icon: Icons.inventory,
              children: [
                Text(AppLocalizations.of(context).home.item_count(count: '$_itemCount')),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _decrementCounter,
                      icon: const Icon(Icons.remove),
                      label: const Text('Remove'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _incrementCounter,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Auth Section
            _buildSection(
              context,
              title: AppLocalizations.of(context).auth.login.title,
              icon: Icons.login,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).auth.login.email,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).auth.login.password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context).auth.login.button),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context).auth.login.forgot_password),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Common Actions
            _buildSection(
              context,
              title: 'Common Actions',
              icon: Icons.apps,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(AppLocalizations.of(context).common.hello)),
                    Chip(label: Text(AppLocalizations.of(context).common.yes)),
                    Chip(label: Text(AppLocalizations.of(context).common.no)),
                    Chip(label: Text(AppLocalizations.of(context).common.save)),
                    Chip(label: Text(AppLocalizations.of(context).common.cancel)),
                  ],
                ),
              ],
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

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default (Monolithic) Approach',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'One JSON file per locale: app_en.json, app_id.json, app_es.json',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _itemCount++;
    });
  }

  void _decrementCounter() {
    if (_itemCount > 0) {
      setState(() {
        _itemCount--;
      });
    }
  }
}

