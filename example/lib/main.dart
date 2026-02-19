import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.gen.dart';

void main() {
  runApp(const LocalizationExampleApp());
}

class LocalizationExampleApp extends StatefulWidget {
  const LocalizationExampleApp({super.key});

  @override
  State<LocalizationExampleApp> createState() => _LocalizationExampleAppState();
}

class _LocalizationExampleAppState extends State<LocalizationExampleApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization Example',
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
      home: ExampleHomePage(onLanguageChange: _changeLanguage),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  final void Function(Locale) onLanguageChange;

  const ExampleHomePage({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context).strings.appTitle ?? ''),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Basic strings',
            children: [
              Text(
                'app_title: ${AppLocalizations.of(context).strings.appTitle}',
              ),
              Text(
                'powered_by: ${AppLocalizations.of(context).strings.poweredBy}',
              ),
            ],
          ),
          _Section(
            title: 'Nested keys',
            children: [
              Text(
                'simple.hello: ${AppLocalizations.of(context).simple.hello}',
              ),
              Text(
                'simple.welcome.title: ${AppLocalizations.of(context).simple.welcome.title}',
              ),
              Text(
                'deep (max 6): ${AppLocalizations.of(context).simple.app.settings.security.password.change.title}',
              ),
            ],
          ),
          _Section(
            title: 'Placeholders',
            children: [
              Text(
                AppLocalizations.of(
                      context,
                    ).placeholders.welcomeUser(name: 'Alice') ??
                    '',
              ),
              Text(
                AppLocalizations.of(
                      context,
                    ).placeholders.fullName(firstName: 'Alice', lastName: 'Doe') ??
                    '',
              ),
              Text(
                AppLocalizations.of(
                      context,
                    ).placeholders.itemsInCity(count: '12', city: 'Jakarta') ??
                    '',
              ),
            ],
          ),
          _Section(
            title: 'Formatting',
            children: [
              Text('multiline:'),
              Text(AppLocalizations.of(context).formatting.multiline ?? ''),
              Text('quotes: ${AppLocalizations.of(context).formatting.quotes}'),
              Text(
                'unicode: ${AppLocalizations.of(context).formatting.unicode}',
              ),
            ],
          ),
          _Section(
            title: 'Symbols and special characters',
            children: [
              Text(
                'masked_pin: ${AppLocalizations.of(context).symbols.maskedPin}',
              ),
              Text(
                'masked_otp: ${AppLocalizations.of(context).symbols.maskedOtp}',
              ),
              Text(
                'copyright: ${AppLocalizations.of(context).symbols.copyrightNotice}',
              ),
              Text(
                'registered: ${AppLocalizations.of(context).symbols.registeredMark}',
              ),
              Text(
                'trademark: ${AppLocalizations.of(context).symbols.trademarkNotice}',
              ),
              Text(
                'currency: ${AppLocalizations.of(context).symbols.currencyAndAmount}',
              ),
              Text(
                'percent: ${AppLocalizations.of(context).symbols.percentLike}',
              ),
              Text('math: ${AppLocalizations.of(context).symbols.mathLike}'),
              Text(
                'degree: ${AppLocalizations.of(context).symbols.degreeLike}',
              ),
              Text('arrow: ${AppLocalizations.of(context).symbols.arrowLike}'),
              Text('pipe: ${AppLocalizations.of(context).symbols.pipeLike}'),
              Text(AppLocalizations.of(context).symbols.bulletListLike ?? ''),
              Text('url: ${AppLocalizations.of(context).symbols.urlQueryLike}'),
            ],
          ),
          _Section(
            title: 'Literals (not placeholders)',
            children: [
              Text(AppLocalizations.of(context).literals.doubleCurly ?? ''),
              Text(AppLocalizations.of(context).literals.squareBrackets ?? ''),
              Text(AppLocalizations.of(context).literals.literalBraces ?? ''),
            ],
          ),
          _Section(
            title: 'Structured forms (shape validation)',
            children: [
              Text(
                'plural (5): ${AppLocalizations.of(context).structured.items(count: 5)}',
              ),
              Text(
                'gender (male): ${AppLocalizations.of(context).structured.userTitle(gender: 'male', lastName: 'Doe')}',
              ),
              Text(
                'context (formal): ${AppLocalizations.of(context).structured.greeting(context: 'formal', name: 'Alice')}',
              ),
            ],
          ),
          _Section(
            title: 'Runtime key lookup (resolveByKey)',
            children: [
              Text(
                "resolveByKey('strings.app_title'): ${AppLocalizations.of(context).resolveByKey('strings.app_title') ?? '<missing>'}",
              ),
              Text(
                "resolveByKey('app_title', namespace: 'strings'): ${AppLocalizations.of(context).resolveByKey('app_title', namespace: 'strings') ?? '<missing>'}",
              ),
              Text(
                "resolveByKey('missing.key'): ${AppLocalizations.of(context).resolveByKey('missing.key') ?? '<missing>'}",
              ),
            ],
          ),
          _Section(
            title: 'Multi-variant errors (context: register/verification)',
            children: [
              Text(
                "invalid_code_errors(register): ${AppLocalizations.of(context).structured.invalidCodeErrors(context: 'register') ?? '<missing>'}",
              ),
              Text(
                "invalid_code_errors(verification): ${AppLocalizations.of(context).structured.invalidCodeErrors(context: 'verification') ?? '<missing>'}",
              ),
              Text(
                "action_label(primary): ${AppLocalizations.of(context).structured.actionLabel(context: 'primary') ?? '<missing>'}",
              ),
              Text(
                "action_label(secondary): ${AppLocalizations.of(context).structured.actionLabel(context: 'secondary') ?? '<missing>'}",
              ),
            ],
          ),
        ],
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
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children.map(
              (w) =>
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: w),
            ),
          ],
        ),
      ),
    );
  }
}
