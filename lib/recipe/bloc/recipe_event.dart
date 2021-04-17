import 'package:equatable/equatable.dart';
import '../recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
}

class RecipeLoad extends RecipeEvent {
  const RecipeLoad();

  @override
  List<Object> get props => [];
}

class RecipeCreate extends RecipeEvent {
  final Recipe recipe;

  const RecipeCreate(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Recipe Created {recipe: $recipe }';
}

class RecipeUpdate extends RecipeEvent {
  final Recipe recipe;

  const RecipeUpdate(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Recipe Updated {recipe: $recipe}';
}

class RecipeDelete extends RecipeEvent {
  final Recipe recipe;

  const RecipeDelete(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  toString() => 'Recipe Deleted {recipe: $recipe}';
}
