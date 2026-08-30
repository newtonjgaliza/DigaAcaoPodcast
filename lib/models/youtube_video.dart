class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;
  final String url;
  final bool isShort;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.url,
    this.isShort = false,
  });

  factory YoutubeVideo.fromXmlEntry(dynamic entry) {
    // We will parse this inside the service to keep models clean
    throw UnimplementedError();
  }
}
