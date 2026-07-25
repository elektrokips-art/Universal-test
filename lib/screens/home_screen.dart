import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../l10n/locale_provider.dart';
import '../models/test_recipe.dart';
import '../services/excel_service.dart';
import '../state/recipes_model.dart';
import '../state/theme_provider.dart';
import 'test_edit_screen.dart';
import 'session_screen.dart';
import 'settings_screen.dart';

Future<void> _importFromExcel(BuildContext context) async {
  final locale = context.read<LocaleProvider>();
  try {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    final picked = result?.files.single;
    if (picked?.bytes == null) return;

    final fallbackName = picked!.name.replaceAll(RegExp(r'\.xlsx$', caseSensitive: false), '');
    final recipe = ExcelService.importRecipe(picked.bytes!, fallbackName: fallbackName);

    if (!context.mounted) return;
    await context.read<RecipesModel>().save(recipe);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.t('importSuccess'))),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.t('importError'))),
      );
    }
  }
}

Future<void> _exportToExcel(BuildContext context, TestRecipe recipe) async {
  final locale = context.read<LocaleProvider>();
  try {
    final bytes = ExcelService.exportRecipe(recipe);
    final safeName = recipe.name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    final path = await FilePicker.saveFile(
      dialogTitle: locale.t('exportTest'),
      fileName: '$safeName.xlsx',
      bytes: Uint8List.fromList(bytes),
    );

    if (path != null && !kIsWeb) {
      final file = File(path);
      final needsWrite = !(await file.exists()) || (await file.length()) != bytes.length;
      if (needsWrite) {
        await file.writeAsBytes(bytes);
      }
    }

    if (path != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.t('exportSuccess'))),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.t('exportError'))),
      );
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final recipesModel = context.watch<RecipesModel>();
    final recipes = recipesModel.recipes;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.t('myTests')),
        actions: [
          _LangButton(lang: AppLanguage.ru, label: 'RU'),
          _LangButton(lang: AppLanguage.uz, label: 'UZ'),
          IconButton(
            tooltip: themeProvider.isDark ? locale.t('themeLight') : locale.t('themeDark'),
            onPressed: () => context.read<ThemeProvider>().toggle(),
            icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            tooltip: locale.t('settings'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: recipes.isEmpty
          ? Center(child: Text(locale.t('noTests')))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return _RecipeCard(recipe: recipe);
              },
            ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'importTest',
            onPressed: () => _importFromExcel(context),
            icon: const Icon(Icons.file_open),
            label: Text(locale.t('importTest')),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            heroTag: 'newTest',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TestEditScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(locale.t('newTest')),
          ),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final AppLanguage lang;
  final String label;
  const _LangButton({required this.lang, required this.label});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final active = locale.language == lang;
    return TextButton(
      onPressed: () => context.read<LocaleProvider>().setLanguage(lang),
      style: TextButton.styleFrom(
        foregroundColor: active
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: active ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final TestRecipe recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('${recipe.questions.length} ${locale.t('question').toLowerCase()}(s)'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SessionScreen(recipe: recipe),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(locale.t('start')),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TestEditScreen(existing: recipe),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(locale.t('edit')),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(locale.t('delete')),
                        content: Text(recipe.name),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(locale.t('cancel')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(locale.t('delete')),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<RecipesModel>().delete(recipe.id);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: Text(locale.t('delete')),
                ),
                OutlinedButton.icon(
                  onPressed: () => _exportToExcel(context, recipe),
                  icon: const Icon(Icons.ios_share),
                  label: Text(locale.t('exportTest')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
