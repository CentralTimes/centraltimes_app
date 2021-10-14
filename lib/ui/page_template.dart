import 'package:app/ui/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageTemplate extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? bottom;

  const PageTemplate({Key? key, this.bottom, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
            SliverAppBar(
              centerTitle: true,
              title: Text('Central Times', style: GoogleFonts.roboto()),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: SearchNewsDelegate());
                    },
                    icon: const Icon(Icons.search)),
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
