import 'package:flutter/foundation.dart';

import '../models/test_recipe.dart';
import '../services/recipe_storage.dart';

class RecipesModel extends ChangeNotifier {
  final RecipeStorage _storage = RecipeStorage();
  List<TestRecipe> _recipes = [];

  List<TestRecipe> get recipes => List.unmodifiable(_recipes);

  Future<void> load() async {
    _recipes = await _storage.loadAll();
    _recipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> save(TestRecipe recipe) async {
    await _storage.upsert(recipe);
    await load();
  }

  Future<void> delete(String id) async {
    await _storage.delete(id);
    await load();
  }
}
