import 'package:drift/drift.dart';
import '../../domain/models/habit.dart' as model;
import '../../domain/models/habit_log.dart' as model;
import '../../domain/repositories/habit_repository.dart';
import '../database/app_database.dart';

/// Implémentation optimisée du repository des habitudes
class HabitRepositoryImpl implements HabitRepository {
  final AppDatabase _database;

  HabitRepositoryImpl(this._database);

  /// Mappe un log Drift vers le modèle domain
  model.HabitLog _mapLogToModel(HabitLog driftLog) {
    return model.HabitLog(
      id: driftLog.id,
      habitId: driftLog.habitId,
      completedAt: driftLog.completedAt,
      note: driftLog.note,
      mood: driftLog.mood,
      wasEasy: driftLog.wasEasy,
      createdAt: driftLog.createdAt,
    );
  }

  /// Mappe un habit Drift vers le modèle domain
  model.Habit _mapToModel(Habit driftHabit) {
    return model.Habit(
      id: driftHabit.id,
      name: driftHabit.name,
      description: driftHabit.description,
      category: driftHabit.category,
      frequency: driftHabit.frequency,
      identityStatement: driftHabit.identityStatement,
      twoMinuteVersion: driftHabit.twoMinuteVersion,
      cue: driftHabit.cue,
      craving: driftHabit.craving,
      response: driftHabit.response,
      reward: driftHabit.reward,
      reminderEnabled: driftHabit.reminderEnabled,
      reminderTime: driftHabit.reminderTime,
      isActive: driftHabit.isActive,
      color: driftHabit.color,
      currentStreak: driftHabit.currentStreak,
      longestStreak: driftHabit.longestStreak,
      totalCompletions: driftHabit.totalCompletions,
      createdAt: driftHabit.createdAt,
      updatedAt: driftHabit.updatedAt,
    );
  }

  @override
  Future<List<model.Habit>> getAllHabits() async {
    final habits = await _database.getAllHabits();
    return habits.map((h) => _mapToModel(h)).toList();
  }

  @override
  Future<List<model.Habit>> getActiveHabits() async {
    final habits = await _database.getActiveHabits();
    return habits.map((h) => _mapToModel(h)).toList();
  }

  @override
  Future<model.Habit?> getHabitById(int id) async {
    final habit = await _database.getHabitById(id);
    return habit != null ? _mapToModel(habit) : null;
  }

  @override
  Future<List<model.Habit>> getHabitsByCategory(String category) async {
    final habits = await _database.getHabitsByCategory(category);
    return habits.map((h) => _mapToModel(h)).toList();
  }

