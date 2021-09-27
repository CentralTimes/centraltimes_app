// The PostModel contains the extra fields rawContent and staffNames.
class PostModel {
  final int id;
  final DateTime date;
  final DateTime modified;
  final String guid;
  final String slug;
  final String link;
  final String title;
  final String renderedContent;
  final String rawContent;
  final String excerpt;
  final int author;
  final int featuredMedia;
  final List<int> categories;
  final List<int> tags;
  final List<int> staffNames;
  final String commentStatus;

  PostModel(
      this.id,
      this.date,
      this.modified,
      this.guid,
      this.slug,
      this.link,
      this.title,
      this.renderedContent,
      this.rawContent,
      this.excerpt,
      this.author,
      this.featuredMedia,
      this.categories,
      this.tags,
      this.staffNames,
      this.commentStatus);
}