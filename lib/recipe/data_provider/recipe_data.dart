import 'package:graphql/client.dart';
import 'package:minabapp/recipe/models/file.dart';
import 'package:minabapp/recipe/models/ingredient.dart';
import '../../config/client.dart';
import '../models/models.dart';
import 'dart:convert';

class RecipeDataProvider {
  Future<List<Recipe>> getRecipes() async {
    const String readRecipes = r'''
        query MyQuery {
          recipes {
            description
            id
            name
            file {
              file_path
            }
          }
        }
    ''';

    final QueryOptions options = QueryOptions(document: gql(readRecipes));

    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      throw Exception('Failed to load recipe');
    }

    final recipes = result.data['recipes'] as List;
    List<Recipe> myRecipes = [];
    for (var x = 0; x < recipes.length; x++) {
      myRecipes.add(Recipe.fromJson(recipes[x]));
    }

    return myRecipes;
  }

  static Future<Recipe> createRecipeFileIngredient(
      MyFile file, Recipe newRecipe, List<Ingredient> ingredients) async {
    const String uploadFile = r'''
       mutation MyMutation ($base64str:String!,$name:String!,$type:String!){
  fileUpload(base64str: $base64str, name: $name, type: $type) {
    file_path
    id
  }
}
    ''';
    final MutationOptions options = MutationOptions(
        document: gql(uploadFile),
        variables: <String, dynamic>{
          "base64str": file.base64str,
          "name": file.name,
          "type": file.type
        });

    final QueryResult myFile = await client.mutate(options);

    var file_path = myFile.data['fileUpload']['file_path'];
    var file_id = myFile.data['fileUpload']['id'];
    if (myFile.hasException) {
      print(myFile.exception.toString());
      // return;
    }

    const String addRecipe = r'''
    mutation MyMutation ($description:String!,$file_id:Int!,$name:String!){
  insert_recipes_one(object: {description:$description, file_id: $file_id, name: $name}) {
    description
    file_id
    id
    name
  }
}
    ''';
    final MutationOptions addRecipeOptions =
        MutationOptions(document: gql(addRecipe), variables: <String, dynamic>{
      "description": newRecipe.description,
      "file_id": myFile.data['fileUpload']['id'],
      "name": newRecipe.name
    });
    final QueryResult recipe = await client.mutate(addRecipeOptions);

    if (recipe.hasException) {
      print(recipe.exception.toString());
      // return;
    }

    int recipe_id = recipe.data['insert_recipes_one']['id'];

    Recipe finalRecipe = Recipe.fromJson({
      ...recipe.data['insert_recipes_one'],
      'file_path': file_path,
      'file_id': file_id
    });
    for (var x = 0; x < ingredients.length; x++) {
      String addIngredeint = r'''
  mutation MyMutation($name:String!,$recipe_id:Int!) {
  insert_ingredients_one(object: {name:$name, recipe_id: $recipe_id}) {
    id
    name
    recipe_id
  }
}

    ''';

      final MutationOptions addIngredientOptions = MutationOptions(
          document: gql(addIngredeint),
          variables: <String, dynamic>{
            "name": ingredients[x].name,
            "recipe_id": recipe_id
          });
      final QueryResult ingredient = await client.mutate(addIngredientOptions);

      if (ingredient.hasException) {
        print(ingredient.exception.toString());
        // return;
      }
      print(finalRecipe);
      return finalRecipe;
    }
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    return recipe;
  }
}
