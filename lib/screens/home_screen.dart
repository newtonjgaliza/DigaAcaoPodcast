import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/host.dart';
import '../models/youtube_video.dart';
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
  List<YoutubeVideo> _videos = [];
  bool _isLoading = true;

  // List of Host objects with their respective names, bios, icons, and themes
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
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });
    final fetched = await _youtubeService.fetchVideos();
    if (mounted) {
      setState(() {
        _videos = fetched;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Deep midnight blue
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF070A13), // Deep dark space blue
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF00B4D8),
            backgroundColor: const Color(0xFF1E293B),
            onRefresh: _loadVideos,
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
                  const SizedBox(height: 30),

                  // 2. Videos Carousel Title / Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Últimos Episódios',
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

                  // YouTube Carousel Content
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
                      : VideoCarousel(videos: _videos),

                  const SizedBox(height: 12),

                  // "Ver Todos" (View All) Text/Button below Carousel
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
                          'Ver Todos',
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
        ),
      ),
    );
  }
}
