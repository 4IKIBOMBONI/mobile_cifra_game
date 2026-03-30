import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class RewardPopup extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const RewardPopup({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stars animation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 28))
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(begin: -5, end: 5, duration: 800.ms),
                      const SizedBox(width: 8),
                      const Text('🎉', style: TextStyle(fontSize: 40))
                          .animate()
                          .scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1.0, 1.0),
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),
                      const SizedBox(width: 8),
                      const Text('✨', style: TextStyle(fontSize: 28))
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(begin: 5, end: -5, duration: 800.ms),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Награда!',
                    style: AppTextStyles.h2.copyWith(color: AppColors.accent),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: AppTextStyles.body.copyWith(height: 1.4),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 20),
                  Text(
                    'Нажмите, чтобы продолжить',
                    style: AppTextStyles.caption,
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(delay: 600.ms)
                      .then()
                      .fadeOut(duration: 1000.ms)
                      .then()
                      .fadeIn(duration: 1000.ms),
                ],
              ),
            ).animate().scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
          ),
        ),
      ),
    );
  }
}
