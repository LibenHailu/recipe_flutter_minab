import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Recipe extends Equatable {
  Recipe(
      {this.id,
      @required this.name,
      @required this.description,
      this.filePath});

  final int id;
  final String name;
  final String description;
  final String filePath;

  @override
  List<Object> get props => [id, name, description, filePath];

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      filePath: json['file_path'],
    );
  }

  @override
  String toString() =>
      'Recipe { id: $id, name: $name, description: $description, file_path: $filePath }';
}
