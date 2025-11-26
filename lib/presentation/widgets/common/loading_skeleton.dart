import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

class HabitCardSkeleton extends StatelessWidget {
  const HabitCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.borderLight,
      highlightColor: Colors.white,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: Dimensions.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
      ),
    );
  }
}

class HabitsListSkeleton extends StatelessWidget {
  const HabitsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      itemCount: 5,
      itemBuilder: (context, index) => const HabitCardSkeleton(),
    );
  }
}
