import 'package:flutter/cupertino.dart';

import '../recipe.dart';

class RecipeRepository {
  final RecipeDataProvider dataProvider;

  RecipeRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<Recipe> createRecipe(Recipe newRecipe) async {
    return await dataProvider.createRecipe(newRecipe);
  }

  Future<List<Recipe>> getRecipes() async {
    return await dataProvider.getRecipes();
  }
}
