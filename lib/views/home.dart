import 'package:app/widgets/bottom-nav-bar.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/widgets/news-card.dart';
import 'package:app/widgets/search.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
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
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "News"),
              Tab(text: "Community"),
              Tab(text: "Profiles"),
              Tab(text: "Features"),
              Tab(text: "Entertainment"),
              Tab(text: "Sports"),
              Tab(text: "Opinions"),
              Tab(text: "Editorial"),
            ],
          ),
        ),
        body: TabBarView(children: [
          ListView(
            children: [
              NewsCard(
                  image: Placeholder(fallbackHeight: 200),
                  title: "A New Thing Happened",
                  subtitle:
                      "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                  date: "June 6",
                  secondary: NewsCard(
                      title: "Another Smaller Thing Happened",
                      subtitle:
                          "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                      date: "June 6",
                      isSecondary: true,
                      displayTrailingBar: false,
                      secondary: NewsCard(
                      title: "Another Smaller Thing Happened",
                      subtitle:
                          "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                      date: "June 6",
                      isSecondary: true,
                      displayTrailingBar: false))),
              Padding(padding: EdgeInsets.all(5)),
              NewsCard(
                title: "Another Big Thing Happened",
                subtitle:
                    "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                date: "June 6"),
            ],
          ),
          ListView(
            children: [
              NewsCard(
                title: "A Community Thing Happened",
                subtitle:
                    "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                date: "June 6"),
              Padding(padding: EdgeInsets.all(5)),
              NewsCard(
                title: "A Community Thing Happened",
                subtitle:
                    "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                date: "June 6"),
              Padding(padding: EdgeInsets.all(5)),
              NewsCard(
                title: "A Community Thing Happened",
                subtitle:
                    "orem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec eleifend urna. ",
                date: "June 6"),
            ],
          ),
          Container(),
          Container(),
          Container(),
          Container(),
          Container(),
          Container(),
        ]),
        bottomNavigationBar: BottomNavAppBar(),
      ),
    );
  }
}


