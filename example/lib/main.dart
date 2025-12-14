import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'assets/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    // Get the localization instance
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.settings.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Common translations
            _SectionHeader(l10n.common.hello),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.home.welcome),
                subtitle: Text(l10n.home.welcomeUser(_userName)),
              ),
            ),
            const SizedBox(height: 16),

            // Auth - Login section (nested)
            _SectionHeader(l10n.auth.login.title),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(l10n.auth.login.email),
                    subtitle: const Text('user@example.com'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(l10n.auth.login.password),
                    subtitle: const Text('••••••••'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(l10n.auth.login.button),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(l10n.auth.login.forgotPassword),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Auth - Register section (nested)
            _SectionHeader(l10n.auth.register.title),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_add),
                title: Text(l10n.auth.register.button),
                subtitle: Text(l10n.auth.register.termsAccept),
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
                    title: Text(l10n.auth.errors.invalidEmail),
                  ),
                  ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(l10n.auth.errors.weakPassword),
                  ),
                  ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(l10n.auth.errors.userNotFound),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings - Profile section (deeply nested)
            _SectionHeader(l10n.settings.profile.title),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(l10n.settings.profile.editProfile),
                  ),
                  ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: Text(l10n.settings.profile.changePassword),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings - Preferences section (deeply nested)
            _SectionHeader(l10n.settings.preferences.title),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.settings.preferences.language),
                    trailing: const Text('English'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: Text(l10n.settings.preferences.theme),
                    trailing: const Text('Light'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(l10n.settings.preferences.notifications),
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
                title: Text(l10n.home.itemCount('$_itemCount')),
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

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: Text(l10n.common.save),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cancel),
                  label: Text(l10n.common.cancel),
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
                  child: Text(l10n.common.yes),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(l10n.common.no),
                ),
              ],
            ),
          ],
        ),
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
