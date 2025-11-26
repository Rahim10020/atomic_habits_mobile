import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/models/habit.dart';
import '../domain/repositories/habit_repository.dart';
import '../core/errors/exceptions.dart';

/// Service de backup et restauration des données
class BackupService {
  final HabitRepository _repository;
  final _logger = Logger('BackupService');

  BackupService(this._repository);

  /// Exporte toutes les habitudes en JSON
  Future<Map<String, dynamic>> exportToJson() async {
    try {
      final habits = await _repository.getAllHabits();

      return {
        'version': 1,
        'exportDate': DateTime.now().toIso8601String(),
        'habits': habits.map((h) => _habitToJson(h)).toList(),
      };
    } catch (e) {
      throw AppException(
        message: 'Erreur lors de l\'export',
        originalException: e,
      );
    }
  }

  /// Exporte et sauvegarde dans un fichier
  Future<File> exportToFile() async {
    if (kIsWeb) {
      throw UnsupportedError('File operations not supported on web');
    }
    try {
      final data = await exportToJson();
      final jsonString = JsonEncoder.withIndent('  ').convert(data);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File(
        '${directory.path}/atomic_habits_backup_$timestamp.json',
      );

      await file.writeAsString(jsonString);
      return file;
    } catch (e) {
      throw AppException(
        message: 'Erreur lors de la sauvegarde du fichier',
        originalException: e,
      );
    }
  }

  /// Partage le backup
  Future<void> shareBackup() async {
    if (kIsWeb) {
      throw UnsupportedError('Sharing not supported on web');
    }
    try {
      final file = await exportToFile();
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Atomic Habits Backup',
        text: 'Sauvegarde de mes habitudes',
      );
    } catch (e) {
      throw AppException(
        message: 'Erreur lors du partage',
        originalException: e,
      );
    }
  }

  /// Importe des habitudes depuis JSON
  Future<int> importFromJson(Map<String, dynamic> data) async {
    try {
      // Valider la version
      final version = data['version'] as int?;
      if (version == null || version != 1) {
        throw ValidationException(message: 'Version de backup non compatible');
      }

      // Importer les habitudes
      final habitsList = data['habits'] as List?;
      if (habitsList == null) {
        throw ValidationException(message: 'Format de backup invalide');
      }

      int importedCount = 0;
      for (final habitData in habitsList) {
        try {
          final habit = _habitFromJson(habitData as Map<String, dynamic>);
          await _repository.createHabit(habit);
          importedCount++;
        } catch (e) {
          // Continuer même si une habitude échoue
          _logger.severe('Erreur import habitude: $e');
        }
      }

      return importedCount;
    } catch (e) {
      throw AppException(
        message: 'Erreur lors de l\'import',
        originalException: e,
      );
    }
  }

  /// Importe depuis un fichier
  Future<int> importFromFile(File file) async {
    if (kIsWeb) {
      throw UnsupportedError('File operations not supported on web');
    }
    try {
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return await importFromJson(data);
    } catch (e) {
      throw AppException(
        message: 'Erreur lors de la lecture du fichier',
        originalException: e,
      );
    }
  }

  /// Convertit une habitude en JSON
  Map<String, dynamic> _habitToJson(Habit habit) {
    return {
      'name': habit.name,
      'description': habit.description,
      'category': habit.category,
      'frequency': habit.frequency,
      'identityStatement': habit.identityStatement,
      'twoMinuteVersion': habit.twoMinuteVersion,
      'cue': habit.cue,
      'craving': habit.craving,
      'response': habit.response,
      'reward': habit.reward,
      'reminderEnabled': habit.reminderEnabled,
      'reminderTime': habit.reminderTime,
      'color': habit.color,
      'isActive': habit.isActive,
      // Note: On n'exporte pas les stats pour éviter de fausser les données
    };
  }

  /// Convertit du JSON en habitude
  Habit _habitFromJson(Map<String, dynamic> json) {
    return Habit(
      id: 0, // Sera assigné par la DB
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      frequency: json['frequency'] as String,
      identityStatement: json['identityStatement'] as String?,
      twoMinuteVersion: json['twoMinuteVersion'] as String?,
      cue: json['cue'] as String?,
      craving: json['craving'] as String?,
      response: json['response'] as String?,
      reward: json['reward'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      reminderTime: json['reminderTime'] as String?,
      color: json['color'] as int?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
