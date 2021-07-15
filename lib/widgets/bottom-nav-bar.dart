import 'package:flutter/material.dart';

class BottomNavAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: "News"),
      BottomNavigationBarItem(icon: Icon(Icons.poll_outlined), label: "Surveys"),
      BottomNavigationBarItem(icon: Icon(Icons.bookmarks_outlined), label: "Saved"),
    ]
    );
  }
}