import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/host.dart';

class HostCard extends StatefulWidget {
  final Host host;

  const HostCard({
    super.key,
    required this.host,
  });

  @override
  State<HostCard> createState() => _HostCardState();
}

class _HostCardState extends State<HostCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showHostBioModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curve,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0F172A),
                    widget.host.themeColor.withOpacity(0.2),
                    const Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.host.themeColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.host.themeColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white60),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // RPG Character Style Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: widget.host.themeColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.host.themeColor,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.host.themeColor.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Image.asset(
                        widget.host.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              widget.host.icon,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name & Nickname
                  Text(
                    widget.host.name,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.host.nickname.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '"${widget.host.nickname}"',
                      style: GoogleFonts.outfit(
                        color: widget.host.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Specialties (Tags)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: widget.host.specialties.map((spec) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.host.themeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.host.themeColor.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          spec,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Bio Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      widget.host.bio,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Hobbies Title & Row
                  Text(
                    'Interesses Geek',
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    alignment: WrapAlignment.center,
                    children: widget.host.hobbies.map((hobby) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: widget.host.themeColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hobby,
                            style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _showHostBioModal(context);
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 105,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white12,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Host Circular Icon/Image Indicator
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.host.themeColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.host.themeColor.withOpacity(0.7),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.host.themeColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.asset(
                    widget.host.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          widget.host.icon,
                          color: Colors.white,
                          size: 22,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Name (Truncated if too long)
              Text(
                widget.host.name.split(' ').first,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              // Role title
              Text(
                widget.host.name.contains('Luan')
                    ? 'Fundador'
                    : widget.host.name.contains('Elivelton')
                        ? 'Co-Fundador'
                        : 'Host',
                style: GoogleFonts.outfit(
                  color: widget.host.themeColor.withOpacity(0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
