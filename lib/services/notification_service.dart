import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/constants/app_constants.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart';

/// Service de gestion des notifications locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _timezoneInitialized = false;

  /// Callback de navigation pour les notifications
  void Function(int habitId)? _onNavigateToHabit;

  /// Flag pour éviter la configuration répétée du callback
  bool _navigationCallbackSet = false;

  /// Initialise le fuseau horaire avec une méthode de repli
  Future<void> _initializeTimezone() async {
    if (_timezoneInitialized) return;

    initializeTimeZones();

    try {
      // Méthode 1: Essayer avec flutter_timezone (fonctionne parfaitement sur Android/iOS)
      // Cette méthode est la méthode principale pour les plateformes mobiles
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      final location = tz.getLocation(timeZoneName.toString());
      tz.setLocalLocation(location);
      _timezoneInitialized = true;
      debugPrint(
        'Fuseau horaire initialisé avec flutter_timezone: $timeZoneName',
      );
      return; // Sur Android/iOS, cette méthode fonctionne et on s'arrête ici
    } catch (e) {
      debugPrint(
        'Échec avec flutter_timezone: $e (repli vers autres méthodes)',
      );
      // Sur Linux ou si flutter_timezone échoue, continuer avec les méthodes de repli
    }

    try {
      // Méthode 2: Lire /etc/timezone (Linux)
      if (!kIsWeb && Platform.isLinux) {
        try {
          final timezoneFile = File('/etc/timezone');
          if (await timezoneFile.exists()) {
            final tzName = (await timezoneFile.readAsString()).trim();
            if (tzName.isNotEmpty) {
              try {
                final location = tz.getLocation(tzName);
                tz.setLocalLocation(location);
                _timezoneInitialized = true;
                debugPrint(
                  'Fuseau horaire initialisé avec /etc/timezone: $tzName',
                );
                return;
              } catch (e) {
                debugPrint('Échec avec /etc/timezone ($tzName): $e');
              }
            }
          }
        } catch (e) {
          debugPrint('Erreur lors de la lecture de /etc/timezone: $e');
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification de /etc/timezone: $e');
    }

    try {
      // Méthode 3: Utiliser la variable d'environnement TZ (Linux/Unix)
      if (!kIsWeb) {
        final tzEnv = Platform.environment['TZ'];
        if (tzEnv != null && tzEnv.isNotEmpty) {
          try {
            final location = tz.getLocation(tzEnv);
            tz.setLocalLocation(location);
            _timezoneInitialized = true;
            debugPrint('Fuseau horaire initialisé avec TZ: $tzEnv');
            return;
          } catch (e) {
            debugPrint('Échec avec variable TZ: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la lecture de TZ: $e');
    }

    try {
      // Méthode 4: Utiliser le fuseau horaire système via DateTime
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final offsetHours = offset.inHours;

      // Essayer de trouver un fuseau horaire correspondant à l'offset
      final commonTimezones = [
        'Europe/Paris',
        'Europe/London',
        'America/New_York',
        'America/Los_Angeles',
        'Asia/Tokyo',
        'Australia/Sydney',
        'UTC',
      ];

      // Essayer les fuseaux horaires communs
      for (final commonTz in commonTimezones) {
        try {
          final location = tz.getLocation(commonTz);
          final testNow = tz.TZDateTime.now(location);
          final testOffset = testNow.timeZoneOffset;

          // Vérifier si l'offset correspond approximativement
          if (testOffset.inHours == offsetHours) {
            tz.setLocalLocation(location);
            _timezoneInitialized = true;
            debugPrint(
              'Fuseau horaire initialisé avec fuseau commun: $commonTz',
            );
            return;
          }
        } catch (e) {
          continue;
        }
      }

      // Dernier recours: utiliser UTC
      final utcLocation = tz.getLocation('UTC');
      tz.setLocalLocation(utcLocation);
      _timezoneInitialized = true;
      debugPrint('Fuseau horaire initialisé avec UTC (dernier recours)');
    } catch (e) {
      debugPrint('Échec de toutes les méthodes de repli: $e');
      // Utiliser UTC comme dernier recours absolu
      try {
        final utcLocation = tz.getLocation('UTC');
        tz.setLocalLocation(utcLocation);
        _timezoneInitialized = true;
        debugPrint('Fuseau horaire forcé à UTC (dernier recours absolu)');
      } catch (utcError) {
        // Si même UTC échoue, c'est un problème grave mais on continue quand même
        debugPrint(
          'ERREUR CRITIQUE: Impossible d\'initialiser même UTC: $utcError',
        );
        // Ne pas lever d'exception, on continuera sans notifications si nécessaire
      }
    }
  }

  /// Définit le callback de navigation pour les notifications
  void setNavigationCallback(void Function(int habitId) callback) {
    if (!_navigationCallbackSet) {
      _onNavigateToHabit = callback;
      _navigationCallbackSet = true;
    }
  }

  /// Initialise le service de notifications
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialiser le fuseau horaire avec méthode de repli
      await _initializeTimezone();
    } catch (e) {
      // Si l'initialisation du fuseau horaire échoue complètement,
      // on continue quand même car on peut utiliser UTC ou gérer l'erreur plus tard
      debugPrint(
        'Avertissement: Échec partiel de l\'initialisation du fuseau horaire: $e',
      );
    }

    // S'assurer que le fuseau horaire est au moins initialisé à quelque chose
    if (!_timezoneInitialized) {
      try {
        initializeTimeZones();
        final utcLocation = tz.getLocation('UTC');
        tz.setLocalLocation(utcLocation);
        _timezoneInitialized = true;
        debugPrint('Fuseau horaire initialisé à UTC par défaut');
      } catch (e) {
        debugPrint('Impossible d\'initialiser même UTC: $e');
        // On continue quand même, les notifications pourraient échouer mais l'app fonctionne
      }
    }

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

    try {
      final granted = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (granted != true) {
        debugPrint('Avertissement: Permissions de notifications non accordées');
        // Ne pas lever d'exception, on peut continuer sans notifications
        return;
      }

      _initialized = true;
    } catch (e) {
      debugPrint(
        'Erreur lors de l\'initialisation du plugin de notifications: $e',
      );
      // Ne pas lever d'exception, l'application peut continuer sans notifications
      // Les notifications échoueront silencieusement mais l'app fonctionnera
    }
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

    return androidGranted == true && iosGranted == true;
  }

  /// Planifie une notification quotidienne pour une habitude
  Future<void> scheduleHabitReminder({
    required int habitId,
    required String habitName,
    required String time, // Format: HH:mm
  }) async {
    if (!_initialized) await initialize();

    // Vérifier que le fuseau horaire est initialisé
    if (!_timezoneInitialized) {
      debugPrint(
        'Avertissement: Tentative de planification sans fuseau horaire initialisé',
      );
      return; // Ne pas planifier si le fuseau horaire n'est pas initialisé
    }

    try {
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
        habitId,
        'Rappel: $habitName',
        'Il est temps de compléter votre habitude! 💪',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.notificationChannelId,
            AppConstants.notificationChannelName,
            channelDescription: AppConstants.notificationChannelDescription,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
            DateTimeComponents.time, // Répéter quotidiennement
      );
    } catch (e) {
      debugPrint('Erreur lors de la planification de la notification: $e');
      // Ne pas lever d'exception, on continue sans notification
    }
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

    if (!_initialized) {
      debugPrint(
        'Avertissement: Tentative d\'envoyer une notification sans initialisation',
      );
      return;
    }

    try {
      final milestoneNotificationId = habitId * 1000;

      await _notifications.show(
        milestoneNotificationId,
        '🔥 Série de $streak jours',
        '$habitName · $message',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.notificationChannelId,
            AppConstants.notificationChannelName,
            channelDescription: AppConstants.notificationChannelDescription,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      debugPrint('Erreur lors de l\'envoi de la notification de milestone: $e');
      // Ne pas lever d'exception, on continue sans notification
    }
  }

  /// Callback quand une notification est tapée
  void _onNotificationTapped(NotificationResponse response) {
    final notificationId = response.id;

    if (notificationId == null) return;

    // Pour les notifications de milestone, l'ID est habitId * 1000
    // Pour les notifications de rappel, l'ID est directement l'habitId
    int habitId;
    if (notificationId >= 1000 && notificationId % 1000 == 0) {
      // Notification de milestone
      habitId = notificationId ~/ 1000;
    } else {
      // Notification de rappel quotidien
      habitId = notificationId;
    }

    // Naviguer vers la page de l'habitude si le callback est défini
    _onNavigateToHabit?.call(habitId);
  }
}
