import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../domain/use_cases/habit/complete_habit_use_case.dart';
import '../../../../domain/use_cases/habit/uncomplete_habit_use_case.dart';
import 'habit_list_provider.dart';

// Use Cases
final completeHabitUseCaseProvider = Provider((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return CompleteHabitUseCase(repository);
});

final uncompleteHabitUseCaseProvider = Provider((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return UncompleteHabitUseCase(repository);
});

// Completion Status Provider
final habitCompletionProvider = FutureProvider.family<bool, int>((
  ref,
  habitId,
) async {
  final repository = ref.watch(habitRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final log = await repository.getLogForHabitOnDate(habitId, today);
  return log != null;
});

// Completion Controller
class HabitCompletionController extends StateNotifier<AsyncValue<void>> {
  final CompleteHabitUseCase _completeUseCase;
  final UncompleteHabitUseCase _uncompleteUseCase;
  final Ref _ref;

  HabitCompletionController(
    this._completeUseCase,
    this._uncompleteUseCase,
    this._ref,
  ) : super(const AsyncValue.data(null));

  Future<Result<void>> complete({
    required int habitId,
    String? note,
    int? mood,
    bool? wasEasy,
  }) async {
    state = const AsyncValue.loading();

    final result = await _completeUseCase.execute(
      habitId: habitId,
      note: note,
      mood: mood,
      wasEasy: wasEasy,
    );

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );

    if (result.isSuccess) {
      // Invalider les providers concernés
      _ref.invalidate(habitCompletionProvider(habitId));
      _ref.invalidate(habitListProvider);
    }

    return result;
  }

  Future<Result<void>> uncomplete({
    required int habitId,
    required DateTime date,
  }) async {
    state = const AsyncValue.loading();

    final result = await _uncompleteUseCase.execute(
      habitId: habitId,
      date: date,
    );

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );

    if (result.isSuccess) {
      _ref.invalidate(habitCompletionProvider(habitId));
      _ref.invalidate(habitListProvider);
    }

    return result;
  }
}

final habitCompletionControllerProvider =
    StateNotifierProvider<HabitCompletionController, AsyncValue<void>>((ref) {
      final completeUseCase = ref.watch(completeHabitUseCaseProvider);
      final uncompleteUseCase = ref.watch(uncompleteHabitUseCaseProvider);
      return HabitCompletionController(completeUseCase, uncompleteUseCase, ref);
    });
