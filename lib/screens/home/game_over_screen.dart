import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameProvider>();
    final formatter = NumberFormat('#,###', 'ru_RU');
    final credit = game.creditScoreData;

    // Calculate final grade
    String grade;
    String gradeEmoji;
    Color gradeColor;
    String verdict;

    final totalScore = game.points +
        game.totalAchievementPoints +
        credit.score +
        (game.balance > 0 ? 100 : 0);

    if (totalScore >= 5000) {
      grade = 'S';
      gradeEmoji = '👑';
      gradeColor = AppColors.accent;
      verdict = 'Финансовый гений! Вы мастерски управляли бюджетом, инвестировали и достигли всех целей.';
    } else if (totalScore >= 3000) {
      grade = 'A';
      gradeEmoji = '🌟';
      gradeColor = AppColors.success;
      verdict = 'Отличный результат! Вы показали высокую финансовую грамотность.';
    } else if (totalScore >= 1500) {
      grade = 'B';
      gradeEmoji = '👍';
      gradeColor = AppColors.secondary;
      verdict = 'Хороший результат! Есть куда расти, но основы вы освоили.';
    } else if (totalScore >= 800) {
      grade = 'C';
      gradeEmoji = '📊';
      gradeColor = AppColors.primary;
      verdict = 'Неплохо для начала. Попробуйте ещё раз и улучшите свой результат!';
    } else {
      grade = 'D';
      gradeEmoji = '📚';
      gradeColor = AppColors.error;
      verdict = 'Финансы — это навык. Попробуйте снова и учитесь на ошибках!';
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Title
                Text(gradeEmoji, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('Год завершён!', style: AppTextStyles.h1),
                const SizedBox(height: 8),
                Text(
                  'Итоги вашего финансового пути',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 24),

                // Grade card
                GlowingCard(
                  glowColor: gradeColor,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Оценка', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Text(
                        grade,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 64,
                          color: gradeColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verdict,
                        style: AppTextStyles.body.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '💰',
                        'Баланс',
                        '${formatter.format(game.balance)} ₽',
                        game.balance >= 0 ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '⭐',
                        'Баллы',
                        '${formatter.format(game.points)}',
                        AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '📊',
                        'Кред. рейтинг',
                        '${credit.score}',
                        credit.score >= 700 ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '🎓',
                        'Уровень',
                        '${game.user.level}',
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '🏆',
                        'Достижения',
                        '${game.unlockedAchievements.length}/${game.achievements.length}',
                        AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '📚',
                        'Уроки',
                        '${game.completedLessonsCount}/${game.lessons.length}',
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Portfolio value
                if (game.portfolio.isNotEmpty)
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('📈', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Портфель акций', style: AppTextStyles.captionBold),
                            Text(
                              '${formatter.format(game.portfolioValue)} ₽',
                              style: AppTextStyles.h3,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '${game.portfolioProfit >= 0 ? '+' : ''}${formatter.format(game.portfolioProfit)} ₽',
                          style: AppTextStyles.captionBold.copyWith(
                            color: game.portfolioProfit >= 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Total score
                GlassCard(
                  borderColor: gradeColor.withOpacity(0.4),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Итоговый счёт', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Text(
                        '${formatter.format(totalScore)}',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 40,
                          color: gradeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Play again button
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: 'Играть заново',
                    icon: Icons.replay,
                    onPressed: () {
                      game.resetGame();
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: color, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
