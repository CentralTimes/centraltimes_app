import 'dart:math';

import 'package:app/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleView extends StatelessWidget {
  final PostModel post;
  const ArticleView({required this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Central Times"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add_outlined)),
          IconButton(
              onPressed: () {
                Share.share("${post.title} - Central Times",
                    subject: "${post.title} - Central Times");
              },
              icon: Icon(Icons.share)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title,
                    style: TextStyle(fontSize: 28, height: 1.5))),
            Padding(padding: EdgeInsets.all(16)),
            if (post.author != null && post.author != "") ...[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.author.toString(),
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
                        .format(post.date),
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black.withOpacity(0.6)))),
            Padding(padding: EdgeInsets.all(8)),
            Html(data: post.content),
          ])),
        ],
      ),
    );
  }
}
