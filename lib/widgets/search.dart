import 'package:flutter/material.dart';

class SearchNewsDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(textSelectionTheme: TextSelectionThemeData(cursorColor: Theme.of(context).canvasColor, selectionColor: Colors.blue.withAlpha(150)));
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            close(context, null);
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(Icons.search));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
