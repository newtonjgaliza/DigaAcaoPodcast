import 'youtube_video.dart';
import 'instagram_post.dart';

enum CarouselItemType { youtube, instagram }

class CarouselItem {
  final CarouselItemType type;
  final YoutubeVideo? video;
  final InstagramPost? instagramPost;

  CarouselItem.fromYoutube(this.video)
      : type = CarouselItemType.youtube,
        instagramPost = null;

  CarouselItem.fromInstagram(this.instagramPost)
      : type = CarouselItemType.instagram,
        video = null;

  bool get isYoutube => type == CarouselItemType.youtube;
  bool get isInstagram => type == CarouselItemType.instagram;

  String get title => isYoutube ? video!.title : instagramPost!.caption;
  String get imageUrl => isYoutube ? video!.thumbnailUrl : instagramPost!.imageUrl;
  String get url => isYoutube ? video!.url : instagramPost!.postUrl;
  String get date => isYoutube ? video!.publishedAt : instagramPost!.publishedAt;
}
