import 'package:app/logic/media_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/models/sections/html_model.dart';
import 'package:app/models/sections/image_model.dart';
import 'package:app/models/sections/pullquote_model.dart';
import 'package:app/models/sections/related_posts_model.dart';
import 'package:app/models/sections/unsupported_model.dart';
import 'package:app/models/sections/video_html_model.dart';
import 'package:app/models/sections/sidebar_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/widgets/saved_button.dart';
import 'package:app/views/article_view/article_view_logic.dart';
import 'package:app/widgets/media_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../featured_view.dart';

class ArticleView extends StatefulWidget {
  final PostModel post;
  const ArticleView({Key? key, required this.post}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final ScrollController _scrollController = ScrollController();
  final MediaLogic mediaLogic = getIt<MediaLogic>();
  final ArticleViewLogic logic = getIt<ArticleViewLogic>();
  @override
  void initState() {
    super.initState();
    logic.initView(widget.post);
  }

  @override
  void dispose() {
    logic.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Central Times"),
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
              icon: const Icon(Icons.share)),
        ],
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: logic.viewInitializedNotifier,
          builder: (context, value, child) {
            if (value == false) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate.fixed([
                  const Padding(padding: EdgeInsets.all(8)),
                  _ArticleTitle(title: widget.post.title),
                  if (widget.post.staffNames.isNotEmpty) ...[
                    const Padding(padding: EdgeInsets.all(4)),
                    _ArticleAuthors(authors: widget.post.writers.join(", ")),
                  ],
                  const Padding(padding: EdgeInsets.all(4)),
                  _ArticleDate(date: widget.post.date),
                  const Padding(padding: EdgeInsets.all(8)),
                  if (widget.post.featuredMedia != 0)
                    MediaImageWidget(
                        mediaModel: mediaLogic
                            .getMediaFromCache(widget.post.featuredMedia)!),
                  if (widget.post.video.isNotEmpty &&
                      widget.post.video[0].trim().isNotEmpty)
                    _ArticleFeaturedButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => FeaturedView(widget.post)))),
                  const _ArticleSections(),
                  const Padding(padding: EdgeInsets.all(48)),
                  /*
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                        children: SectionParserService.parseSections(
                            widget.post.rawContent)),
                  ),*/
                ])),
              ],
            );
          }),
    );
  }
}

class _ArticleTitle extends StatelessWidget {
  final String? title;

  const _ArticleTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(title ?? "",
            style: const TextStyle(fontSize: 28, height: 1.5)));
  }
}

class _ArticleAuthors extends StatelessWidget {
  final String? authors;

  const _ArticleAuthors({Key? key, required this.authors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          authors ?? "",
          style: const TextStyle(fontSize: 18),
        ));
  }
}

class _ArticleDate extends StatelessWidget {
  final DateTime date;

  const _ArticleDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(DateFormat("MMMM d, yyyy - h:mm a").format(date),
            style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.black.withOpacity(0.6))));
  }
}

/*
class _ArticleImageBuilder extends StatelessWidget {
  final int id;

  const _ArticleImageBuilder({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return CachedNetworkImage(imageUrl: imageUrl)
    return WordpressMediaService.getImage(id, (context, provider) {
      return Image(image: provider);
    }, (context, url) {
      return const AspectRatio(
          aspectRatio: 1.38, child: Center(child: CircularProgressIndicator()));
    });
  }
}*/

class _ArticleFeaturedButton extends StatelessWidget {
  final void Function()? onPressed;
  const _ArticleFeaturedButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(children: const [
        Icon(Icons.auto_awesome),
        Text("View Featured Content")
      ]),
    );
  }
}

class _ArticleSections extends StatelessWidget {
  const _ArticleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ArticleViewLogic logic = getIt<ArticleViewLogic>();
    MediaLogic mediaLogic = getIt<MediaLogic>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
          children: logic.sections.map((section) {
        switch (section.runtimeType) {
          case HtmlModel:
            HtmlModel html = section as HtmlModel;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Html(
                data: html.html,
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, element) async {
                  await launch(url!);
                },
                style: {
                  "*": Style(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    fontSize: const FontSize(18),
                    lineHeight: const LineHeight(1.5),
                  )
                },
              ),
            );
          case ImageModel:
            ImageModel image = section as ImageModel;
            return Column(children: [
              if (mediaLogic.cacheContainsMedia(image.id))
                Center(
                  child: MediaImageWidget(
                      mediaModel: mediaLogic.getMediaFromCache(image.id)),
                ),
              if (image.caption != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(image.caption!),
                )
            ]);
          case PullquoteModel:
            PullquoteModel pullquoteModel = section as PullquoteModel;
            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: Column(children: [
                  if (pullquoteModel.imageId != null &&
                      pullquoteModel.imageId != 0)
                    MediaImageWidget(
                        mediaModel: mediaLogic
                            .getMediaFromCache(pullquoteModel.imageId!)!),
                  Text('"${pullquoteModel.quote}"'),
                  Text("--${pullquoteModel.speaker ?? ""}"),
                ]));
          case VideoHtmlModel:
            VideoHtmlModel videoHtmlModel = section as VideoHtmlModel;
            return Column(
              children: [
                Html(
                  data: videoHtmlModel.html,
                  style: {
                    "*": Style(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                    ),
                  },
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(videoHtmlModel.credit))
              ],
            );
          case RelatedPostsModel:
            //TODO: implement related posts by fetching the posts in initstate and then fetching them from the cache here
            RelatedPostsModel relatedPostsModel = section as RelatedPostsModel;
            return Text(relatedPostsModel.toString());
          case SidebarModel:
            SidebarModel sidebarModel = section as SidebarModel;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Html(
                style: {
                  "*": Style(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    fontSize: const FontSize(28),
                    lineHeight: const LineHeight(1.5),
                    border: const Border(),
                  )
                },
                data: '',
              ),
            );

          default:
            //TODO: implement galleries
            if (section is UnsupportedModel) {
              UnsupportedModel unsupportedModel = section;
              return Text("Unsupported section: ${unsupportedModel.text}");
            }
            return Text("$section");
        }
      }).toList()),
    );
  }
}
