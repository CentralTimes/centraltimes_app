import 'package:app/services/firestore_service.dart';
import 'package:app/widgets/bottom-nav-bar.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/widgets/news-card.dart';
import 'package:app/widgets/search.dart';
import 'package:app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin {
  Stream<DocumentSnapshot<Map<String, dynamic>>> categoryStream =
      FirestoreService.getCategoryStream();
  TabController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirestoreService.getCategoryStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //controller?.dispose();
            controller = TabController(
                vsync: this,
                length: (snapshot.data!.get("categories")
                        as List<dynamic>)
                    .length);
          }
          return Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
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
              bottom: (snapshot.hasData)
                  ? TabBar(
                      controller: controller,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      tabs: (snapshot.data!.get("categories")
                              as List<dynamic>)
                          .map((category) => Tab(child: Text(category["name"])))
                          .toList(),
                    )
                  : null,
            ),
            body: (snapshot.hasData)
                ? TabBarView(
                    controller: controller,
                    children: List.generate(
                        controller!.length,
                        (index) => ListView.separated(
                            itemBuilder: (context, int) {
                              return NewsCard(
                                  image: Placeholder(fallbackHeight: 200),
                                  title: "A New Thing Happened",
                                  subtitle:
                                      "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                                  date: "June 6");
                            },
                            separatorBuilder: (context, int) =>
                                Padding(padding: EdgeInsets.all(5)),
                            itemCount: 5)))
                : Center(
                    child: snapshot.hasError
                        ? Text("Something Went Wrong")
                        : CircularProgressIndicator()),
          );
        });
  }
}
