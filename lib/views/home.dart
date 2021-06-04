import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        drawer: Drawer(
          child: Container(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text("Central Times"),
          actions: [
            //IconButton(onPressed: showSearch(context: context, ), icon: icon)
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "News"),
              Tab(text: "Community"),
              Tab(text: "Profiles"),
              Tab(text: "Features"),
              Tab(text: "Entertainment"),
              Tab(text: "Sports"),
              Tab(text: "Opinions"),
              Tab(text: "Editorial"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ]
        ),
      ),
    );
  }
}