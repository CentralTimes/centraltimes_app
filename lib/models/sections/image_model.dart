import 'package:app/models/media_model.dart';
import 'package:app/models/sections/section_model.dart';
import 'package:flutter/material.dart';

class ImageModel extends SectionModel {
  final int id;
  final String? caption;

  const ImageModel({required this.id, this.caption});

  @override
  String toString() {
    return 'ImageModel{id: $id, caption: $caption}';
  }
}
