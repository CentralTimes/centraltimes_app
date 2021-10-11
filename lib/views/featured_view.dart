import 'dart:convert';

import 'package:app/models/post_model.dart';
import 'package:app/ui/save_button.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeaturedView extends StatefulWidget {
  final PostModel post;

  FeaturedView(this.post);

  @override
  State<FeaturedView> createState() => _FeaturedViewState();
}

class _FeaturedViewState extends State<FeaturedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Central Times"),
          actions: [
            SaveButton(
              widget.post.id,
              iconColor: Colors.white,
            ),
            IconButton(
                onPressed: () {
                  Share.share(widget.post.link,
                      subject: "${widget.post.title} - Central Times");
                },
                icon: Icon(Icons.share)),
          ],
        ),
        body: Container(
            child: WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webViewController.loadUrl(Uri.dataFromString(_generateHtml(),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                .toString());
          },
        )));
  }

  _generateHtml() {
    return """<!DOCTYPE html><html style='background-color: black;'><head><style>* {max-width: 100vw; margin: 0;}</style></head><body>${widget.post.video[0]}</body></html>""";
  }
}
