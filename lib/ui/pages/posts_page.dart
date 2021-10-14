import 'package:app/models/tab_category_model.dart';
import 'package:app/ui/list/post_list/post_list_view.dart';
import 'package:app/ui/page_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<TabCategoryModel> tabCategories =
        context.watch<List<TabCategoryModel>>();
    TabController tabController =
        TabController(vsync: this, length: tabCategories.length + 1);
    if (tabCategories.isEmpty) {
      return const PageTemplate(child: PostListView());
    }
    return PageTemplate(
        bottom: TabBar(isScrollable: true, controller: tabController, tabs: [
          const Tab(child: Text("All")),
          ...tabCategories.map((e) => Tab(child: Text(e.name))).toList()
        ]),
        child: TabBarView(controller: tabController, children: [
          const PostListView(),
          ...tabCategories.map((e) => PostListView(category: e.id))
        ]));
  }
}
