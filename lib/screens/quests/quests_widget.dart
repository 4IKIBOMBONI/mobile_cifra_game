import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_models.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class DailyQuestsWidget extends StatelessWidget {
  const DailyQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.dailyQuests.isEmpty) return const SizedBox.shrink();

        final completed = game.completedQuestsCount;
        final total = game.dailyQuests.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('⚔️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text('Ежедневные квесты', style: AppTextStyles.h3),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: completed == total
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$completed/$total',
                    style: AppTextStyles.captionBold.copyWith(
                      color: completed == total ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...game.dailyQuests.asMap().entries.map((entry) {
              final index = entry.key;
              final quest = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildQuestCard(quest),
              ).animate().fadeIn(
                delay: Duration(milliseconds: index * 100),
                duration: 300.ms,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildQuestCard(DailyQuest quest) {
    return GlowingCard(
      glowColor: quest.completed ? AppColors.success : AppColors.primary,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (quest.completed ? AppColors.success : AppColors.primary).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: quest.completed
                  ? const Icon(Icons.check_circle, color: AppColors.success, size: 24)
                  : Text(quest.icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.title,
                  style: AppTextStyles.captionBold.copyWith(
                    fontSize: 14,
                    decoration: quest.completed ? TextDecoration.lineThrough : null,
                    color: quest.completed ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  quest.description,
                  style: AppTextStyles.caption.copyWith(fontSize: 12),
                ),
                if (!quest.completed) ...[
                  const SizedBox(height: 6),
                  LinearPercentIndicator(
                    lineHeight: 6,
                    percent: quest.progress,
                    backgroundColor: AppColors.surface,
                    progressColor: AppColors.secondary,
                    barRadius: const Radius.circular(3),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${quest.rewardPoints}',
              style: AppTextStyles.captionBold.copyWith(
                color: quest.completed ? AppColors.textMuted : AppColors.accent,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
