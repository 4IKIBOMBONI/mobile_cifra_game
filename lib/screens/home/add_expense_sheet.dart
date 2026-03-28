import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  String? _selectedCategory;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text('Добавить расход', style: AppTextStyles.h2),
            const SizedBox(height: 20),

            // Category selector
            Text('Категория', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: game.categories
                  .where((c) => c.type != BudgetCategoryType.savings)
                  .map((cat) => GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedCategory == cat.id
                                ? cat.color.withOpacity(0.2)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedCategory == cat.id
                                  ? cat.color
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(cat.icon,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(cat.name,
                                  style: AppTextStyles.caption
                                      .copyWith(fontSize: 13)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Amount
            Text('Сумма (₽)', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.h3,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle:
                    AppTextStyles.h3.copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.currency_ruble,
                    color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text('Описание', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'На что потрачено?',
                hintStyle: AppTextStyles.body
                    .copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Добавить расход',
                icon: Icons.add,
                onPressed: () {
                  final amount =
                      double.tryParse(_amountController.text) ?? 0;
                  if (_selectedCategory != null && amount > 0) {
                    game.addExpense(
                      _selectedCategory!,
                      amount,
                      _descriptionController.text.isEmpty
                          ? 'Расход'
                          : _descriptionController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Расход ${amount.toInt()} ₽ добавлен'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
