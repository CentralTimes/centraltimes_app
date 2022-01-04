import 'package:app/logic/media_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/ui/custom_buttons.dart';
import 'package:app/views/article_view/article_view.dart';
import 'package:app/views/featured_view.dart';
import 'package:app/widgets/media_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class PostPreviewCardWidget extends StatelessWidget {
  final PostModel post;
  static const double blur = 1;

  const PostPreviewCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaLogic mediaLogic = getIt<MediaLogic>();
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ArticleView(post: post))),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, blur),
              blurRadius: blur,
              spreadRadius: -2 * blur,
            ),
            BoxShadow(
              offset: Offset(0, -blur),
              blurRadius: blur,
              spreadRadius: -2 * blur,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mediaLogic.cacheContainsMedia(post.featuredMedia))
              Center(
                child: MediaImageWidget(
                    mediaModel:
                        mediaLogic.getMediaFromCache(post.featuredMedia)),
              ),
            const Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title, style: const TextStyle(fontSize: 28))),
            if (post.staffNames.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.writers.join(", "),
                      style: const TextStyle(fontSize: 18))),
            ],
            if (post.excerpt != "") ...[
              const Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Html(data: post.excerpt, style: {
                    "*": Style(
                      fontSize: const FontSize(18),
                      color: const Color(0xFF666666),
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                    )
                  })),
            ],
            ListTile(
                title: Text(DateFormat("MMMM d").format(post.date),
                    style: const TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (post.video.isNotEmpty &&
                        post.video[0].trim().isNotEmpty)
                      IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => FeaturedView(post))),
                          icon: const Icon(Icons.auto_awesome),
                          color: Theme.of(context).primaryColor),
                    SaveButton(post.id),
                    IconButton(
                        onPressed: () {
                          Share.share(post.link,
                              subject: "${post.title} - Central Times");
                        },
                        icon: const Icon(Icons.share),
                        color: Theme.of(context).primaryColor),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
