import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'assets/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // Static method to change locale from anywhere in the app
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization Gen Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Setup localization
      localizationsDelegates: const [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _itemCount = 5;
  final String _userName = 'John Doe';

  void _changeLanguage(Locale locale) {
    MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context).settings.title),
        actions: [
          // Language selector popup menu
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: AppLocalizations.of(context).settings.preferences.language,
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<Locale>(
                value: const Locale('en'),
                child: Row(
                  children: [
                    const Text('English'),
                    if (currentLocale.languageCode == 'en') ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Colors.green),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: const Locale('id'),
                child: Row(
                  children: [
                    const Text('Indonesia'),
                    if (currentLocale.languageCode == 'id') ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Colors.green),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: const Locale('es'),
                child: Row(
                  children: [
                    const Text('Español'),
                    if (currentLocale.languageCode == 'es') ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Colors.green),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Language selector card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.translate, color: Colors.blue, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).settings.preferences.language,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Current: ${_getLanguageName(currentLocale.languageCode)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _LanguageChip(
                          flag: '',
                          label: 'English',
                          locale: const Locale('en'),
                          isSelected: currentLocale.languageCode == 'en',
                          onTap: () => _changeLanguage(const Locale('en')),
                        ),
                        _LanguageChip(
                          flag: '',
                          label: 'Indonesia',
                          locale: const Locale('id'),
                          isSelected: currentLocale.languageCode == 'id',
                          onTap: () => _changeLanguage(const Locale('id')),
                        ),
                        _LanguageChip(
                          flag: '',
                          label: 'Español',
                          locale: const Locale('es'),
                          isSelected: currentLocale.languageCode == 'es',
                          onTap: () => _changeLanguage(const Locale('es')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Common translations
            _SectionHeader(AppLocalizations.of(context).common.hello),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context).home.welcome),
                subtitle: Text(
                  AppLocalizations.of(context).home.welcome_user(_userName),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Auth - Login section (nested)
            _SectionHeader(AppLocalizations.of(context).auth.login.title),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(AppLocalizations.of(context).auth.login.email),
                    subtitle: const Text('user@example.com'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(
                      AppLocalizations.of(context).auth.login.password,
                    ),
                    subtitle: const Text('••••••••'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context).auth.login.button,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(
                              context,
                            ).auth.login.forgot_password,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Auth - Register section (nested)
            _SectionHeader(AppLocalizations.of(context).auth.register.title),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_add),
                title: Text(AppLocalizations.of(context).auth.register.button),
                subtitle: Text(
                  AppLocalizations.of(context).auth.register.terms_accept,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Auth - Errors section (nested)
            _SectionHeader('Auth Errors'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(
                      AppLocalizations.of(context).auth.errors.invalid_email,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(
                      AppLocalizations.of(context).auth.errors.weak_password,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(
                      AppLocalizations.of(context).auth.errors.user_not_found,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings - Profile section (deeply nested)
            _SectionHeader(AppLocalizations.of(context).settings.profile.title),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(
                      AppLocalizations.of(context).settings.profile.edit_profile,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: Text(
                      AppLocalizations.of(
                        context,
                      ).settings.profile.change_password,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings - Preferences section (deeply nested)
            _SectionHeader(
              AppLocalizations.of(context).settings.preferences.title,
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(
                      AppLocalizations.of(
                        context,
                      ).settings.preferences.language,
                    ),
                    trailing: Text(_getLanguageName(currentLocale.languageCode)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: Text(
                      AppLocalizations.of(context).settings.preferences.theme,
                    ),
                    trailing: const Text('Light'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(
                      AppLocalizations.of(
                        context,
                      ).settings.preferences.notifications,
                    ),
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items with counter
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory),
                title: Text(
                  AppLocalizations.of(context).home.item_count('$_itemCount'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_itemCount > 0) _itemCount--;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _itemCount++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Discount example
            Card(
              child: ListTile(
                leading: const Icon(Icons.discount, color: Colors.green),
                title: Text(
                  AppLocalizations.of(context).home.discount('20'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                subtitle: const Text('Example: discount("20") returns localized string'),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context).common.save),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cancel),
                  label: Text(AppLocalizations.of(context).common.cancel),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Yes/No buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context).common.yes),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context).common.no),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'id':
        return 'Indonesia';
      case 'es':
        return 'Español';
      default:
        return languageCode;
    }
  }
}

class _LanguageChip extends StatelessWidget {
  final String flag;
  final String label;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.flag,
    required this.label,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Text(flag, style: const TextStyle(fontSize: 20)),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.blue.shade200,
      checkmarkColor: Colors.blue.shade900,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
