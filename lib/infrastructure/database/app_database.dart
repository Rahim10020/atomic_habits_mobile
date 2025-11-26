import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../../domain/models/habit.dart';
import '../../domain/models/habit_log.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database upgrades here
    },
  );

  // Habit Queries
  Future<List<Habit>> getAllHabits() async {
    final results = await select(habits).get();
    return results.map((row) => _habitFromRow(row)).toList();
  }

  Future<List<Habit>> getActiveHabits() async {
    final query = select(habits)..where((tbl) => tbl.isActive.equals(true));
    final results = await query.get();
    return results.map((row) => _habitFromRow(row)).toList();
  }

  Future<Habit?> getHabitById(int id) async {
    final query = select(habits)..where((tbl) => tbl.id.equals(id));
    final result = await query.getSingleOrNull();
    return result != null ? _habitFromRow(result) : null;
  }

  Future<List<Habit>> getHabitsByCategory(String category) async {
    final query = select(habits)
      ..where(
        (tbl) => tbl.category.equals(category) & tbl.isActive.equals(true),
      );
    final results = await query.get();
    return results.map((row) => _habitFromRow(row)).toList();
  }

  Future<int> createHabit(HabitsCompanion habit) async {
    return await into(habits).insert(habit);
  }

  Future<bool> updateHabit(HabitsCompanion habit) async {
    return await update(habits).replace(habit);
  }

  Future<int> deleteHabit(int id) async {
    return await (delete(habits)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> softDeleteHabit(int id) async {
    await (update(habits)..where((tbl) => tbl.id.equals(id))).write(
      const HabitsCompanion(isActive: Value(false)),
    );
  }

  // Habit Log Queries
  Future<List<HabitLog>> getLogsForHabit(int habitId) async {
    final query = select(habitLogs)
      ..where((tbl) => tbl.habitId.equals(habitId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)]);
    final results = await query.get();
    return results.map((row) => _habitLogFromRow(row)).toList();
  }

  Future<HabitLog?> getLogForHabitOnDate(int habitId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = select(habitLogs)
      ..where(
        (tbl) =>
            tbl.habitId.equals(habitId) &
            tbl.completedAt.isBiggerOrEqualValue(startOfDay) &
            tbl.completedAt.isSmallerThanValue(endOfDay),
      );

    final result = await query.getSingleOrNull();
    return result != null ? _habitLogFromRow(result) : null;
  }

  Future<int> createHabitLog(HabitLogsCompanion log) async {
    return await into(habitLogs).insert(log);
  }

  Future<int> deleteHabitLog(int id) async {
    return await (delete(habitLogs)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Statistics
  Future<Map<DateTime, bool>> getCompletionHistory(
    int habitId,
    int days,
  ) async {
    final now = DateTime.now();
    final startDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days));

    final query = select(habitLogs)
      ..where(
        (tbl) =>
            tbl.habitId.equals(habitId) &
            tbl.completedAt.isBiggerOrEqualValue(startDate),
      )
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.completedAt)]);

    final logs = await query.get();
    final Map<DateTime, bool> history = {};

    for (int i = 0; i < days; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      history[date] = false;
    }

    for (var log in logs) {
      final date = DateTime(
        log.completedAt.year,
        log.completedAt.month,
        log.completedAt.day,
      );
      history[date] = true;
    }

    return history;
  }

  Future<int> getCurrentStreak(int habitId) async {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final log = await getLogForHabitOnDate(habitId, date);

      if (log != null) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Future<void> updateHabitStreaks(int habitId) async {
    final currentStreak = await getCurrentStreak(habitId);
    final habit = await getHabitById(habitId);

    if (habit != null) {
      final longestStreak = currentStreak > habit.longestStreak
          ? currentStreak
          : habit.longestStreak;

      await (update(habits)..where((tbl) => tbl.id.equals(habitId))).write(
        HabitsCompanion(
          currentStreak: Value(currentStreak),
          longestStreak: Value(longestStreak),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> incrementHabitCompletions(int habitId) async {
    final habit = await getHabitById(habitId);
    if (habit != null) {
      await (update(habits)..where((tbl) => tbl.id.equals(habitId))).write(
        HabitsCompanion(
          totalCompletions: Value(habit.totalCompletions + 1),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // Helper methods to convert database rows to model objects
  Habit _habitFromRow(Habit row) => row;

  HabitLog _habitLogFromRow(HabitLog row) => row;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'atomic_habits.db'));
    return NativeDatabase(file);
  });
}
