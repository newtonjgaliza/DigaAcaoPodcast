import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialType { spotify, instagram, tiktok, youtube }

class SocialButton extends StatefulWidget {
  final SocialType type;
  final String url;

  const SocialButton({
    super.key,
    required this.type,
    required this.url,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(widget.url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $uri: $e');
    }
  }

  FaIconData get _icon {
    switch (widget.type) {
      case SocialType.spotify:
        return FontAwesomeIcons.spotify;
      case SocialType.instagram:
        return FontAwesomeIcons.instagram;
      case SocialType.tiktok:
        return FontAwesomeIcons.tiktok;
      case SocialType.youtube:
        return FontAwesomeIcons.youtube;
    }
  }

  List<Color> get _gradientColors {
    switch (widget.type) {
      case SocialType.spotify:
        return [const Color(0xFF1DB954), const Color(0xFF191414)];
      case SocialType.instagram:
        return [
          const Color(0xFF833AB4),
          const Color(0xFFFD1D1D),
          const Color(0xFFF56040),
        ];
      case SocialType.tiktok:
        return [const Color(0xFF000000), const Color(0xFF111111)];
      case SocialType.youtube:
        return [const Color(0xFFFF0000), const Color(0xFF282828)];
    }
  }

  Border? get _border {
    if (widget.type == SocialType.tiktok) {
      return Border.all(color: const Color(0xFF00F2FE), width: 1.5);
    }
    return Border.all(color: Colors.white24, width: 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _launchUrl();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 58,
          height: 58,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientColors,
            ),
            border: _border,
            boxShadow: [
              BoxShadow(
                color: _gradientColors.first.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: FaIcon(
              _icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
