// We build our own models for posts in case like... we want extra data.
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
      this.commentStatus);
}

class PostLinksModel {
  final List<String> self;
  final List<String> collection;
  final List<String> about;
  final List<String> author;
  final List<String> replies;
  final List<String> versionHistory;
  final List<String> predecessorVersion;
  final List<String> wpFeaturedMedia;
  final List<String> wpAttachment;
  final List<PostTermModel> wpTerm;
  final List<String> curies;

  PostLinksModel(
      this.self,
      this.collection,
      this.about,
      this.author,
      this.replies,
      this.versionHistory,
      this.predecessorVersion,
      this.wpFeaturedMedia,
      this.wpAttachment,
      this.wpTerm,
      this.curies);
}

class PostTermModel {
  final String taxonomy;
  final bool embeddable;
  final String href;

  PostTermModel(this.taxonomy, this.embeddable, this.href);
}

class PostCurieModel {
  final String name;
  final String href;
  final bool templated;

  PostCurieModel(this.name, this.href, this.templated);
}
