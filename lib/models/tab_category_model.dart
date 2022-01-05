import 'package:app/models/object_model.dart';

class TabCategoryModel extends ObjectModel {
  final String name;
  final int id;

  const TabCategoryModel(this.name, this.id);

  @override
  String toString() {
    return 'TabCategoryModel{name: $name, id: $id}';
  }
}
