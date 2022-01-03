import 'package:app/services/logic_getit_init.dart';
import 'package:app/ui/drawer.dart';
import 'package:app/ui/list/post_list/post_list_view.dart';
import 'package:app/ui/pages/posts_page.dart';
import 'package:app/ui/pages/saveds_page.dart';
import 'package:app/views/home_view/home_view_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> /*with TickerProviderStateMixin*/ {
  //int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined), label: "News"),
          //BottomNavigationBarItem(icon: Icon(Icons.poll_outlined), label: "Surveys"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_outlined), label: "Saved")
        ]),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 1:
                  return Container();
                default:
                  return const _PostsPage();
              }
            },
          );
        });
    /*
    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
                bottomIndex = value;
              }),
          currentIndex: bottomIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined), label: "News"),
            //BottomNavigationBarItem(icon: Icon(Icons.poll_outlined), label: "Surveys"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmarks_outlined), label: "Saved"),
          ]),
      body: [const PostsPage(), const SavedsPage()][bottomIndex],
    );*/
  }
}

class _PostsPage extends StatefulWidget {
  const _PostsPage({Key? key}) : super(key: key);

  @override
  __PostsPageState createState() => __PostsPageState();
}

class __PostsPageState extends State<_PostsPage> with TickerProviderStateMixin {
  final HomeViewLogic logic = getIt<HomeViewLogic>();
  @override
  void initState() {
    super.initState();
    logic.initPostsPage(this);
  }

  @override
  void dispose() {
    logic.resetPostsPage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: logic.postsPageInitializedNotifier,
          builder: (context, value, child) {
            if (value == false) {
              return const Center(child: CircularProgressIndicator());
            }
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                    SliverAppBar(
                      centerTitle: true,
                      title: const Text('Central Times'),
                      /*actions: [
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context, delegate: SearchNewsDelegate());
                          },
                          icon: const Icon(Icons.search)),
                    ],*/
                      bottom: TabBar(
                          controller: logic.tabController,
                          isScrollable: true,
                          tabs: [
                            const Tab(child: Text("All")),
                            ...logic.tabCategories
                                .map((e) => Tab(child: Text(e.name)))
                                .toList()
                          ]),
                      pinned: true,
                      floating: true,
                    )
                  ];
                },
                body: TabBarView(controller: logic.tabController, children: [
                  const PostListView(),
                  ...logic.tabCategories.map((e) => Text("${e.id}")).toList()
                ]));
          }),
    );
  }
}
