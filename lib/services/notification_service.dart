import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../core/errors/exceptions.dart';

/// Service de gestion des notifications locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialise le service de notifications
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final granted = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (granted != true) {
      throw NotificationException(
        message: 'Permission de notification refusée',
      );
    }

    _initialized = true;
  }

  /// Demande les permissions de notification
  Future<bool> requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    bool? androidGranted;
    bool? iosGranted;

    if (androidPlugin != null) {
      androidGranted = await androidPlugin.requestNotificationsPermission();
    }

    if (iosPlugin != null) {
      iosGranted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Planifie une notification quotidienne pour une habitude
  Future<void> scheduleHabitReminder({
    required int habitId,
    required String habitName,
    required String time, // Format: HH:mm
  }) async {
    if (!_initialized) await initialize();

    // Parser le temps
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Créer la date/heure de la notification
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Si l'heure est passée aujourd'hui, programmer pour demain
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      habitId, // Utiliser l'ID de l'habitude comme ID de notification
      'Rappel: $habitName',
      'Il est temps de compléter votre habitude! 💪',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Rappels d\'habitudes',
          channelDescription: 'Notifications pour vos habitudes quotidiennes',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Répéter quotidiennement
    );
  }

  /// Annule la notification d'une habitude
  Future<void> cancelHabitReminder(int habitId) async {
    await _notifications.cancel(habitId);
  }

  /// Annule toutes les notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Envoie une notification de milestone (série)
  Future<void> showMilestoneNotification({
    required int habitId,
    required String habitName,
    required int streak,
    required String message,
  }) async {
    if (!_initialized) await initialize();

    await _notifications.show(
      habitId + 10000, // Offset pour éviter conflit avec rappels
      '🎉 Milestone atteint!',
      '$habitName: $message',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_milestones',
          'Milestones',
          channelDescription: 'Célébration de vos accomplissements',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            '$habitName: $message',
            contentTitle: '🎉 Milestone atteint!',
          ),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// Callback quand une notification est tapée
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigator vers la page de l'habitude
    // final habitId = response.id;
  }
}
