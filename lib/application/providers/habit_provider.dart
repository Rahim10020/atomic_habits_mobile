import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_log.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../infrastructure/database/app_database.dart' as db;
import '../../infrastructure/repositories/habit_repository_impl.dart';
import '../../services/notification_service.dart';

// Database Provider
final databaseProvider = Provider<db.AppDatabase>((ref) {
  return db.AppDatabase();
});

// Repository Provider
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return HabitRepositoryImpl(database);
});

// All Habits Provider
final habitsProvider = StreamProvider<List<Habit>>((ref) async* {
  final repository = ref.watch(habitRepositoryProvider);

  // Initial fetch
  yield await repository.getActiveHabits();

  // You can add a stream here if you want real-time updates
  // For now, we'll use refresh to update
});

// Single Habit Provider
final habitProvider = FutureProvider.family<Habit?, int>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitById(habitId);
});

// Habits by Category Provider
final habitsByCategoryProvider = Provider<Map<String, List<Habit>>>((ref) {
  return ref
      .watch(habitsProvider)
      .maybeWhen(
        data: (habits) => groupBy(habits, (habit) => habit.category),
        orElse: () => const {},
      );
});

// Habit Logs Provider
final habitLogsProvider = FutureProvider.family<List<HabitLog>, int>((
  ref,
  habitId,
) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getLogsForHabit(habitId);
});

// Habit Statistics Provider
final habitStatisticsProvider = FutureProvider.family<HabitStatistics, int>((
  ref,
  habitId,
) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitStatistics(habitId);
});

// Today's Completion Status Provider
final todayCompletionProvider = FutureProvider.family<bool, int>((
  ref,
  habitId,
) async {
  final repository = ref.watch(habitRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final log = await repository.getLogForHabitOnDate(habitId, today);
  return log != null;
});

// Dashboard Stats Provider
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);

  final completedCount = await repository.getTodayCompletedCount();
  final pendingCount = await repository.getTodayPendingCount();
  final totalHabits = completedCount + pendingCount;

  return DashboardStats(
    completedCount: completedCount,
    pendingCount: pendingCount,
    totalHabits: totalHabits,
    completionRate: totalHabits > 0 ? (completedCount / totalHabits) * 100 : 0,
  );
});

// Completion Trend Provider
final completionTrendProvider = FutureProvider.family<Map<DateTime, int>, int>((
  ref,
  days,
) async {
  final repository = ref.watch(habitRepositoryProvider);
  final normalizedDays = days < 1 ? 1 : days;
  final now = DateTime.now();
  final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
  final start = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: normalizedDays - 1));

  return repository.getCompletionCountByDay(start: start, end: endOfToday);
});

// Habit Controller for actions
class HabitController extends StateNotifier<AsyncValue<void>> {
  final HabitRepository _repository;
  final NotificationService _notificationService = NotificationService();

  HabitController(this._repository) : super(const AsyncValue.data(null));

  Future<void> createHabit(Habit habit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Créer l'habitude et récupérer l'ID
      final habitId = await _repository.createHabit(habit);

      // Planifier la notification si activée
      if (habit.reminderEnabled && habit.reminderTime != null) {
        try {
          await _notificationService.scheduleHabitReminder(
            habitId: habitId,
            habitName: habit.name,
            time: habit.reminderTime!,
          );
        } catch (e) {
          // Log l'erreur mais ne bloque pas la création
          debugPrint('Erreur lors de la planification de la notification: $e');
        }
      }
    });
  }

  Future<void> updateHabit(Habit habit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Récupérer l'habitude existante pour vérifier les changements
      final existingHabit = await _repository.getHabitById(habit.id);

      await _repository.updateHabit(habit);

      // Gérer les notifications
      if (existingHabit != null) {
        // Annuler l'ancienne notification si elle existait
        if (existingHabit.reminderEnabled) {
          try {
            await _notificationService.cancelHabitReminder(habit.id);
          } catch (e) {
            debugPrint('Erreur lors de l\'annulation de la notification: $e');
          }
        }

        // Planifier une nouvelle notification si activée
        if (habit.reminderEnabled && habit.reminderTime != null) {
          try {
            await _notificationService.scheduleHabitReminder(
              habitId: habit.id,
              habitName: habit.name,
              time: habit.reminderTime!,
            );
          } catch (e) {
            debugPrint(
              'Erreur lors de la planification de la notification: $e',
            );
          }
        }
      }
    });
  }

  Future<void> deleteHabit(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Annuler la notification avant de supprimer
      try {
        await _notificationService.cancelHabitReminder(id);
      } catch (e) {
        debugPrint('Erreur lors de l\'annulation de la notification: $e');
      }

      await _repository.deleteHabit(id);
    });
  }

  Future<void> completeHabit(
    int habitId, {
    String? note,
    int? mood,
    bool? wasEasy,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.completeHabit(
        habitId,
        note: note,
        mood: mood,
        wasEasy: wasEasy,
      );
    });
  }

  Future<void> uncompleteHabit(int habitId, DateTime date) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.uncompleteHabit(habitId, date);
    });
  }
}

final habitControllerProvider =
    StateNotifierProvider<HabitController, AsyncValue<void>>((ref) {
      final repository = ref.watch(habitRepositoryProvider);
      return HabitController(repository);
    });

// Dashboard Stats Model
class DashboardStats {
  final int completedCount;
  final int pendingCount;
  final int totalHabits;
  final double completionRate;

  DashboardStats({
    required this.completedCount,
    required this.pendingCount,
    required this.totalHabits,
    required this.completionRate,
  });
}
