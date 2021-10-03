// The PostModel contains the extra fields rawContent and staffNames.
class PostModel {
  // Unique ID of the post
  final int id;

  // GMT time of the last time the post was published
  final DateTime date;

  // GMT time of the last time the post was modified
  final DateTime modified;

  // Short post ID arg URL of the post
  final String guid;

  // What the post is named as on the URL, usually generated from title
  final String slug;

  // Long permalink URL of the post on the web
  final String link;

  // Title of the article
  final String title;

  // Content rendered into HTML for direct use on the website
  final String renderedContent;

  // Post data straight from the database, no shortcode or paragraph rendering
  final String rawContent;

  // Just a shortened version of content automatically generated as a preview
  final String excerpt;

  // Oftentimes not present, but we want to use this over excerpt
  final List<String> subtitle;

  // The user ID that published the article, only used internally
  final int author;

  // A list of strings containing contributor names
  final List<String> writers;

  // A list of string containing job titles for the contributors
  final List<String> jobtitles;

  // Featured embed media, not only videos, has other embeds like Adobe Spark
  final List<String> video;

  // Author name of featured embed media
  final List<String> videographer;

  // Media post type ID for featured Media, 0 if none
  final int featuredMedia;

  // List of IDs of category taxonomies
  final List<int> categories;

  // List of IDs of tag taxonomies
  final List<int> tags;

  // List of IDs of staff_name taxonomies
  final List<int> staffNames;

  // Either "open" or "closed", depending on the ability to post new comments
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
      this.subtitle,
      this.author,
      this.writers,
      this.jobtitles,
      this.video,
      this.videographer,
      this.featuredMedia,
      this.categories,
      this.tags,
      this.staffNames,
      this.commentStatus);
}
