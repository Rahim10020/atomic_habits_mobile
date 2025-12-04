import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Widget personnalisé pour afficher des notifications de succès ou d'échec
/// avec un design moderne et attrayant
class CustomSnackBar extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final IconData? icon;
  final Duration duration;

  const CustomSnackBar({
    super.key,
    required this.message,
    this.isSuccess = true,
    this.icon,
    this.duration = const Duration(seconds: 3),
  });

  /// Affiche une notification de succès
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackBar(
          message: message,
          isSuccess: true,
          icon: Icons.check_circle_rounded,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: duration,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Affiche une notification d'erreur
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackBar(
          message: message,
          isSuccess: false,
          icon: Icons.error_rounded,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: duration,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Affiche une notification d'information
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackBar(
          message: message,
          isSuccess: false,
          icon: Icons.info_rounded,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: duration,
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppColors.success : AppColors.error;
    final defaultIcon = isSuccess
        ? Icons.check_circle_rounded
        : Icons.error_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
        vertical: AppConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? defaultIcon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
