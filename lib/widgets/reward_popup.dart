import 'package:flutter/material.dart';
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
    return Material(
      color: Colors.black54,
      child: InkWell(
        onTap: onDismiss,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox.expand(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: AppColors.accent.withOpacity(0.4), width: 2),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('✨', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 8),
                        Text('🎉', style: TextStyle(fontSize: 40)),
                        SizedBox(width: 8),
                        Text('✨', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Награда!',
                      style: AppTextStyles.h2.copyWith(color: AppColors.accent),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: AppTextStyles.body.copyWith(height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      text: 'Продолжить',
                      onPressed: onDismiss,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
