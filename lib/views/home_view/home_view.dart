import 'package:app/logic/posts_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/wordpress/ct_shortcode_service.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/views/home_view/home_view_logic.dart';
import 'package:app/widgets/post_preview_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:app_settings/app_settings.dart';

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
                  return const _SavedPage();
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
            if (value == false &&
                CtShortcodeService.getShortcodeNames().isEmpty) {
              //After the app doesnt error out because of missing wifi errors it correctly displays a missing wifi symbol and it looks nice.
              return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context)),
                      const SliverAppBar(
                        centerTitle: true,
                        title: Text('Central Times'),
                        pinned: true,
                        floating: false,
                      )
                    ];
                  },
                  body: const Center(
                    child: IconButton(
                      onPressed: AppSettings.openWIFISettings,
                      icon: Icon(
                          Icons.signal_wifi_connected_no_internet_4_rounded),
                    ),
                  ));
            }
            if (value == false &&
                CtShortcodeService.getShortcodeNames().isNotEmpty) {
              return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context)),
                      const SliverAppBar(
                        centerTitle: true,
                        title: Text('Central Times'),
                        pinned: true,
                        floating: false,
                      )
                    ];
                  },
                  body: const Center(child: CircularProgressIndicator()));
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
                          indicatorColor:
                              Theme.of(context).colorScheme.background,
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
    //if (CtShortcodeService.getShortcodeNames().isNotEmpty) {
    //This essentially checks to see if WP api has worked and if it hasnt this list will be empty. (This usually is caused by an internet error so then it displays a please check connection page)
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
                itemBuilder: (context, data, index) => PostPreviewCardWidget(
                    post: data,
                    onSave: () async {
                      await SavedPostsService.togglePost(data.id,
                          onAdd: (int index) {
                        if (logic.savedListKey.currentState != null) {
                          logic.savedListKey.currentState!.insertItem(index);
                        }
                      }, onRemove: (int index) {
                        if (logic.savedListKey.currentState != null) {
                          logic.savedListKey.currentState!.removeItem(index,
                              (context, animation) {
                            return SizeTransition(sizeFactor: animation);
                          });
                        }
                      });
                    })),
            separatorBuilder: (context, index) =>
                const Padding(padding: EdgeInsets.all(8))),
      ),
    );
    //} else {}
  }
}

class _SavedPage extends StatefulWidget {
  const _SavedPage({Key? key}) : super(key: key);

  @override
  __SavedPageState createState() => __SavedPageState();
}

class __SavedPageState extends State<_SavedPage> {
  final HomeViewLogic logic = getIt<HomeViewLogic>();
  @override
  void initState() {
    super.initState();
    logic.initSavedPage();
  }

  @override
  void dispose() {
    logic.resetSavedPage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: ValueListenableBuilder<bool>(
          valueListenable: logic.savedPageInitializedNotifier,
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
                  const SliverAppBar(
                    centerTitle: true,
                    title: Text('Central Times'),
                    pinned: true,
                    floating: false,
                  )
                ];
              },
              body: const _SavedListView(),
            );
          }),
    );
  }
}

class _SavedListView extends StatefulWidget {
  const _SavedListView({Key? key}) : super(key: key);

  @override
  __SavedListViewState createState() => __SavedListViewState();
}

class __SavedListViewState extends State<_SavedListView> {
  final int initialItemCount = SavedPostsService.getPosts().length;

  @override
  Widget build(BuildContext context) {
    PostsLogic postsLogic = getIt<PostsLogic>();
    HomeViewLogic logic = getIt<HomeViewLogic>();
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: AnimatedList(
        padding: const EdgeInsets.only(bottom: 80),
        key: logic.savedListKey,
        initialItemCount: initialItemCount,
        itemBuilder: (context, index, animation) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PostPreviewCardWidget(
              post: postsLogic.getPostFromCache(
                  postId: SavedPostsService.getPosts()[index])!,
              onSave: () async {
                int id = postsLogic
                    .getPostFromCache(
                        postId: SavedPostsService.getPosts()[index])!
                    .id;
                await SavedPostsService.togglePost(id, onAdd: (int index) {
                  logic.savedListKey.currentState!.insertItem(index);
                }, onRemove: (int index) {
                  logic.savedListKey.currentState!.removeItem(index,
                      (context, animation) {
                    return SizeTransition(sizeFactor: animation);
                  });
                });
              },
            )),
      ),
    );
  }
}
