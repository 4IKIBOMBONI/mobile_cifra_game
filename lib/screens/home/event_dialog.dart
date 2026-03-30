import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class EventDialog extends StatefulWidget {
  final LifeEvent event;

  const EventDialog({super.key, required this.event});

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  String? _feedbackText;
  bool _resolved = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    final isPositive = widget.event.amount > 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPositive
                ? AppColors.success.withOpacity(0.3)
                : widget.event.type == LifeEventType.choice
                    ? AppColors.accent.withOpacity(0.3)
                    : AppColors.error.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isPositive ? AppColors.success : AppColors.error)
                  .withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.success : AppColors.error)
                      .withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.event.icon,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 16),

              Text(
                widget.event.title,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 8),

              Text(
                widget.event.description,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 20),

              if (_feedbackText != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _feedbackText!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
              ],

              // Actions
              if (widget.event.type == LifeEventType.choice && !_resolved) ...[
                ...widget.event.choices!.map((choice) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          text: choice.text,
                          colors: choice.amount < 0
                              ? [AppColors.error, AppColors.error.withOpacity(0.8)]
                              : [AppColors.success, AppColors.secondary],
                          onPressed: () {
                            final game = context.read<GameProvider>();
                            game.applyEventResult(choice.amount);
                            setState(() {
                              _feedbackText = choice.feedback;
                              _resolved = true;
                            });
                          },
                        ),
                      ),
                    )),
              ] else if (!_resolved) ...[
                if (widget.event.amount != 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: (isPositive ? AppColors.success : AppColors.error)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}${formatter.format(widget.event.amount)} ₽',
                      style: AppTextStyles.h2.copyWith(
                        color: isPositive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: 'Понятно',
                    onPressed: () {
                      final game = context.read<GameProvider>();
                      game.applyEventResult(widget.event.amount);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],

              if (_resolved)
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: 'Продолжить',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
