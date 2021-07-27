import 'package:app/widgets/img_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleView extends StatelessWidget {
  final Map<String, dynamic> data;
  const ArticleView({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Central Times"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add_outlined)),
          IconButton(onPressed: () {
            Share.share("${data["title"]} - Central Times", subject: "${data["title"]} - Central Times");
          }, icon: Icon(Icons.share)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(data["title"],
                    style: TextStyle(fontSize: 28, height: 1.5))),
            if (data["subtitle"] != null &&
                data["subtitle"] != "") ...[
              Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(data["subtitle"],
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          color: Colors.black.withOpacity(0.6)))),
            ],
            Padding(padding: EdgeInsets.all(16)),
            if (data["author"] != null &&
                data["author"] != "") ...[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(data["author"],
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontStyle: FontStyle.italic))),
              Padding(padding: EdgeInsets.all(4)),
            ],
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    DateFormat("MMMM d, yyyy - h:mm a")
                        .format(data["date"].toDate()),
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black.withOpacity(0.6)))),
            Padding(padding: EdgeInsets.all(8)),
          ])),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            switch (data["sections"][index]["type"]) {
              case "IMAGE":
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CachedNetworkImage(
                          imageUrl: data["sections"][index]["url"],
                          placeholder: (context, url) => ImagePlaceholder(
                              width: data["sections"][index]["width"],
                              height: data["sections"][index]["height"])),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: MarkdownBody(
                          data: data["sections"][index]["caption"],
                          styleSheet:
                              MarkdownStyleSheet.fromTheme(Theme.of(context))
                                  .copyWith(
                            p: TextStyle(fontSize: 16, height: 1.2),
                          ),
                          onTapLink: (text, href, title) {
                            if (href != null) launch(href);
                          },
                        )),
                  ],
                );
              default:
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: MarkdownBody(
                    data: data["sections"][index]["text"],
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: TextStyle(fontSize: 20, height: 1.5),
                    ),
                    onTapLink: (text, href, title) {
                      if (href != null) launch(href);
                    },
                  ),
                );
            }
          }, childCount: data["sections"].length)),
        ],
      ),
    );
  }
}
