import 'package:flutter/material.dart';
import 'package:minabapp/recipe/screens/add_update_recipe.dart';
import '../recipe.dart';

class RecipeAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => RecipeList());
    }

    if (settings.name == AddUpdateRecipe.routeName) {
      RecipeArgument args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => AddUpdateRecipe(
                args: args,
              ));
    }

    if (settings.name == RecipeDetail.routeName) {
      Recipe recipe = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => RecipeDetail(
                recipe: recipe,
              ));
    }

    return MaterialPageRoute(builder: (context) => RecipeList());
  }
}

class RecipeArgument {
  final Recipe recipe;
  final bool edit;
  RecipeArgument({this.recipe, this.edit});
}
