import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/widgets/glass_card.dart';
import 'package:cifra_game/widgets/donut_chart.dart';
import 'package:cifra_game/screens/home/add_expense_sheet.dart';
import 'package:cifra_game/screens/home/event_dialog.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  _buildHeader(context, game),
                  const SizedBox(height: 20),

                  // Balance card
                  _buildBalanceCard(game, formatter)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),

                  // Month progress
                  _buildMonthProgress(game)
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 20),

                  // Expense chart
                  GlassCard(
                    child: BudgetDonutChart(
                      categories: game.categories
                          .where((c) => c.type != BudgetCategoryType.savings)
                          .toList(),
                      totalExpenses: game.totalAllocated,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 20),

                  // Quick actions
                  _buildQuickActions(context, game, formatter)
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 20),

                  // Financial health score
                  _buildHealthScore(game)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider game) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.secondary,
              width: 2,
            ),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Привет, ${game.user.name}!',
              style: AppTextStyles.h3,
            ),
            Text(
              'Уровень ${game.user.level}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const Spacer(),
        // Streak badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '${game.streak}',
                style: AppTextStyles.captionBold.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Notifications
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(GameProvider game, NumberFormat formatter) {
    return GlassCard(
      borderColor: AppColors.secondary.withOpacity(0.3),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Текущий баланс',
            style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${formatter.format(game.balance)} ₽',
            style: AppTextStyles.balance,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet,
                  color: AppColors.secondary, size: 16),
              const SizedBox(width: 6),
              Text(
                'Зарплата: ${formatter.format(game.salary)} ₽',
                style: AppTextStyles.caption,
              ),
              const SizedBox(width: 16),
              Text(
                '|',
                style: AppTextStyles.caption,
              ),
              const SizedBox(width: 16),
              Text(
                'Следующая: 01.${(game.currentMonth % 12 + 1).toString().padLeft(2, '0')}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthProgress(GameProvider game) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${game.monthName}: ',
                      style: AppTextStyles.captionBold.copyWith(fontSize: 14),
                    ),
                    TextSpan(
                      text: 'День ${game.currentDay} из ${game.totalDaysInMonth}',
                      style: AppTextStyles.caption.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Text(
                'Осталось: ${game.daysRemaining} дней',
                style: AppTextStyles.caption.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 20,
            percent: game.monthProgress,
            backgroundColor: AppColors.surface,
            linearGradient: AppColors.primaryGradient,
            barRadius: const Radius.circular(10),
            center: Text(
              '${(game.monthProgress * 100).round()}%',
              style: AppTextStyles.captionBold.copyWith(fontSize: 11),
            ),
            animation: true,
            animationDuration: 800,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, GameProvider game, NumberFormat formatter) {
    return Row(
      children: [
        _buildActionCard(
          context,
          icon: Icons.credit_card,
          iconColor: AppColors.primary,
          title: 'Расходы',
          subtitle: 'Добавить расход',
          onTap: () => _showAddExpense(context),
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          context,
          icon: Icons.savings,
          iconColor: AppColors.accent,
          title: 'Накопления',
          subtitle: 'Копилка +500 ₽',
          onTap: () {
            game.addToSavings(500);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✨ +500 ₽ в копилку!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          context,
          icon: Icons.fast_forward,
          iconColor: AppColors.secondary,
          title: 'Следующий',
          subtitle: 'День →',
          onTap: () {
            game.advanceDay();
            // Check for random event
            if (game.currentDay % 3 == 0) {
              final event = game.getRandomEvent();
              if (event != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => EventDialog(event: event),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GlowingCard(
        glowColor: iconColor,
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.captionBold.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScore(GameProvider game) {
    final score = game.healthScore;
    Color scoreColor;
    switch (score.grade) {
      case 'A':
        scoreColor = AppColors.success;
        break;
      case 'B':
        scoreColor = AppColors.secondary;
        break;
      case 'C':
        scoreColor = AppColors.accent;
        break;
      case 'D':
        scoreColor = AppColors.warning;
        break;
      default:
        scoreColor = AppColors.error;
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Финансовое здоровье', style: AppTextStyles.h3),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: scoreColor.withOpacity(0.4)),
                ),
                child: Text(
                  '${score.grade} · ${score.score}',
                  style: AppTextStyles.captionBold.copyWith(
                    color: scoreColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score.score / 100,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              minHeight: 8,
            ),
          ),
          if (score.tips.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...score.tips.take(2).map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: AppColors.accent, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: AppTextStyles.caption.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  void _showAddExpense(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    );
  }
}
