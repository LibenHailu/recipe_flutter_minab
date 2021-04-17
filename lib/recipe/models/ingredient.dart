import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Ingredient extends Equatable {
  Ingredient({this.id, @required this.name, this.recipe_id});

  final int id;
  final String name;
  final int recipe_id;

  @override
  List<Object> get props => [id, name, recipe_id];

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      recipe_id: json['recipe_id'],
    );
  }

  @override
  String toString() =>
      'Ingredient { id: $id, name: $name, recipe_id: $recipe_id}';
}
