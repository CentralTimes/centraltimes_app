import 'package:app/ui/drawer.dart';
import 'package:app/ui/pages/posts_page.dart';
import 'package:app/ui/pages/saveds_page.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int bottomIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
                bottomIndex = value;
              }),
          currentIndex: bottomIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined), label: "News"),
            //BottomNavigationBarItem(icon: Icon(Icons.poll_outlined), label: "Surveys"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmarks_outlined), label: "Saved"),
          ]),
      body: [PostsPage(), SavedsPage()][bottomIndex],
    );
  }
}
