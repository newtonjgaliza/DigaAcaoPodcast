class InstagramPost {
  final String id;
  final String caption;
  final String imageUrl;
  final String publishedAt;
  final String postUrl;
  final int likesCount;

  InstagramPost({
    required this.id,
    required this.caption,
    required this.imageUrl,
    required this.publishedAt,
    required this.postUrl,
    this.likesCount = 0,
  });
}
