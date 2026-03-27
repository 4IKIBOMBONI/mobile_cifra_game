import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/widgets/glass_card.dart';
import 'package:cifra_game/widgets/donut_chart.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final formatter = NumberFormat('#,###', 'ru_RU');

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
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.pie_chart,
                            color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text('Распределение бюджета',
                          style: AppTextStyles.h2.copyWith(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Distribution chart
                  GlassCard(
                    child: BudgetDistributionChart(
                      mandatory: game.mandatoryTotal,
                      variable: game.variableTotal,
                      savings: game.savingsTotal,
                      total: game.totalAllocated,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // Mandatory expenses
                  _buildCategorySection(
                    title: 'Обязательные расходы',
                    total: game.mandatoryTotal,
                    percentage: game.totalAllocated > 0
                        ? (game.mandatoryTotal / game.totalAllocated * 100)
                        : 0,
                    categories: game.mandatoryCategories,
                    color: AppColors.error,
                    formatter: formatter,
                    icons: ['🏠', '💡', '📱', '🚌'],
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 12),

                  // Variable expenses
                  _buildCategorySection(
                    title: 'Переменные расходы',
                    total: game.variableTotal,
                    percentage: game.totalAllocated > 0
                        ? (game.variableTotal / game.totalAllocated * 100)
                        : 0,
                    categories: game.variableCategories,
                    color: AppColors.accent,
                    formatter: formatter,
                    icons: ['🎮', '☕', '👕', '📚'],
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 12),

                  // Savings
                  _buildCategorySection(
                    title: 'Накопления',
                    total: game.savingsTotal,
                    percentage: game.totalAllocated > 0
                        ? (game.savingsTotal / game.totalAllocated * 100)
                        : 0,
                    categories: game.savingsCategories,
                    color: AppColors.secondary,
                    formatter: formatter,
                    icons: ['🐷'],
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: 20),

                  // Financial goals
                  Text('Финансовые цели', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  ...game.goals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildGoalCard(context, goal, formatter, game),
                    ).animate().fadeIn(
                        delay: Duration(milliseconds: 400 + index * 100),
                        duration: 400.ms);
                  }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorySection({
    required String title,
    required double total,
    required double percentage,
    required List<BudgetCategory> categories,
    required Color color,
    required NumberFormat formatter,
    required List<String> icons,
  }) {
    return GlowingCard(
      glowColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '₽${formatter.format(total)} (${percentage.round()}%)',
                    style: AppTextStyles.body.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: icons
                    .take(4)
                    .map((i) => Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(i, style: const TextStyle(fontSize: 20)),
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(cat.name, style: AppTextStyles.caption),
                    ),
                    Text(
                      '₽${formatter.format(cat.allocated)}',
                      style: AppTextStyles.captionBold,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, FinancialGoal goal,
      NumberFormat formatter, GameProvider game) {
    final progress = goal.progress.clamp(0.0, 1.0);
    final color = progress >= 1.0
        ? AppColors.success
        : progress > 0.5
            ? AppColors.secondary
            : AppColors.primary;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(goal.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.name, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    Text(
                      '${formatter.format(goal.currentAmount)} / ${formatter.format(goal.targetAmount)} ₽',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.captionBold.copyWith(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearPercentIndicator(
            lineHeight: 10,
            percent: progress,
            backgroundColor: AppColors.surface,
            progressColor: color,
            barRadius: const Radius.circular(5),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                game.contributeToGoal(goal.id, 1000);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${goal.icon} +1,000 ₽ к цели "${goal.name}"'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                'Пополнить +1,000 ₽',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
