import 'dart:async';

import 'package:app/services/firestore_service.dart';
import 'package:app/widgets/bottom-nav-bar.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/widgets/news-card.dart';
import 'package:app/widgets/search.dart';
import 'package:app/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? categoryStreamSub;
  List<Stream<List<Map<String, dynamic>>>>? snippetsStreamList;
  List<StreamController<List<Map<String, dynamic>>>>? snippetsControllerList;
  TabController? tabController;
  List<Map<String, dynamic>>? categoryData;
  late List<DateTime> lastUpdatedList;
  static const double cooldownSecs = 30;

  @override
  void initState() {
    super.initState();

    categoryStreamSub =
        FirestoreService.getCategoryStream().listen((data) async {
      if (!categoryData.isNull) {
        setState(() {
          categoryData = null;
        });
      }
      var cData = (data.get("categories") as List<dynamic>)
          .cast<Map<String, dynamic>>();
      tabController = TabController(vsync: this, length: cData.length);
      snippetsControllerList = cData
          .map((_) => StreamController<List<Map<String, dynamic>>>())
          .toList();
      snippetsStreamList = snippetsControllerList!
          .map((controller) => controller.stream)
          .toList();
      lastUpdatedList = cData.map((_) => DateTime.now()).toList();
      tabController!.addListener(() {
        int index = tabController!.index;
        if (!categoryData.isNull &&
            DateTime.now().difference(lastUpdatedList[index]).inSeconds >
                cooldownSecs) {
          FirestoreService.getStories(categoryID: categoryData![index]["id"])
              .then((query) => snippetsControllerList![index]
                  .add(query.docs.map((doc) => doc.data()).toList()));
          lastUpdatedList[index] = DateTime.now();
        }
      });
      setState(() {
        categoryData = cData;
      });
      for (int i = 0; i < categoryData!.length; i++) {
        FirestoreService.getStories(categoryID: categoryData![i]["id"]).then(
            (query) => snippetsControllerList![i]
                .add(query.docs.map((doc) => doc.data()).toList()));
      }
    });
  }

  @override
  void dispose() {
    categoryStreamSub?.cancel();
    snippetsControllerList?.forEach((controller) => controller.close());
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Central Times"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchNewsDelegate());
                },
                icon: Icon(Icons.search))
          ],
          bottom: (categoryData.isNull)
              ? null
              : TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: categoryData!
                      .map((category) => Tab(child: Text(category["name"])))
                      .toList(),
                ),
        ),
        body: (categoryData.isNull)
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: tabController,
                children: List.generate(
                    snippetsStreamList!.length,
                    (index) => RefreshIndicator(
                        child:
                            _SnippetsPage(stream: snippetsStreamList![index]),
                        onRefresh: () async {
                          if (DateTime.now()
                                  .difference(lastUpdatedList[index])
                                  .inSeconds >
                              cooldownSecs) {
                            var query = await FirestoreService.getStories(
                                categoryID: categoryData![index]["id"]);
                            lastUpdatedList[index] = DateTime.now();
                            snippetsControllerList![index].add(
                                query.docs.map((doc) => doc.data()).toList());
                          }
                        }))));
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
                  Padding(padding: EdgeInsets.all(5)),
              itemCount: snapshot.data!.length);
        });
  }
}