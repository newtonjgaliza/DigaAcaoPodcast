import 'package:flutter/material.dart';

class Host {
  final String name;
  final String nickname;
  final String bio;
  final IconData icon;
  final String imagePath;
  final List<String> specialties;
  final List<String> hobbies;
  final Color themeColor;

  Host({
    required this.name,
    this.nickname = '',
    required this.bio,
    required this.icon,
    required this.imagePath,
    required this.specialties,
    required this.hobbies,
    required this.themeColor,
  });
}

