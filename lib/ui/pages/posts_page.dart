import 'package:app/models/tab_category_model.dart';
import 'package:app/services/wordpress/ct_tab_category_service.dart';
import 'package:app/ui/list/post_list/post_list_view.dart';
import 'package:app/ui/page_template.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  late TabController tabController;
  List<TabCategoryModel>? tabCategories;
  @override
  void initState() {
    CtTabCategoryService.getTabCategories().then((newTabCategories) {
      tabCategories = newTabCategories;
      tabController =
          TabController(vsync: this, length: tabCategories!.length + 1);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tabCategories == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tabCategories!.isEmpty) {
      return const PageTemplate(child: PostListView());
    }
    return PageTemplate(
        bottom: TabBar(isScrollable: true, controller: tabController, tabs: [
          const Tab(child: Text("All")),
          ...tabCategories!.map((e) => Tab(child: Text(e.name))).toList()
        ]),
        child: TabBarView(controller: tabController, children: [
          const PostListView(),
          ...tabCategories!.map((e) => PostListView(category: e.id)).toList()
        ]));
  }
}
