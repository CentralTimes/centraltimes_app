import 'package:app/models/tab_category_model.dart';
import 'package:app/services/ct/ct_tab_category_service.dart';
import 'package:app/ui/list/post_list/post_list_view.dart';
import 'package:app/ui/page_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsPage extends StatefulWidget {
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
      return PageTemplate(child: PostListView());
    }
    return PageTemplate(
        bottom: TabBar(isScrollable: true, controller: tabController, tabs: [
          Tab(child: Text("All")),
          ...tabCategories.map((e) => Tab(child: Text(e.name))).toList()
        ]),
        child: Flexible(
            child: TabBarView(controller: tabController, children: [
          PostListView(),
          ...tabCategories.map((e) => PostListView(category: e.id))
        ])));
  }
}
