import 'package:app/views/article.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final bool displayTrailingBar;
  final String? subtitle;
  final Widget? image;

  NewsCard(
      {required this.title,
      required this.date,
      this.subtitle,
      this.image,
      this.displayTrailingBar = true});
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 8,
                  spreadRadius: -15,
                ),
                BoxShadow(
                  offset: Offset(0, -5),
                  blurRadius: 8,
                  spreadRadius: -15,
                ),
              ],
            ),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticleView())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image ?? Container(),
                ListTile(
                    title: Text(title,
                        style: Theme.of(context).textTheme.headline5),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    subtitle: Text(subtitle ?? "")),
                if (displayTrailingBar)
                  ListTile(
                      title: Text(date,
                          style: Theme.of(context).textTheme.bodyText2),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.bookmark_add_outlined)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.share)),
                        ],
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
