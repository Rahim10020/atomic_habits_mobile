import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/constants/colors.dart';
import 'application/providers/data_manager_provider.dart';
import 'application/providers/theme_mode_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for French
  await initializeDateFormatting('fr_FR', null);

  // Initialize notification service
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.requestPermissions();
  } catch (e) {
    debugPrint('Erreur lors de l\'initialisation des notifications: $e');
    // Continue without notifications if initialization fails
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Charger les données d'exemple au premier lancement
    final sampleDataAsync = ref.watch(sampleDataLoaderProvider);

    return MaterialApp.router(
      title: 'Atomic Habits',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,

      // Localization
      locale: const Locale('fr', 'FR'),

      // Router with splash screen
      routerConfig: AppRouter.router(ref),

      // Show splash during data loading
      builder: (context, child) {
        return sampleDataAsync.when(
          data: (_) => child ?? const SizedBox.shrink(),
          loading: () => const _SplashScreen(),
          error: (error, stack) {
            // En cas d'erreur, afficher quand même l'app
            debugPrint('Erreur lors du chargement initial: $error');
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Icon
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Atomic Habits',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              '1% mieux chaque jour',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
