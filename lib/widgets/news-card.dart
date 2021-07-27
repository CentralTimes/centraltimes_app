import 'package:app/views/article.dart';
import 'package:app/widgets/img_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> data;

  NewsCard({required this.data});
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
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: getHeadMedia((data["sections"] as List<dynamic>)
                            .cast<Map<String, dynamic>>()) ??
                        Container(),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(data["title"],
                          style: TextStyle(fontSize: 28))),
                  if (data["subtitle"] != null && data["subtitle"] != "") ...[
                    Padding(padding: EdgeInsets.all(4)),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(data["subtitle"],
                            style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.6)))),
                  ],
                  ListTile(
                      title: Text(
                          DateFormat("MMMM d").format(data["date"].toDate()),
                          style: TextStyle(fontSize: 18)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.bookmark_add_outlined)),
                          IconButton(onPressed: () {
                            Share.share("${data["title"]} - Central Times", subject: "${data["title"]} - Central Times");
                          }, icon: Icon(Icons.share)),
                        ],
                      )),
                ],
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ArticleView(data: data))),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget? getHeadMedia(List<Map<String, dynamic>> sections) {
    if (sections.isEmpty || sections[0]["url"] == null) return null;
    return CachedNetworkImage(
        imageUrl: sections[0]["url"],
        placeholder: (context, url) => ImagePlaceholder(
            width: sections[0]["width"].toDouble(),
            height: sections[0]["height"].toDouble()));
  }
}
