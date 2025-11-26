import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/habit.dart';
import '../../../../domain/use_cases/habit/get_habits_use_case.dart';
import '../../../../infrastructure/database/app_database.dart' hide Habit;
import '../../../../infrastructure/repositories/habit_repository_impl.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository Provider
final habitRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return HabitRepositoryImpl(database);
});

// Use Case Provider
final getHabitsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
});

// Habits List Provider (optimisé)
final habitListProvider = FutureProvider<List<Habit>>((ref) {
  final useCase = ref.watch(getHabitsUseCaseProvider);
  return useCase.execute().then(
    (result) => result.when(
      success: (data) => Future.value(data),
      failure: (failure) => throw Exception(failure.message),
    ),
  );
});

// Habits by Category Provider
final habitsByCategoryProvider = FutureProvider.family<List<Habit>, String>((
  ref,
  category,
) {
  final useCase = ref.watch(getHabitsUseCaseProvider);
  return useCase
      .executeByCategory(category)
      .then(
        (result) => result.when(
          success: (data) => data,
          failure: (failure) => throw Exception(failure.message),
        ),
      );
});
