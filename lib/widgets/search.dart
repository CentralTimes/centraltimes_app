/*

import 'package:app/services/wordpress/wp_search_service.dart';
import 'package:flutter/material.dart';

class SearchNewsDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).canvasColor.withAlpha(150))),
        textTheme: Theme.of(context).textTheme.copyWith(
            headline6: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).canvasColor)),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Theme.of(context).canvasColor,
            selectionColor: Theme.of(context).canvasColor.withAlpha(150),
            selectionHandleColor: Theme.of(context).canvasColor));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            close(context, null);
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.search));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<PostsResults>(
      future: WordpressSearchService.getPostsResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, //.horizontal
              child: Text(
                snapshot.data!.results.toString(),
              ),
            ),
          );
        } else {
          return const ErrorScreen(
            title: "Search failed",
            message: "Application Error",
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<PostsResults>(
      future: WordpressSearchService.getPostsResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, //.horizontal
              child: Text(
                snapshot.data!.results.toString(),
              ),
            ),
          );
        } else {
          return const ErrorScreen(
            title: "Search failed",
            message: "Application Error",
          );
        }
      },
    );
  }
}*/
