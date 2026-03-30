import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/models/game_models.dart';
import 'package:cifra_game/widgets/glass_card.dart';
import 'package:cifra_game/widgets/reward_popup.dart';
import 'package:cifra_game/screens/home/add_expense_sheet.dart';
import 'package:cifra_game/screens/home/event_dialog.dart';
import 'package:cifra_game/screens/home/boss_dialog.dart';
import 'package:cifra_game/screens/quests/quests_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showReward = false;
  String _rewardMessage = '';

  void _checkReward(GameProvider game) {
    if (_showReward) return; // Don't stack rewards
    if (game.pendingReward != null) {
      final msg = game.pendingReward!;
      game.clearPendingReward();
      if (mounted) {
        setState(() {
          _rewardMessage = msg;
          _showReward = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final formatter = NumberFormat('#,###', 'ru_RU');

        // Check for pending rewards after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _checkReward(game);
        });

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar
                      _buildTopBar(game, formatter),
                      const SizedBox(height: 16),

                      // Day card with actions
                      _buildDayCard(context, game, formatter)
                          .animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 16),

                      // Balance + stats
                      _buildBalanceRow(game, formatter)
                          .animate().fadeIn(delay: 100.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Credit score mini
                      _buildCreditMini(game)
                          .animate().fadeIn(delay: 150.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Daily quests
                      const DailyQuestsWidget()
                          .animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Action buttons
                      _buildActionGrid(context, game)
                          .animate().fadeIn(delay: 300.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Portfolio mini
                      if (game.portfolio.isNotEmpty)
                        _buildPortfolioMini(game, formatter)
                            .animate().fadeIn(delay: 350.ms, duration: 400.ms),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            // Reward overlay
            if (_showReward)
              RewardPopup(
                message: _rewardMessage,
                onDismiss: () => setState(() => _showReward = false),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(GameProvider game, NumberFormat formatter) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary, width: 2),
          ),
          child: Center(
            child: Text(game.currentStage.icon, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.user.name, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            Row(
              children: [
                Text('Ур. ${game.user.level}', style: AppTextStyles.caption),
                const SizedBox(width: 6),
                Text('·', style: AppTextStyles.caption),
                const SizedBox(width: 6),
                Text(game.currentStage.title, style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontSize: 11)),
              ],
            ),
          ],
        ),
        const Spacer(),
        // Streak
        _buildMiniBadge('🔥', '${game.streak}', AppColors.error),
        const SizedBox(width: 6),
        // Points
        _buildMiniBadge('⭐', '${game.points}', AppColors.accent),
      ],
    );
  }

  Widget _buildMiniBadge(String emoji, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 3),
          Text(value, style: AppTextStyles.captionBold.copyWith(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, GameProvider game, NumberFormat formatter) {
    return GlassCard(
      borderColor: AppColors.secondary.withOpacity(0.3),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Month + day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.monthName, style: AppTextStyles.h2),
                  Text('День ${game.currentDay} из ${game.totalDaysInMonth}', style: AppTextStyles.bodySecondary),
                ],
              ),
              // Next day button
              GestureDetector(
                onTap: () => _advanceDay(context, game),
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 15, spreadRadius: 2),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 28),
                      Text('День', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          LinearPercentIndicator(
            lineHeight: 16,
            percent: game.monthProgress,
            backgroundColor: AppColors.surface,
            linearGradient: AppColors.primaryGradient,
            barRadius: const Radius.circular(8),
            center: Text(
              '${(game.monthProgress * 100).round()}%',
              style: AppTextStyles.captionBold.copyWith(fontSize: 10),
            ),
            animation: true,
            animationDuration: 500,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Осталось: ${game.daysRemaining} дней', style: AppTextStyles.caption),
              Text(
                'Зарплата: ${formatter.format(game.salary)} ₽',
                style: AppTextStyles.caption.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(GameProvider game, NumberFormat formatter) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GlowingCard(
            glowColor: AppColors.secondary,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Баланс', style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  '${formatter.format(game.balance)} ₽',
                  style: AppTextStyles.h2.copyWith(fontSize: 22),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: GlowingCard(
            glowColor: AppColors.error,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Потрачено', style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  '${formatter.format(game.totalSpent)} ₽',
                  style: AppTextStyles.h3.copyWith(color: AppColors.error, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditMini(GameProvider game) {
    final credit = game.creditScoreData;
    Color color;
    if (credit.score >= 750) {
      color = AppColors.success;
    } else if (credit.score >= 670) {
      color = AppColors.secondary;
    } else if (credit.score >= 580) {
      color = AppColors.accent;
    } else {
      color = AppColors.error;
    }

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(credit.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Кредитный рейтинг', style: AppTextStyles.caption),
              Text(credit.rating, style: AppTextStyles.captionBold.copyWith(color: color)),
            ],
          ),
          const Spacer(),
          Text(
            '${credit.score}',
            style: AppTextStyles.h2.copyWith(color: color, fontSize: 24),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ((credit.score - 300) / 550).clamp(0.0, 1.0),
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, GameProvider game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Действия', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionBtn(
              icon: Icons.credit_card,
              color: AppColors.primary,
              label: 'Расход',
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddExpenseSheet(),
              ),
            ),
            const SizedBox(width: 10),
            _buildActionBtn(
              icon: Icons.savings,
              color: AppColors.accent,
              label: 'Копилка',
              subtitle: '+1,000 ₽',
              onTap: () {
                if (game.balance >= 1000) {
                  game.addToSavings(1000);
                }
              },
            ),
            const SizedBox(width: 10),
            _buildActionBtn(
              icon: Icons.trending_up,
              color: AppColors.success,
              label: 'Цели',
              subtitle: '+1,000 ₽',
              onTap: () {
                if (game.goals.isNotEmpty && game.balance >= 1000) {
                  game.contributeToGoal(game.goals.first.id, 1000);
                }
              },
            ),
            const SizedBox(width: 10),
            _buildActionBtn(
              icon: Icons.casino,
              color: AppColors.error,
              label: 'Событие',
              onTap: () {
                final event = game.getRandomEvent();
                if (event != null) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => EventDialog(event: event),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Сегодня без событий 😌'),
                    backgroundColor: AppColors.surface,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required Color color,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Text(label, style: AppTextStyles.captionBold.copyWith(fontSize: 11)),
              if (subtitle != null)
                Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 9, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioMini(GameProvider game, NumberFormat formatter) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Text('📈', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Портфель', style: AppTextStyles.captionBold),
              Text('${game.portfolio.length} акций', style: AppTextStyles.caption),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${formatter.format(game.portfolioValue)} ₽',
                style: AppTextStyles.captionBold.copyWith(fontSize: 14),
              ),
              Text(
                '${game.portfolioProfit >= 0 ? '+' : ''}${formatter.format(game.portfolioProfit)} ₽',
                style: AppTextStyles.caption.copyWith(
                  color: game.portfolioProfit >= 0 ? AppColors.success : AppColors.error,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _advanceDay(BuildContext context, GameProvider game) {
    bool continued = game.advanceDay();

    if (!continued) {
      // Month ended — show boss!
      final boss = game.currentBossChallenge;
      if (boss != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => BossDialog(boss: boss),
        );
      } else {
        game.endMonth();
      }
      return;
    }

    // Random event on certain days
    if (game.currentDay % 4 == 0) {
      final event = game.getRandomEvent();
      if (event != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => EventDialog(event: event),
            );
          }
        });
      }
    }
  }
}
