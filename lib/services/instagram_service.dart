import '../models/instagram_post.dart';

class InstagramService {
  static const String instagramUrl = 'https://www.instagram.com/digaacao.podcast';

  // Fallback 5 recent posts from @digaacao.podcast with high quality visuals and actual themes
  static final List<InstagramPost> _fallbackPosts = [
    InstagramPost(
      id: 'post_1',
      caption: '🚀 NOVO EPISÓDIO NO AR! Falamos sobre os desafios de ser um Mangaká iniciante com @Bruno Werner! Confira o bate-papo completo.',
      imageUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=800&auto=format&fit=crop',
      publishedAt: '03/10/2026',
      postUrl: 'https://www.instagram.com/digaacao.podcast',
      likesCount: 342,
    ),
    InstagramPost(
      id: 'post_2',
      caption: '🎮 Desenvolvimento de Jogos: bastidores e segredos com Raphael Tiritan! Assista ao corte completo no nosso canal.',
      imageUrl: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=800&auto=format&fit=crop',
      publishedAt: '28/09/2026',
      postUrl: 'https://www.instagram.com/digaacao.podcast',
      likesCount: 518,
    ),
    InstagramPost(
      id: 'post_3',
      caption: '🍿 A Casa do Dragão 3ª temporada: Decepcionou ou superou as expectativas? Deixe a sua opinião nos comentários!',
      imageUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=800&auto=format&fit=crop',
      publishedAt: '20/09/2026',
      postUrl: 'https://www.instagram.com/digaacao.podcast',
      likesCount: 429,
    ),
    InstagramPost(
      id: 'post_4',
      caption: '✨ Desenhos com Temática Subliminar: As teorias e curiosidades mais surpreendentes da nossa infância!',
      imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=800&auto=format&fit=crop',
      publishedAt: '15/09/2026',
      postUrl: 'https://www.instagram.com/digaacao.podcast',
      likesCount: 612,
    ),
    InstagramPost(
      id: 'post_5',
      caption: '🔥 ESPECIAL EP #100: Opiniões Impopulares com a presença ilustre do @afronteiranerd! Corre lá para conferir.',
      imageUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=800&auto=format&fit=crop',
      publishedAt: '10/09/2026',
      postUrl: 'https://www.instagram.com/digaacao.podcast',
      likesCount: 890,
    ),
  ];

  Future<List<InstagramPost>> fetchLatestPosts() async {
    // In future versions, standard Instagram API Graph endpoint can be integrated.
    // For now, return the curated 5 posts from @digaacao.podcast.
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_fallbackPosts);
  }
}
