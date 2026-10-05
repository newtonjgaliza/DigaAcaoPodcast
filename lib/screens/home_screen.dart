import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/carousel_item.dart';
import '../models/host.dart';
import '../models/instagram_post.dart';
import '../models/youtube_video.dart';
import '../services/instagram_service.dart';
import '../services/notification_service.dart';
import '../services/youtube_service.dart';
import '../widgets/host_card.dart';
import '../widgets/social_button.dart';
import '../widgets/video_carousel.dart';
import 'video_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final YoutubeService _youtubeService = YoutubeService();
  final InstagramService _instagramService = InstagramService();
  final NotificationService _notificationService = NotificationService();

  List<YoutubeVideo> _videos = [];
  List<CarouselItem> _carouselItems = [];
  bool _isLoading = true;

  // New Video Notification state
  YoutubeVideo? _newVideoAlert;
  bool _showNewVideoBanner = false;

  final List<Host> _hosts = [
    Host(
      name: 'Luan Carvalho',
      nickname: 'Luan',
      bio: 'Sou o fundador do Diga Ação Podcast, viciado em jogos, ler HQs, assistir filmes e séries, e às vezes uns animes, mas também sou Desenhista, Editor e é claro Podcaster.',
      icon: Icons.sports_esports_rounded,
      imagePath: 'assets/images/luan.jpeg',
      specialties: ['Fundador', 'Desenhista', 'Editor', 'Podcaster'],
      hobbies: ['Jogos', 'HQs', 'Filmes', 'Animes'],
      themeColor: const Color(0xFF00B4D8), // Neon cyan
    ),
    Host(
      name: 'Elivelton Silva',
      nickname: 'Level',
      bio: 'Sou Co-Fundador do Diga Ação Podcast, um amante de Animes, entusiasta de qualquer jogo de RPG, mas também sou vendedor, Editor e Podcaster.',
      icon: Icons.casino_rounded,
      imagePath: 'assets/images/level.jpeg',
      specialties: ['Co-Fundador', 'Vendedor', 'Editor', 'Podcaster'],
      hobbies: ['Animes', 'RPG de Mesa', 'Jogos'],
      themeColor: const Color(0xFFEC4899), // Neon pink
    ),
    Host(
      name: 'Arthur Fernando',
      nickname: 'Arthur',
      bio: 'Amo ler livros, Mangás e Animes, cinéfilo viciado e fã de The Witcher (jogos e livros) mas também sou Engenheiro, Mecânico, Editor e Podcaster.',
      icon: Icons.menu_book_rounded,
      imagePath: 'assets/images/arthur.jpeg',
      specialties: ['Engenheiro', 'Mecânico', 'Editor', 'Podcaster'],
      hobbies: ['Livros & Mangás', 'Cinéfilo', 'The Witcher'],
      themeColor: const Color(0xFFA855F7), // Neon purple
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final results = await Future.wait([
      _youtubeService.fetchVideos(),
      _instagramService.fetchLatestPosts(),
    ]);

    final fetchedVideos = results[0] as List<YoutubeVideo>;
    final fetchedPosts = results[1] as List<InstagramPost>;

    // Intercalate 5 Youtube videos and 5 Instagram posts
    final List<CarouselItem> items = [];
    final takeCount = 5;
    final topVideos = fetchedVideos.take(takeCount).toList();
    final topPosts = fetchedPosts.take(takeCount).toList();

    for (int i = 0; i < takeCount; i++) {
      if (i < topVideos.length) {
        items.add(CarouselItem.fromYoutube(topVideos[i]));
      }
      if (i < topPosts.length) {
        items.add(CarouselItem.fromInstagram(topPosts[i]));
      }
    }

    if (mounted) {
      setState(() {
        _videos = fetchedVideos;
        _carouselItems = items;
        _isLoading = false;
      });

      // Check for new video notification
      if (fetchedVideos.isNotEmpty) {
        final newestVideo = fetchedVideos.first;
        final isNew = await _notificationService.checkForNewVideo(newestVideo);
        if (isNew && mounted) {
          setState(() {
            _newVideoAlert = newestVideo;
            _showNewVideoBanner = true;
          });
        }
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $uri: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF070A13),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                color: const Color(0xFF00B4D8),
                backgroundColor: const Color(0xFF1E293B),
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. Logo Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00B4D8).withOpacity(0.2),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/logo.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Carousel Widget (Intercalado)
                      _isLoading
                          ? Container(
                              height: 210,
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF00B4D8),
                                ),
                              ),
                            )
                          : VideoCarousel(items: _carouselItems),

                      const SizedBox(height: 12),

                      // "Ver Todos os Episódios" Button
                      TextButton(
                        onPressed: () {
                          if (_videos.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoListScreen(videos: _videos),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF00B4D8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver Todos os Episódios',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 3. Hosts Section Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Conheça os Hosts',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Horizontal layout of Host cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _hosts.map((host) => HostCard(host: host)).toList(),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // 4. Social Media Section
                      Text(
                        'Redes Sociais',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Row of Social buttons
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialButton(
                              type: SocialType.instagram,
                              url: 'https://www.instagram.com/digaacao.podcast',
                            ),
                            SocialButton(
                              type: SocialType.tiktok,
                              url: 'https://www.tiktok.com/@digaacao.podcast',
                            ),
                            SocialButton(
                              type: SocialType.spotify,
                              url: 'https://open.spotify.com/show/6VuajYlMFBOurqejVpNKcO?si=yP-wTPbsQNyom69fhYhGmw&nd=1&dlsi=40355371d83d47b3',
                            ),
                            SocialButton(
                              type: SocialType.youtube,
                              url: 'https://www.youtube.com/@Digaac%C3%A3o',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Floating Notification Banner for New Video
              if (_showNewVideoBanner && _newVideoAlert != null)
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0F2027),
                            Color(0xFF203A43),
                            Color(0xFF2C5364),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00B4D8).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF00B4D8),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF00B4D8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '🎬 NOVO VÍDEO DISPONÍVEL!',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF00B4D8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _newVideoAlert!.title,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _openUrl(_newVideoAlert!.url);
                              setState(() {
                                _showNewVideoBanner = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B4D8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Assistir',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                            onPressed: () {
                              setState(() {
                                _showNewVideoBanner = false;
                              });
                            },
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.only(left: 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
