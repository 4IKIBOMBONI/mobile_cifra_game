import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/screens/home/main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.school,
      emoji: '🎓',
      title: 'Добро пожаловать!',
      description:
          'Изучите основы финансовой грамотности в увлекательном симуляторе.',
      gradient: [AppColors.primary, AppColors.primaryLight],
    ),
    _OnboardingPage(
      icon: Icons.pie_chart,
      emoji: '📊',
      title: 'Управляйте бюджетом',
      description:
          'Планируйте расходы, копите на мечты и контролируйте финансы.',
      gradient: [AppColors.secondary, const Color(0xFF00E5C3)],
    ),
    _OnboardingPage(
      icon: Icons.rocket_launch,
      emoji: '🚀',
      title: 'Инвестируйте и растите',
      description:
          'Изучайте инвестиции, пробуйте стратегии и достигайте финансовой свободы.',
      gradient: [AppColors.accent, const Color(0xFFFFAA00)],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMain();
    }
  }

  void _navigateToMain() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _navigateToMain,
                  child: Text(
                    'Пропустить',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon container
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: page.gradient,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: page.gradient[0].withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  page.emoji,
                                  style: const TextStyle(fontSize: 50),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  page.icon,
                                  size: 36,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.0, 1.0),
                                duration: 500.ms,
                                curve: Curves.elasticOut,
                              )
                              .fadeIn(duration: 300.ms),

                          const SizedBox(height: 48),

                          Text(
                            page.title,
                            style: AppTextStyles.h1,
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),

                          const SizedBox(height: 16),

                          Text(
                            page.description,
                            style: AppTextStyles.bodySecondary,
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 400.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots indicator
              SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.surface,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),

              const SizedBox(height: 32),

              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: AppDecorations.primaryButton,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'НАЧАТЬ!'
                            : 'Продолжить',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String emoji;
  final String title;
  final String description;
  final List<Color> gradient;

  const _OnboardingPage({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
