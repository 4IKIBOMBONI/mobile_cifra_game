import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:intl/intl.dart';

class BudgetDonutChart extends StatelessWidget {
  final List<BudgetCategory> categories;
  final double totalExpenses;
  final double size;
  final bool showLabels;

  const BudgetDonutChart({
    super.key,
    required this.categories,
    required this.totalExpenses,
    this.size = 220,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return SizedBox(
      height: size + (showLabels ? 60 : 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: size * 0.3,
                sections: categories.map((cat) {
                  final percentage = totalExpenses > 0
                      ? (cat.allocated / totalExpenses * 100)
                      : 0.0;
                  return PieChartSectionData(
                    color: cat.color,
                    value: cat.allocated,
                    title: '',
                    radius: size * 0.2,
                    badgeWidget: showLabels && percentage > 5
                        ? _buildBadge(cat, percentage, formatter)
                        : null,
                    badgePositionPercentageOffset: 1.8,
                  );
                }).toList(),
              ),
            ),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Всего расходов:',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                '${formatter.format(totalExpenses)} ₽',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
      BudgetCategory cat, double percentage, NumberFormat formatter) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          cat.name,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        Text(
          '${formatter.format(cat.allocated)} ₽',
          style: AppTextStyles.captionBold.copyWith(
            color: cat.color,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BudgetDistributionChart extends StatelessWidget {
  final double mandatory;
  final double variable;
  final double savings;
  final double total;

  const BudgetDistributionChart({
    super.key,
    required this.mandatory,
    required this.variable,
    required this.savings,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 55,
              sections: [
                PieChartSectionData(
                  color: AppColors.error,
                  value: mandatory,
                  title: '${(mandatory / total * 100).round()}%',
                  titleStyle: AppTextStyles.captionBold,
                  radius: 35,
                ),
                PieChartSectionData(
                  color: AppColors.accent,
                  value: variable,
                  title: '${(variable / total * 100).round()}%',
                  titleStyle: AppTextStyles.captionBold,
                  radius: 35,
                ),
                PieChartSectionData(
                  color: AppColors.secondary,
                  value: savings,
                  title: '${(savings / total * 100).round()}%',
                  titleStyle: AppTextStyles.captionBold,
                  radius: 35,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₽${formatter.format(total)}',
                style: AppTextStyles.h2.copyWith(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
