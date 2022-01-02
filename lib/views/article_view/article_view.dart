import 'package:app/logic/media_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/services/section/parser/section_parser_service.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/ui/custom_buttons.dart';
import 'package:app/views/article_view/article_view_logic.dart';
import 'package:app/widgets/media_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

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
    if (widget.post.featuredMedia != 0) {
      mediaLogic
          .getMediaSingle(widget.post.featuredMedia)
          .then((value) => logic.initView());
    }
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
                        media: mediaLogic
                            .getMediaFromCache(widget.post.featuredMedia)!),
                  if (widget.post.video.isNotEmpty &&
                      widget.post.video[0].trim().isNotEmpty)
                    _ArticleFeaturedButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => FeaturedView(widget.post)))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                        children: SectionParserService.parseSections(
                            widget.post.rawContent)),
                  ),
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
