import 'package:atomic_habits_mobile/domain/models/habit.dart';
import 'package:drift/drift.dart';

class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId =>
      integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get note => text().nullable()();
  IntColumn get mood => integer().nullable()(); // 1-5 rating for how they felt
  BoolColumn get wasEasy =>
      boolean().nullable()(); // Track if the habit was easy to do

  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Model class for working with habit logs
class HabitLog {
  final int id;
  final int habitId;
  final DateTime completedAt;
  final String? note;
  final int? mood;
  final bool? wasEasy;
  final DateTime createdAt;

  HabitLog({
    required this.id,
    required this.habitId,
    required this.completedAt,
    this.note,
    this.mood,
    this.wasEasy,
    required this.createdAt,
  });

  HabitLog copyWith({
    int? id,
    int? habitId,
    DateTime? completedAt,
    String? note,
    int? mood,
    bool? wasEasy,
    DateTime? createdAt,
  }) {
    return HabitLog(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      mood: mood ?? this.mood,
      wasEasy: wasEasy ?? this.wasEasy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Helper class for habit statistics
class HabitStatistics {
  final int habitId;
  final int totalCompletions;
  final int currentStreak;
  final int longestStreak;
  final double completionRate; // Percentage
  final Map<DateTime, bool> completionHistory; // Date -> completed
  final List<int> weeklyCompletions; // Last 7 days
  final List<int> monthlyCompletions; // Last 30 days

  HabitStatistics({
    required this.habitId,
    required this.totalCompletions,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionRate,
    required this.completionHistory,
    required this.weeklyCompletions,
    required this.monthlyCompletions,
  });
}
