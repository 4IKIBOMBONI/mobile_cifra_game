import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_models.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class BossDialog extends StatefulWidget {
  final BossChallenge boss;

  const BossDialog({super.key, required this.boss});

  @override
  State<BossDialog> createState() => _BossDialogState();
}

class _BossDialogState extends State<BossDialog> {
  String? _outcomeText;
  bool _resolved = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.error.withOpacity(0.4), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Boss badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      'БОСС МЕСЯЦА',
                      style: AppTextStyles.captionBold.copyWith(
                        color: AppColors.error,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 400.ms,
                  ),

              const SizedBox(height: 20),

              // Boss icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.error.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.3),
                    ],
                  ),
                  border: Border.all(color: AppColors.error.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Text(widget.boss.icon, style: const TextStyle(fontSize: 40)),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -3, end: 3, duration: 1500.ms),

              const SizedBox(height: 16),

              Text(
                widget.boss.title,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 8),

              Text(
                widget.boss.description,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 24),

              if (_outcomeText != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text('📋', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        _outcomeText!,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: 'Начать новый месяц!',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      context.read<GameProvider>().endMonth();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ] else ...[
                // Choices
                ...widget.boss.choices.asMap().entries.map((entry) {
                  final choice = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildChoiceCard(context, choice, formatter),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard(BuildContext context, BossChoice choice, NumberFormat formatter) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<GameProvider>().applyBossChoice(choice);
        setState(() {
          _outcomeText = choice.outcome;
          _resolved = true;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              choice.text,
              style: AppTextStyles.captionBold.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (choice.moneyCost != 0)
                  _buildTag(
                    '${choice.moneyCost > 0 ? '+' : ''}${formatter.format(choice.moneyCost)} ₽',
                    choice.moneyCost > 0 ? AppColors.success : AppColors.error,
                  ),
                const SizedBox(width: 6),
                if (choice.pointsReward > 0)
                  _buildTag('+${choice.pointsReward} pts', AppColors.accent),
                const SizedBox(width: 6),
                if (choice.creditScoreImpact != 0)
                  _buildTag(
                    '${choice.creditScoreImpact > 0 ? '↑' : '↓'} Рейтинг',
                    choice.creditScoreImpact > 0 ? AppColors.success : AppColors.error,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(color: color, fontSize: 11),
      ),
    );
  }
}
