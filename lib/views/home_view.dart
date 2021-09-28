import 'package:app/ui/custom_dialogs.dart';
import 'package:app/ui/drawer.dart';
import 'package:app/ui/pages/posts_page.dart';
import 'package:app/ui/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController tabController;
  int bottomIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        body: NestedScrollView(
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
                      icon: Icon(Icons.search))
                ],
                pinned: true,
                floating: false,
              )
            ];
          },
          body: PostsPage(),
        ));
  }

}
