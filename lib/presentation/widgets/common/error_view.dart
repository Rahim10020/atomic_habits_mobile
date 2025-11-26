import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/dimensions.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: Dimensions.iconXXLarge,
              color: AppColors.error,
            ),
            const SizedBox(height: Dimensions.paddingMedium),
            Text(
              'Une erreur est survenue',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.paddingSmall),
            Text(
              error.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Dimensions.paddingLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
