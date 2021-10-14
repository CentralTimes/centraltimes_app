import 'package:app/ui/list/saved_list_view.dart';
import 'package:app/ui/page_template.dart';
import 'package:flutter/material.dart';

class SavedsPage extends StatelessWidget {
  const SavedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(child: SavedListView());
  }
}
