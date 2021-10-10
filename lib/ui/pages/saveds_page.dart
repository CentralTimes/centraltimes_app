import 'package:app/ui/list/saved_list_view.dart';
import 'package:app/ui/page_template.dart';
import 'package:flutter/material.dart';

class SavedsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(child: SavedListView());
  }
}