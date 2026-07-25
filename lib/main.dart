import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/locale_provider.dart';
import 'services/ai_settings.dart';
import 'state/recipes_model.dart';
import 'state/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const UniversalTestApp());
}

class UniversalTestApp extends StatefulWidget {
  const UniversalTestApp({super.key});

  @override
  State<UniversalTestApp> createState() => _UniversalTestAppState();
}

class _UniversalTestAppState extends State<UniversalTestApp> {
  final LocaleProvider _locale = LocaleProvider();
  final RecipesModel _recipes = RecipesModel();
  final AiSettings _aiSettings = AiSettings();
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _locale.load();
    _recipes.load();
    _aiSettings.load();
    _themeProvider.load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _locale),
        ChangeNotifierProvider.value(value: _recipes),
        ChangeNotifierProvider.value(value: _aiSettings),
        ChangeNotifierProvider.value(value: _themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'Universal Test',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.mode,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFF2F6FEB),
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: const Color(0xFF2F6FEB),
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
