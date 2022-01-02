import 'package:app/models/object_model.dart';

class CommentModel extends ObjectModel {
  final int id;
  final int post;
  final int parent;
  final int author;
  final String authorName;
  final String authorUrl;
  final DateTime date;
  final String content;
  final String link;
  final Map<String, dynamic> authorAvatorUrls;

  const CommentModel(
      this.id,
      this.post,
      this.parent,
      this.author,
      this.authorName,
      this.authorUrl,
      this.date,
      this.content,
      this.link,
      this.authorAvatorUrls);
}
