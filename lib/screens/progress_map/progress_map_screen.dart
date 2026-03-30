import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_models.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class ProgressMapScreen extends StatelessWidget {
  const ProgressMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.map, color: AppColors.accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text('Карта прогресса', style: AppTextStyles.h2.copyWith(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Развивайте карьеру и открывайте новые возможности',
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Credit score card
                  _buildCreditScoreCard(game)
                      .animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Life stages path
                  Text('Жизненный путь', style: AppTextStyles.h3),
                  const SizedBox(height: 16),

                  ...game.lifeStages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stage = entry.value;
                    final isCurrent = game.currentStage.id == stage.id;
                    final isLast = index == game.lifeStages.length - 1;

                    return Column(
                      children: [
                        _buildStageNode(stage, isCurrent, game.user.level),
                        if (!isLast) _buildConnector(stage.unlocked),
                      ],
                    ).animate().fadeIn(
                      delay: Duration(milliseconds: 200 + index * 150),
                      duration: 400.ms,
                    );
                  }),

                  const SizedBox(height: 24),

                  // Stats summary
                  _buildGameStats(game)
                      .animate().fadeIn(delay: 800.ms, duration: 400.ms),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreditScoreCard(GameProvider game) {
    final credit = game.creditScoreData;
    Color gaugeColor;
    if (credit.score >= 750) {
      gaugeColor = AppColors.success;
    } else if (credit.score >= 670) {
      gaugeColor = AppColors.secondary;
    } else if (credit.score >= 580) {
      gaugeColor = AppColors.accent;
    } else {
      gaugeColor = AppColors.error;
    }

    return GlassCard(
      borderColor: gaugeColor.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Кредитный рейтинг', style: AppTextStyles.h3),
              const Spacer(),
              Text(credit.emoji, style: const TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          // Score gauge
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 100,
                      child: CustomPaint(
                        painter: _GaugePainter(
                          score: credit.score,
                          color: gaugeColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Column(
                        children: [
                          Text(
                            '${credit.score}',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 36,
                              color: gaugeColor,
                            ),
                          ),
                          Text(credit.rating, style: AppTextStyles.captionBold),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Factors
          ...credit.factors.map((factor) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      factor.impact == CreditImpact.positive
                          ? Icons.arrow_upward
                          : factor.impact == CreditImpact.negative
                              ? Icons.arrow_downward
                              : Icons.remove,
                      size: 16,
                      color: factor.impact == CreditImpact.positive
                          ? AppColors.success
                          : factor.impact == CreditImpact.negative
                              ? AppColors.error
                              : AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(factor.name, style: AppTextStyles.captionBold.copyWith(fontSize: 13)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(factor.description, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStageNode(LifeStage stage, bool isCurrent, int userLevel) {
    final isUnlocked = userLevel >= stage.requiredLevel;
    final glowColor = isCurrent
        ? AppColors.accent
        : isUnlocked
            ? AppColors.success
            : AppColors.textMuted;

    return GlowingCard(
      glowColor: glowColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Stage icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: glowColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: isCurrent
                  ? Border.all(color: AppColors.accent, width: 2)
                  : null,
            ),
            child: Center(
              child: isUnlocked
                  ? Text(stage.icon, style: const TextStyle(fontSize: 28))
                  : const Icon(Icons.lock, color: AppColors.textMuted, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      stage.title,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 15,
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Сейчас', style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent, fontSize: 10,
                        )),
                      ),
                    ],
                  ],
                ),
                Text(
                  stage.description,
                  style: AppTextStyles.caption.copyWith(fontSize: 12),
                ),
                if (isUnlocked) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: stage.perks.map((perk) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(perk, style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondary, fontSize: 10,
                          )),
                        )).toList(),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Text(
                    'Требуется уровень ${stage.requiredLevel}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool unlocked) {
    return Padding(
      padding: const EdgeInsets.only(left: 43),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 3,
          height: 24,
          decoration: BoxDecoration(
            color: unlocked ? AppColors.secondary.withOpacity(0.5) : AppColors.textMuted.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildGameStats(GameProvider game) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Игровая статистика', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statItem('📅', '${game.totalMonthsPlayed}', 'Месяцев')),
              Expanded(child: _statItem('🔥', '${game.streak}', 'Дней подряд')),
              Expanded(child: _statItem('📈', '${game.portfolio.length}', 'Акций')),
              Expanded(child: _statItem('🎓', '${game.completedLessonsCount}', 'Уроков')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final int score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // pi
      3.14159,
      false,
      bgPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    double progress = ((score - 300) / 550).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      3.14159 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
