import 'package:app/ui/search.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? bottom;
  const PageTemplate({this.bottom, required this.child});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              title: Text("Central Times"),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: SearchNewsDelegate());
                    },
                    icon: Icon(Icons.search)),
              ],
              bottom: bottom,
              pinned: true,
              floating: true,
            )
          ];
        },
        body: child);
  }
}
