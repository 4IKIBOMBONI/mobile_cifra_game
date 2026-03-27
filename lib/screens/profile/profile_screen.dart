import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final formatter = NumberFormat('#,###', 'ru_RU');
        final score = game.healthScore;

        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Avatar and info
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 44),
                  ).animate().scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
                  const SizedBox(height: 16),

                  Text(game.user.name, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(
                    'Уровень ${game.user.level} · ${formatter.format(game.balance)} ₽',
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: 24),

                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '🔥',
                          '${game.streak}',
                          'Дней подряд',
                          AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '⭐',
                          '${game.points}',
                          'Баллов',
                          AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '🏆',
                          '${game.unlockedAchievements.length}',
                          'Достижений',
                          AppColors.secondary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 16),

                  // Financial health
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Финансовое здоровье',
                            style: AppTextStyles.h3),
                        const SizedBox(height: 16),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 60,
                            lineWidth: 10,
                            percent: (score.score / 100).clamp(0.0, 1.0),
                            center: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  score.grade,
                                  style: AppTextStyles.h1.copyWith(
                                    color: _gradeColor(score.grade),
                                  ),
                                ),
                                Text(
                                  '${score.score}/100',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                            progressColor: _gradeColor(score.grade),
                            backgroundColor: AppColors.surface,
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            animationDuration: 1000,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (score.tips.isNotEmpty) ...[
                          Text('Рекомендации:',
                              style: AppTextStyles.captionBold),
                          const SizedBox(height: 8),
                          ...score.tips.map((tip) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('💡',
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        tip,
                                        style: AppTextStyles.caption
                                            .copyWith(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 16),

                  // Monthly summary
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('📊',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text('Итоги месяца',
                                style: AppTextStyles.h3),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                            'Доход', formatter.format(game.salary),
                            AppColors.success),
                        _buildSummaryRow(
                            'Расходы', formatter.format(game.totalSpent),
                            AppColors.error),
                        _buildSummaryRow(
                            'Накопления',
                            formatter.format(game.savingsTotal),
                            AppColors.secondary),
                        const Divider(color: AppColors.textMuted),
                        _buildSummaryRow(
                            'Баланс', formatter.format(game.balance),
                            AppColors.accent),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: 16),

                  // Settings section
                  GlassCard(
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          Icons.person_outline,
                          'Изменить имя',
                          () => _showNameDialog(context, game),
                        ),
                        const Divider(
                            color: AppColors.textMuted, height: 20),
                        _buildSettingsItem(
                          Icons.refresh,
                          'Начать заново',
                          () => _showResetDialog(context),
                        ),
                        const Divider(
                            color: AppColors.textMuted, height: 20),
                        _buildSettingsItem(
                          Icons.info_outline,
                          'О приложении',
                          () => _showAboutDialog(context),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String emoji, String value, String label, Color color) {
    return GlowingCard(
      glowColor: color,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.h3.copyWith(color: color)),
          Text(label,
              style: AppTextStyles.caption.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text(
            '$value ₽',
            style: AppTextStyles.captionBold.copyWith(
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTextStyles.body),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: AppColors.textMuted, size: 14),
        ],
      ),
    );
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A':
        return AppColors.success;
      case 'B':
        return AppColors.secondary;
      case 'C':
        return AppColors.accent;
      case 'D':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  void _showNameDialog(BuildContext context, game) {
    final controller = TextEditingController(text: game.user.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Изменить имя', style: AppTextStyles.h3),
        content: TextField(
          controller: controller,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                game.setUserName(controller.text);
              }
              Navigator.pop(ctx);
            },
            child: Text('Сохранить',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Начать заново?', style: AppTextStyles.h3),
        content: Text(
          'Весь прогресс будет сброшен. Это действие нельзя отменить.',
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Сбросить',
                style:
                    AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('О приложении', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.account_balance_wallet,
                  color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'FinSim — Финансовая\nграмотность в кармане',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Версия 1.0.0',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 8),
            Text(
              'Симулятор жизни и бюджета для обучения основам финансовой грамотности.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Закрыть',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }
}
