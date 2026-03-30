import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/screens/home/game_screen.dart';
import 'package:cifra_game/screens/budget/budget_screen.dart';
import 'package:cifra_game/screens/education/education_screen.dart';
import 'package:cifra_game/screens/investments/investments_screen.dart';
import 'package:cifra_game/screens/shop/shop_screen.dart';
import 'package:cifra_game/screens/progress_map/progress_map_screen.dart';
import 'package:cifra_game/screens/profile/profile_screen.dart';
import 'package:cifra_game/screens/home/game_over_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    GameScreen(),
    BudgetScreen(),
    InvestmentsScreen(),
    EducationScreen(),
    ShopScreen(),
    ProgressMapScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGameOver = context.watch<GameProvider>().isGameOver;

    if (isGameOver) {
      return const GameOverScreen();
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  _buildNavItem(0, Icons.videogame_asset_outlined, Icons.videogame_asset, 'Игра'),
                  _buildNavItem(1, Icons.pie_chart_outline, Icons.pie_chart, 'Бюджет'),
                  _buildNavItem(2, Icons.candlestick_chart_outlined, Icons.candlestick_chart, 'Биржа'),
                  _buildNavItem(3, Icons.school_outlined, Icons.school, 'Уроки'),
                  _buildNavItem(4, Icons.shopping_bag_outlined, Icons.shopping_bag, 'Магазин'),
                  _buildNavItem(5, Icons.map_outlined, Icons.map, 'Карта'),
                  _buildNavItem(6, Icons.person_outline, Icons.person, 'Профиль'),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
