import 'package:app/models/tab_category_model.dart';
import 'package:app/services/ct/ct_tab_category_service.dart';
import 'package:app/ui/list/post_list/post_list_view.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TabCategoryModel>>(
      future: CtTabCategoryService.getTabCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          tabController =
              TabController(vsync: this, length: snapshot.data!.length + 1);
          return Column(
            children: [
              Flexible(
                flex: 0,
                  child: Container(
                      color: Colors.red,
                      child: TabBar(
                          controller: tabController,
                          isScrollable: true,
                          indicatorColor: Colors.white,
                          tabs: [
                            Tab(child: Text("All")),
                            ...snapshot.data!
                                .map((e) => Tab(child: Text(e.name)))
                                .toList()
                          ]))),
              Flexible(
                  child: TabBarView(controller: tabController, children: [
                PostListView(),
                ...snapshot.data!.map((e) => PostListView(category: e.id))
              ]))
            ],
          );
        } else {
          return Placeholder();
        }
      },
    );
  }
}
