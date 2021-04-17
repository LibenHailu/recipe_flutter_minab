import 'package:equatable/equatable.dart';
import '../recipe.dart';

class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeLoading extends RecipeState {}

class RecipeLoadSuccess extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoadSuccess([this.recipes = const []]);

  @override
  List<Object> get props => [recipes];
}

class RecipeOperationFailure extends RecipeState {}
