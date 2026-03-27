import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/widgets/glass_card.dart';
import 'package:cifra_game/screens/education/lesson_screen.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final completedCount = game.completedLessonsCount;
        final totalCount = game.lessons.length;

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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.school,
                            color: AppColors.accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text('Финансовая академия',
                          style: AppTextStyles.h2.copyWith(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Progress overview
                  GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ваш прогресс',
                                  style: AppTextStyles.h3),
                              const SizedBox(height: 4),
                              Text(
                                '$completedCount из $totalCount уроков пройдено',
                                style: AppTextStyles.bodySecondary,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accent,
                                AppColors.accent.withOpacity(0.6),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${totalCount > 0 ? (completedCount / totalCount * 100).round() : 0}%',
                              style: AppTextStyles.captionBold
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Difficulty sections
                  _buildDifficultySection(
                    context,
                    title: 'Начальный уровень',
                    emoji: '🌱',
                    lessons: game.lessons
                        .where((l) =>
                            l.difficulty == LessonDifficulty.beginner)
                        .toList(),
                    color: AppColors.success,
                    delay: 100,
                  ),
                  const SizedBox(height: 16),

                  _buildDifficultySection(
                    context,
                    title: 'Средний уровень',
                    emoji: '📈',
                    lessons: game.lessons
                        .where((l) =>
                            l.difficulty == LessonDifficulty.intermediate)
                        .toList(),
                    color: AppColors.accent,
                    delay: 200,
                  ),
                  const SizedBox(height: 16),

                  _buildDifficultySection(
                    context,
                    title: 'Продвинутый',
                    emoji: '🚀',
                    lessons: game.lessons
                        .where((l) =>
                            l.difficulty == LessonDifficulty.advanced)
                        .toList(),
                    color: AppColors.error,
                    delay: 300,
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

  Widget _buildDifficultySection(
    BuildContext context, {
    required String title,
    required String emoji,
    required List<EducationLesson> lessons,
    required Color color,
    required int delay,
  }) {
    if (lessons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(title, style: AppTextStyles.h3),
          ],
        ),
        const SizedBox(height: 12),
        ...lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildLessonCard(context, lesson, color),
          ).animate().fadeIn(
              delay: Duration(milliseconds: delay + index * 80),
              duration: 300.ms);
        }),
      ],
    );
  }

  Widget _buildLessonCard(
      BuildContext context, EducationLesson lesson, Color accentColor) {
    return GlowingCard(
      glowColor: lesson.completed ? AppColors.success : accentColor,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LessonScreen(lesson: lesson),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (lesson.completed ? AppColors.success : accentColor)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: lesson.completed
                  ? const Icon(Icons.check_circle,
                      color: AppColors.success, size: 28)
                  : Text(lesson.icon,
                      style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.description,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      '+${lesson.rewardPoints}',
                      style: AppTextStyles.captionBold.copyWith(
                        color: AppColors.accent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