  @override
  Future<int> createHabit(model.Habit habit) async {
    final companion = HabitsCompanion(
      name: Value(habit.name),
      description: Value(habit.description),
      category: Value(habit.category),
      frequency: Value(habit.frequency),
      identityStatement: Value(habit.identityStatement),
      twoMinuteVersion: Value(habit.twoMinuteVersion),
      cue: Value(habit.cue),
      craving: Value(habit.craving),
      response: Value(habit.response),
      reward: Value(habit.reward),
      reminderEnabled: Value(habit.reminderEnabled),
      reminderTime: Value(habit.reminderTime),
      color: Value(habit.color),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    return await _database.createHabit(companion);
  }

  @override
  Future<void> updateHabit(model.Habit habit) async {
    final companion = HabitsCompanion(
      id: Value(habit.id),
      name: Value(habit.name),
      description: Value(habit.description),
      category: Value(habit.category),
      frequency: Value(habit.frequency),
      identityStatement: Value(habit.identityStatement),
      twoMinuteVersion: Value(habit.twoMinuteVersion),
      cue: Value(habit.cue),
      craving: Value(habit.craving),
      response: Value(habit.response),
      reward: Value(habit.reward),
      reminderEnabled: Value(habit.reminderEnabled),
      reminderTime: Value(habit.reminderTime),
      isActive: Value(habit.isActive),
      color: Value(habit.color),
      currentStreak: Value(habit.currentStreak),
      longestStreak: Value(habit.longestStreak),
      totalCompletions: Value(habit.totalCompletions),
      createdAt: Value(habit.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _database.updateHabit(companion);
  }

  @override
  Future<void> deleteHabit(int id) async {
    await _database.deleteHabit(id);
  }

  @override
  Future<void> softDeleteHabit(int id) async {
    await _database.softDeleteHabit(id);
  }

  @override
  Future<List<model.HabitLog>> getLogsForHabit(int habitId) async {
    final logs = await _database.getLogsForHabit(habitId);
    return logs.map((log) => _mapLogToModel(log)).toList();
  }

  @override
  Future<model.HabitLog?> getLogForHabitOnDate(
    int habitId,
    DateTime date,
  ) async {
    final log = await _database.getLogForHabitOnDate(habitId, date);
    return log != null ? _mapLogToModel(log) : null;
  }

  @override
  Future<void> completeHabit(
    int habitId, {
    String? note,
    int? mood,
    bool? wasEasy,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if already completed today
    final existingLog = await _database.getLogForHabitOnDate(habitId, today);

    if (existingLog == null) {
      final companion = HabitLogsCompanion(
        habitId: Value(habitId),
        completedAt: Value(now),
        note: Value(note),
        mood: Value(mood),
        wasEasy: Value(wasEasy),
        createdAt: Value(now),
      );

      await _database.createHabitLog(companion);
      await _database.incrementHabitCompletions(habitId);
      await _database.updateHabitStreaks(habitId);
    }
  }

  @override
  Future<void> uncompleteHabit(int habitId, DateTime date) async {
    final log = await _database.getLogForHabitOnDate(habitId, date);
    if (log != null) {
      await _database.deleteHabitLog(log.id);
      await _database.updateHabitStreaks(habitId);

      // Decrement total completions
      final habit = await _database.getHabitById(habitId);
      if (habit != null && habit.totalCompletions > 0) {
        await _database.updateHabit(
          HabitsCompanion(
            id: Value(habitId),
            totalCompletions: Value(habit.totalCompletions - 1),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
  }

  @override
  Future<Map<DateTime, bool>> getCompletionHistory(
    int habitId,
    int days,
  ) async {
    return await _database.getCompletionHistory(habitId, days);
  }

  @override
  Future<int> getCurrentStreak(int habitId) async {
    return await _database.getCurrentStreak(habitId);
  }

  @override
  Future<model.HabitStatistics> getHabitStatistics(int habitId) async {
    final habit = await _database.getHabitById(habitId);
    if (habit == null) {
      throw Exception('Habit not found');
    }

    final completionHistory = await getCompletionHistory(habitId, 365);
    final currentStreak = await getCurrentStreak(habitId);

    // Calculate completion rate
    final completedDays = completionHistory.values
        .where((completed) => completed)
        .length;
    final totalDays = completionHistory.length;
    final completionRate = totalDays > 0
        ? (completedDays / totalDays) * 100
        : 0.0;

    // Get weekly completions (last 7 days)
    final now = DateTime.now();
    final weeklyCompletions = List<int>.filled(7, 0);
    for (int i = 0; i < 7; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      if (completionHistory[date] == true) {
        weeklyCompletions[6 - i] = 1;
      }
    }

    // Get monthly completions (last 30 days)
    final monthlyCompletions = List<int>.filled(30, 0);
    for (int i = 0; i < 30; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      if (completionHistory[date] == true) {
        monthlyCompletions[29 - i] = 1;
      }
    }

    return model.HabitStatistics(
      habitId: habitId,
      totalCompletions: habit.totalCompletions,
      currentStreak: currentStreak,
      longestStreak: habit.longestStreak,
      completionRate: completionRate,
      completionHistory: completionHistory,
      weeklyCompletions: weeklyCompletions,
      monthlyCompletions: monthlyCompletions,
    );
  }

  @override
  Future<int> getTodayCompletedCount() async {
    // OPTIMISÉ: Une seule requête SQL avec JOIN au lieu de N+1 requêtes
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final result = await _database
        .customSelect(
          '''
          SELECT COUNT(DISTINCT h.id) as count
          FROM habits h
          INNER JOIN habit_logs hl ON h.id = hl.habit_id
          WHERE h.is_active = 1
          AND hl.completed_at >= ?
          AND hl.completed_at < ?
          ''',
          variables: [
            Variable.withDateTime(today),
            Variable.withDateTime(tomorrow),
          ],
        )
        .getSingle();

    return result.read<int>('count');
  }

  @override
  Future<int> getTodayPendingCount() async {
    // OPTIMISÉ: Une seule requête SQL avec LEFT JOIN
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final result = await _database
        .customSelect(
          '''
          SELECT COUNT(h.id) as count
          FROM habits h
          LEFT JOIN habit_logs hl ON h.id = hl.habit_id 
            AND hl.completed_at >= ? 
            AND hl.completed_at < ?
          WHERE h.is_active = 1
          AND hl.id IS NULL
          ''',
          variables: [
            Variable.withDateTime(today),
            Variable.withDateTime(tomorrow),
          ],
        )
        .getSingle();

    return result.read<int>('count');
  }

  @override
  Future<List<model.Habit>> getTodayHabits() async {
    return await getActiveHabits();
  }
}
