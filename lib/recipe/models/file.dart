import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MyFile extends Equatable {
  MyFile({this.id, this.file_path, this.base64str, this.type, this.name});

  final int id;
  final String file_path;
  final String base64str;
  final String type;
  final String name;

  @override
  List<Object> get props => [id, file_path];

  factory MyFile.fromJson(Map<String, dynamic> json) {
    return MyFile(id: json['id'], file_path: json['file_path']);
  }

  @override
  String toString() => 'MyFile { id: $id, filepath: $file_path}';
}
