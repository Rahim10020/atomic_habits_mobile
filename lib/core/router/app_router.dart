import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/habit/create_habit_screen.dart';
import '../../presentation/screens/habit/edit_habit_screen.dart';
import '../../presentation/screens/habit/habit_detail_screen.dart';
import '../../presentation/screens/statistics/statistics_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../application/providers/data_manager_provider.dart';

class AppRouter {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String createHabit = '/create-habit';
  static const String editHabit = '/edit-habit';
  static const String habitDetail = '/habit-detail';
  static const String statistics = '/statistics';
  static const String settings = '/settings';

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: home,
      redirect: (context, state) {
        final isFirstLaunchAsync = ref.watch(firstLaunchProvider);
        return isFirstLaunchAsync.maybeWhen(
          data: (isFirstLaunch) => isFirstLaunch ? onboarding : null,
          orElse: () => null,
        );
      },
      routes: [
        GoRoute(
          path: onboarding,
          name: 'onboarding',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
        GoRoute(
          path: home,
          name: 'home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
        GoRoute(
          path: createHabit,
          name: 'create-habit',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CreateHabitScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          ),
        ),
        GoRoute(
          path: '$editHabit/:id',
          name: 'edit-habit',
          pageBuilder: (context, state) {
            final habitId = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: EditHabitScreen(habitId: habitId),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    final tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
            );
          },
        ),
        GoRoute(
          path: '$habitDetail/:id',
          name: 'habit-detail',
          pageBuilder: (context, state) {
            final habitId = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: HabitDetailScreen(habitId: habitId),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
        GoRoute(
          path: statistics,
          name: 'statistics',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const StatisticsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          ),
        ),
      ],
    );
  }
}
