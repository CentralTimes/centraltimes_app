import 'package:flutter/material.dart';

class ArticleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Central Times"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        ],
      ),
    );
  }
}
