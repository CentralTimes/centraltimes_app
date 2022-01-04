import 'package:app/models/post_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/views/home_view/home_view_logic.dart';
import 'package:app/widgets/post_preview_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
      drawer: const AppDrawer(),
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
                      floating: false,
                    )
                  ];
                },
                body: TabBarView(
                    controller: logic.tabController,
                    children: List.generate(logic.tabController!.length,
                        (index) => _PostListView(index: index))));
          }),
    );
  }
}

class _PostListView extends StatelessWidget {
  final int index;
  const _PostListView({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeViewLogic logic = getIt<HomeViewLogic>();
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: () async {
          logic.pagingControllers[index].refresh();
        },
        child: PagedListView<int, PostModel>.separated(
            pagingController: logic.pagingControllers[index],
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, data, index) =>
                    PostPreviewCardWidget(post: data)),
            separatorBuilder: (context, index) =>
                const Padding(padding: EdgeInsets.all(8))),
      ),
    );
  }
}
