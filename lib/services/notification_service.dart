import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/youtube_video.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _keyLastVideoId = 'last_seen_video_id';
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Erro ao inicializar notificações locais: $e');
    }
  }

  /// Checks if [newestVideo] is a newly released video.
  /// If it's new, saves its ID and triggers a notification.
  /// Returns `true` if a new video was detected.
  Future<bool> checkForNewVideo(YoutubeVideo newestVideo) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeenId = prefs.getString(_keyLastVideoId);

    // If it's the very first app launch, store current video ID so we don't spam notification
    if (lastSeenId == null) {
      await prefs.setString(_keyLastVideoId, newestVideo.id);
      return false;
    }

    // Check if newest video ID is different from last seen video ID
    if (lastSeenId != newestVideo.id) {
      await prefs.setString(_keyLastVideoId, newestVideo.id);
      await triggerLocalNotification(
        title: '🎬 NOVO VÍDEO LANÇADO!',
        body: newestVideo.title,
      );
      return true;
    }

    return false;
  }

  /// Disparar notificação local do sistema
  Future<void> triggerLocalNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;

    try {
      await initialize();
      
      const androidDetails = AndroidNotificationDetails(
        'diga_acao_videos_channel',
        'Novos Episódios',
        channelDescription: 'Notificações de novos vídeos do Diga Ação Podcast',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      );
    } catch (e) {
      debugPrint('Erro ao disparar notificação local: $e');
    }
  }
}
