import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_models.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final formatter = NumberFormat('#,###', 'ru_RU');

        return Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
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
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.candlestick_chart, color: AppColors.success, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text('Биржа', style: AppTextStyles.h2.copyWith(fontSize: 20)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${formatter.format(game.balance)} ₽',
                          style: AppTextStyles.captionBold.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Portfolio summary
                  GlassCard(
                    borderColor: AppColors.secondary.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Мой портфель', style: AppTextStyles.h3),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Стоимость', style: AppTextStyles.caption),
                                Text(
                                  '${formatter.format(game.portfolioValue)} ₽',
                                  style: AppTextStyles.h2.copyWith(fontSize: 22),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: (game.portfolioProfit >= 0 ? AppColors.success : AppColors.error)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${game.portfolioProfit >= 0 ? '+' : ''}${formatter.format(game.portfolioProfit)} ₽',
                                style: AppTextStyles.captionBold.copyWith(
                                  color: game.portfolioProfit >= 0 ? AppColors.success : AppColors.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (game.portfolio.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.textMuted),
                          const SizedBox(height: 8),
                          ...game.portfolio.map((p) {
                            final stock = game.stocks.firstWhere((s) => s.id == p.stockId);
                            final profit = (stock.currentPrice - p.avgBuyPrice) * p.shares;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Text(stock.icon, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(stock.ticker, style: AppTextStyles.captionBold),
                                  const SizedBox(width: 8),
                                  Text('${p.shares} шт.', style: AppTextStyles.caption),
                                  const Spacer(),
                                  Text(
                                    '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} ₽',
                                    style: AppTextStyles.captionBold.copyWith(
                                      color: profit >= 0 ? AppColors.success : AppColors.error,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _showSellDialog(context, game, stock, p.shares),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('Продать', style: AppTextStyles.caption.copyWith(
                                        color: AppColors.error, fontSize: 11,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  Text('Акции', style: AppTextStyles.h3),
                  const SizedBox(height: 12),

                  // Stock list
                  ...game.stocks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stock = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildStockCard(context, stock, game, formatter),
                    ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 + index * 80),
                      duration: 400.ms,
                    );
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

  Widget _buildStockCard(BuildContext context, Stock stock, GameProvider game, NumberFormat formatter) {
    return GlowingCard(
      glowColor: stock.isUp ? AppColors.success : AppColors.error,
      onTap: () => _showBuyDialog(context, game, stock),
      child: Column(
        children: [
          Row(
            children: [
              Text(stock.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.name, style: AppTextStyles.captionBold.copyWith(fontSize: 15)),
                    Text(stock.ticker, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${formatter.format(stock.currentPrice)} ₽',
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        stock.isUp ? Icons.trending_up : Icons.trending_down,
                        color: stock.isUp ? AppColors.success : AppColors.error,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${stock.changePercent >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(1)}%',
                        style: AppTextStyles.captionBold.copyWith(
                          color: stock.isUp ? AppColors.success : AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mini chart
          SizedBox(
            height: 50,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: stock.priceHistory.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: stock.isUp ? AppColors.success : AppColors.error,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: (stock.isUp ? AppColors.success : AppColors.error).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildVolatilityBadge(stock.volatility),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Купить', style: AppTextStyles.captionBold.copyWith(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolatilityBadge(StockVolatility volatility) {
    String text;
    Color color;
    switch (volatility) {
      case StockVolatility.low:
        text = 'Низкий риск';
        color = AppColors.success;
        break;
      case StockVolatility.medium:
        text = 'Средний риск';
        color = AppColors.accent;
        break;
      case StockVolatility.high:
        text = 'Высокий риск';
        color = AppColors.error;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: AppTextStyles.caption.copyWith(color: color, fontSize: 11)),
    );
  }

  void _showBuyDialog(BuildContext context, GameProvider game, Stock stock) {
    int shares = 1;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          double cost = stock.currentPrice * shares;
          bool canAfford = cost <= game.balance;
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Text(stock.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text('Купить ${stock.ticker}', style: AppTextStyles.h3),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Цена: ${stock.currentPrice.toStringAsFixed(1)} ₽/шт', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: shares > 1 ? () => setState(() => shares--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.error,
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$shares',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: (cost + stock.currentPrice) <= game.balance
                          ? () => setState(() => shares++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Итого: ${cost.toStringAsFixed(0)} ₽',
                  style: AppTextStyles.h3.copyWith(
                    color: canAfford ? AppColors.secondary : AppColors.error,
                  ),
                ),
                if (!canAfford)
                  Text('Недостаточно средств', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Отмена', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ),
              GradientButton(
                text: 'Купить',
                onPressed: canAfford
                    ? () {
                        game.buyStock(stock.id, shares);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('📈 Куплено $shares акций ${stock.ticker}!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ));
                      }
                    : () {},
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSellDialog(BuildContext context, GameProvider game, Stock stock, int maxShares) {
    int shares = 1;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          double revenue = stock.currentPrice * shares;
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Продать ${stock.ticker}', style: AppTextStyles.h3),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('У вас: $maxShares шт.', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: shares > 1 ? () => setState(() => shares--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.error,
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                      child: Text('$shares', style: AppTextStyles.h2, textAlign: TextAlign.center),
                    ),
                    IconButton(
                      onPressed: shares < maxShares ? () => setState(() => shares++) : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Получите: ${revenue.toStringAsFixed(0)} ₽', style: AppTextStyles.h3.copyWith(color: AppColors.accent)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Отмена', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ),
              GradientButton(
                text: 'Продать',
                colors: [AppColors.error, AppColors.error.withOpacity(0.7)],
                onPressed: () {
                  game.sellStock(stock.id, shares);
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
