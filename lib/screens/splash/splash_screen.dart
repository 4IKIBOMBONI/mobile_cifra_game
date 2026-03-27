import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    for (int i = 0; i <= 100; i += 2) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (mounted) {
        setState(() => _loadingProgress = i / 100);
      }
    }
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Wallet icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 32),

                // Title
                Text(
                  'ФИНАНСОВАЯ\nГРАМОТНОСТЬ\nВ КАРМАНЕ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28,
                    height: 1.2,
                    letterSpacing: 1.5,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),

                const SizedBox(height: 12),

                Text(
                  'Симулятор жизни и бюджета',
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 14,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 400.ms),

                const Spacer(flex: 2),

                // Floating elements
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFloatingIcon('🐷', -20, 300),
                    const SizedBox(width: 20),
                    _buildFloatingIcon('💰', 10, 500),
                    const SizedBox(width: 20),
                    _buildFloatingIcon('📊', -15, 700),
                  ],
                ),

                const Spacer(),

                // Loading bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _loadingProgress,
                          backgroundColor: AppColors.surface,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.secondary,
                          ),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Загрузка...',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 400.ms),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingIcon(String emoji, double offsetY, int delayMs) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 36),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .moveY(
          begin: offsetY,
          end: -offsetY,
          duration: 2000.ms,
          delay: Duration(milliseconds: delayMs),
          curve: Curves.easeInOut,
        );
  }
}
