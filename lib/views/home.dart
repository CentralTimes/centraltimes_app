import 'dart:async';

import 'package:app/services/firestore_service.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/widgets/news-card.dart';
import 'package:app/widgets/search.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late List<Stream<List<Map<String, dynamic>>>> snippetsStreamList;
  late List<StreamController<List<Map<String, dynamic>>>>
      snippetsControllerList;
  late TabController tabController;
  late List<DateTime?> lastUpdatedList;
  List<Map<String, dynamic>>? categoryData;
  static const double cooldownSecs = 30;

  @override
  void initState() {
    super.initState();
    FirestoreService.getCategories().then((data) {
      var cData = (data.get("categories") as List<dynamic>)
          .cast<Map<String, dynamic>>();
      tabController = TabController(vsync: this, length: cData.length);
      snippetsControllerList = cData
          .map((_) => StreamController<List<Map<String, dynamic>>>())
          .toList();
      snippetsStreamList = snippetsControllerList
          .map((controller) => controller.stream)
          .toList();
      lastUpdatedList = List.filled(cData.length, null);
      setState(() {
        categoryData = cData;
      });
      tabController.addListener(() {
        int index = tabController.index;
        refreshCategory(index);
      });
      refreshCategory(0);
    });
  }

  @override
  void dispose() {
    snippetsControllerList.forEach((controller) => controller.close());
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
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
                bottom: (categoryData == null)
                    ? null
                    : TabBar(
                        controller: tabController,
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        tabs: categoryData!
                            .map((category) =>
                                Tab(child: Text(category["name"])))
                            .toList(),
                      ),
                pinned: true,
                floating: true,
              )
            ];
          },
          body: (categoryData == null)
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: tabController,
                  children: List.generate(
                      snippetsStreamList.length,
                      (index) => RefreshIndicator(
                          child:
                              _SnippetsPage(stream: snippetsStreamList[index]),
                          onRefresh: () async {
                            refreshCategory(index);
                          }))),
        ));
  }

  void refreshCategory(int index) {
    if (lastUpdatedList[index] == null ||
        DateTime.now().difference(lastUpdatedList[index]!).inSeconds >
            cooldownSecs) {
      FirestoreService.getStories(categoryID: categoryData![index]["id"]).then(
          (query) => snippetsControllerList[index]
              .add(query.docs.map((doc) => doc.data()).toList()));
      lastUpdatedList[index] = DateTime.now();
    }
  }
}

class _SnippetsPage extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> stream;

  const _SnippetsPage({Key? key, required this.stream}) : super(key: key);
  @override
  __SnippetsPageState createState() => __SnippetsPageState();
}

class __SnippetsPageState extends State<_SnippetsPage>
    with AutomaticKeepAliveClientMixin<_SnippetsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.separated(
              itemBuilder: (context, index) {
                return NewsCard(data: snapshot.data![index]);
              },
              separatorBuilder: (context, index) =>
                  Padding(padding: EdgeInsets.all(8)),
              itemCount: snapshot.data!.length);
        });
  }
}
