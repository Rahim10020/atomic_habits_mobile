import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../application/providers/data_manager_provider.dart';
import '../../../core/router/app_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bienvenue dans\nAtomic Habits',
      description:
          'Transformez votre vie avec de petites habitudes qui font une grande différence. Commencez dès aujourd\'hui votre parcours vers une meilleure version de vous-même.',
      imagePath: 'assets/images/working.png',
      imageType: ImageType.png,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: '1% mieux\nchaque jour',
      description:
          'Si vous vous améliorez de 1% chaque jour pendant un an, vous serez 37 fois meilleur à la fin. Chaque petit pas compte vers votre réussite.',
      imagePath: 'assets/images/young-man.png',
      imageType: ImageType.png,
      color: AppColors.success,
    ),
    OnboardingPage(
      title: 'Célébrez vos\nsuccès',
      description:
          'Chaque habitude accomplie est une victoire. Prenez le temps de célébrer vos progrès et de reconnaître les changements positifs dans votre vie.',
      imagePath: 'assets/images/celebrate.svg',
      imageType: ImageType.svg,
      color: AppColors.accent,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index == _currentPage),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentPage == _pages.length - 1) {
                          // Marquer l'onboarding comme terminé
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('first_launch', false);
                          if (!context.mounted) return;
                          // Invalider le provider pour mettre à jour l'état
                          ref.invalidate(firstLaunchProvider);

                          context.go(AppRouter.home);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Commencer'
                            : 'Suivant',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),

                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('first_launch', false);
                        if (!context.mounted) return;
                        ref.invalidate(firstLaunchProvider);
                        context.go(AppRouter.home);
                      },
                      child: const Text('Passer'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [page.color.withValues(alpha: 0.05), Colors.white],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: AppConstants.paddingMedium,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Center(
                child: Hero(
                  tag: 'onboarding_image_${_pages.indexOf(page)}',
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                      maxHeight: 300,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: page.color.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: page.imageType == ImageType.svg
                          ? SvgPicture.asset(
                              page.imagePath,
                              fit: BoxFit.contain,
                              width: 300,
                              height: 300,
                            )
                          : Image.asset(
                              page.imagePath,
                              fit: BoxFit.contain,
                              width: 300,
                              height: 300,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Text section
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    page.title,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: page.color,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      page.description,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondaryLight,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.borderLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

enum ImageType { png, svg }

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final ImageType imageType;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.imageType,
    required this.color,
  });
}
