import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final unlocked = game.unlockedAchievements.length;
        final total = game.achievements.length;

        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.emoji_events,
                            color: AppColors.accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text('Достижения',
                          style: AppTextStyles.h2.copyWith(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats card
                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Открыто', '$unlocked/$total', '🏆'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.textMuted.withOpacity(0.3),
                        ),
                        _buildStat(
                            'Баллы', '${game.totalAchievementPoints}', '⭐'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.textMuted.withOpacity(0.3),
                        ),
                        _buildStat(
                            'Уровень', '${game.user.level}', '📊'),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // XP Progress
                  GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Прогресс уровня',
                                style: AppTextStyles.captionBold),
                            Text(
                              '${game.user.experience}/${game.user.experienceToNext} XP',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: game.user.experienceToNext > 0
                                ? game.user.experience /
                                    game.user.experienceToNext
                                : 0,
                            backgroundColor: AppColors.surface,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 20),

                  // Achievement sections by rarity
                  _buildRaritySection(
                    'Легендарные',
                    '💎',
                    game.achievements
                        .where(
                            (a) => a.rarity == AchievementRarity.legendary)
                        .toList(),
                    const Color(0xFFFF6B35),
                    200,
                  ),
                  _buildRaritySection(
                    'Эпические',
                    '🟣',
                    game.achievements
                        .where((a) => a.rarity == AchievementRarity.epic)
                        .toList(),
                    AppColors.primary,
                    300,
                  ),
                  _buildRaritySection(
                    'Редкие',
                    '🔵',
                    game.achievements
                        .where((a) => a.rarity == AchievementRarity.rare)
                        .toList(),
                    AppColors.secondary,
                    400,
                  ),
                  _buildRaritySection(
                    'Обычные',
                    '⚪',
                    game.achievements
                        .where(
                            (a) => a.rarity == AchievementRarity.common)
                        .toList(),
                    AppColors.textSecondary,
                    500,
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildRaritySection(
    String title,
    String emoji,
    List<Achievement> achievements,
    Color color,
    int delay,
  ) {
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        ...achievements.asMap().entries.map((entry) {
          final index = entry.key;
          final achievement = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildAchievementCard(achievement, color),
          ).animate().fadeIn(
              delay: Duration(milliseconds: delay + index * 60),
              duration: 300.ms);
        }),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement, Color rarityColor) {
    return GlowingCard(
      glowColor: achievement.unlocked ? rarityColor : AppColors.surface,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: achievement.unlocked
                  ? rarityColor.withOpacity(0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: achievement.unlocked
                  ? Text(achievement.icon,
                      style: const TextStyle(fontSize: 24))
                  : const Icon(Icons.lock,
                      color: AppColors.textMuted, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: AppTextStyles.captionBold.copyWith(
                    fontSize: 14,
                    color: achievement.unlocked
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: AppTextStyles.caption.copyWith(
                    color: achievement.unlocked
                        ? AppColors.textSecondary
                        : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (achievement.unlocked
                      ? AppColors.accent
                      : AppColors.textMuted)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${achievement.points}',
              style: AppTextStyles.captionBold.copyWith(
                color:
                    achievement.unlocked ? AppColors.accent : AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
