import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final items = _filteredItems(game.merchItems);

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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.shopping_bag,
                            color: AppColors.primaryLight, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text('Магазин\nмерча',
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 22,
                            height: 1.1,
                          )),
                      const Spacer(),
                      // Points badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.accent.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent,
                              ),
                              child: const Center(
                                child: Text('\$',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${NumberFormat('#,###', 'ru_RU').format(game.points)}',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.accent,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('баллов', style: AppTextStyles.caption),
                  const SizedBox(height: 16),

                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'Все товары'),
                        const SizedBox(width: 8),
                        _buildFilterChip('clothing', 'Одежда'),
                        const SizedBox(width: 8),
                        _buildFilterChip('accessories', 'Аксессуары'),
                        const SizedBox(width: 8),
                        _buildFilterChip('souvenirs', 'Сувениры'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildMerchCard(context, items[index], game)
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: index * 100),
                            duration: 400.ms,
                          )
                          .slideY(begin: 0.1, end: 0);
                    },
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

  List<MerchItem> _filteredItems(List<MerchItem> items) {
    if (_selectedFilter == 'all') return items;
    return items.where((item) {
      switch (_selectedFilter) {
        case 'clothing':
          return item.category == MerchCategory.clothing;
        case 'accessories':
          return item.category == MerchCategory.accessories;
        case 'souvenirs':
          return item.category == MerchCategory.souvenirs;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.captionBold.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildMerchCard(
      BuildContext context, MerchItem item, GameProvider game) {
    final canAfford = game.points >= item.price;

    return GlowingCard(
      glowColor: item.purchased
          ? AppColors.success
          : canAfford
              ? AppColors.secondary
              : AppColors.textMuted,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                gradient: AppColors.cardGradient,
              ),
              child: Center(
                child: _getMerchIcon(item),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            item.name,
            style: AppTextStyles.captionBold.copyWith(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                child: const Center(
                  child: Text('\$',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${item.price} pts',
                style: AppTextStyles.captionBold.copyWith(
                  color: AppColors.accent,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 36,
            child: item.purchased
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Куплено ✓',
                        style: AppTextStyles.captionBold.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: canAfford
                          ? const LinearGradient(
                              colors: [AppColors.secondary, AppColors.primary],
                            )
                          : null,
                      color: canAfford ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: canAfford
                            ? () => _purchaseItem(context, item, game)
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: Text(
                            'Обменять',
                            style: AppTextStyles.captionBold.copyWith(
                              color: canAfford
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _getMerchIcon(MerchItem item) {
    IconData icon;
    switch (item.id) {
      case 'tshirt':
        icon = Icons.checkroom;
        break;
      case 'hoodie':
        icon = Icons.dry_cleaning;
        break;
      case 'cap':
        icon = Icons.sports_baseball;
        break;
      case 'stickers':
        icon = Icons.auto_awesome;
        break;
      case 'notebook':
        icon = Icons.menu_book;
        break;
      case 'powerbank':
        icon = Icons.battery_charging_full;
        break;
      default:
        icon = Icons.card_giftcard;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(height: 4),
        Text(
          'FINSIM',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.secondary.withOpacity(0.5),
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  void _purchaseItem(
      BuildContext context, MerchItem item, GameProvider game) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Обменять баллы?', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${item.name} за ${item.price} баллов',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'Останется: ${game.points - item.price} баллов',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          GradientButton(
            text: 'Обменять',
            onPressed: () {
              Navigator.pop(ctx);
              final success = game.purchaseMerch(item.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🎁 ${item.name} получен!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
