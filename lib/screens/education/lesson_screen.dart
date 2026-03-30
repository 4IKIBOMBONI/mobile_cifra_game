import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cifra_game/theme/app_theme.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/providers/game_provider.dart';
import 'package:cifra_game/widgets/glass_card.dart';

class LessonScreen extends StatefulWidget {
  final EducationLesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentPage = 0;
  bool _inQuiz = false;
  int _currentQuizQuestion = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _quizCompleted = false;

  int get _totalPages =>
      widget.lesson.contents.length + widget.lesson.quiz.length + 1;

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
              // App bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        widget.lesson.title,
                        style: AppTextStyles.h3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Progress dots
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: List.generate(
                    _totalPages,
                    (i) => Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i <= _currentPage
                              ? AppColors.secondary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Content
              Expanded(
                child: _quizCompleted
                    ? _buildQuizResult()
                    : _inQuiz
                        ? _buildQuizPage()
                        : _buildContentPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentPage() {
    if (_currentPage >= widget.lesson.contents.length) {
      return const SizedBox.shrink();
    }

    final content = widget.lesson.contents[_currentPage];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(widget.lesson.icon,
                          style: const TextStyle(fontSize: 28)),
                    ),
                  ).animate().scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 400.ms,
                      ),
                  const SizedBox(height: 20),

                  Text(
                    content.title,
                    style: AppTextStyles.h2,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 16),

                  Text(
                    content.body,
                    style: AppTextStyles.body.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
          ),

          // Next button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: _currentPage < widget.lesson.contents.length - 1
                    ? 'Далее'
                    : 'Перейти к викторине',
                icon: _currentPage < widget.lesson.contents.length - 1
                    ? Icons.arrow_forward
                    : Icons.quiz,
                onPressed: () {
                  setState(() {
                    if (_currentPage < widget.lesson.contents.length - 1) {
                      _currentPage++;
                    } else {
                      _inQuiz = true;
                      _currentPage = widget.lesson.contents.length;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPage() {
    if (_currentQuizQuestion >= widget.lesson.quiz.length) {
      return const SizedBox.shrink();
    }

    final question = widget.lesson.quiz[_currentQuizQuestion];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Вопрос ${_currentQuizQuestion + 1} из ${widget.lesson.quiz.length}',
              style: AppTextStyles.captionBold.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            question.question,
            style: AppTextStyles.h3.copyWith(fontSize: 20),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isCorrect = index == question.correctIndex;
                  final isSelected = index == _selectedAnswer;

                  Color borderColor = Colors.white.withOpacity(0.1);
                  Color bgColor = AppColors.surface;

                  if (_answered) {
                    if (isCorrect) {
                      borderColor = AppColors.success;
                      bgColor = AppColors.success.withOpacity(0.1);
                    } else if (isSelected && !isCorrect) {
                      borderColor = AppColors.error;
                      bgColor = AppColors.error.withOpacity(0.1);
                    }
                  } else if (isSelected) {
                    borderColor = AppColors.primary;
                    bgColor = AppColors.primary.withOpacity(0.1);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _answered
                          ? null
                          : () {
                              setState(() {
                                _selectedAnswer = index;
                              });
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? borderColor.withOpacity(0.2)
                                    : AppColors.surface,
                                border: Border.all(
                                  color: borderColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: _answered && isCorrect
                                    ? const Icon(Icons.check,
                                        color: AppColors.success, size: 18)
                                    : _answered &&
                                            isSelected &&
                                            !isCorrect
                                        ? const Icon(Icons.close,
                                            color: AppColors.error, size: 18)
                                        : Text(
                                            String.fromCharCode(
                                                65 + index),
                                            style: AppTextStyles.captionBold,
                                          ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Explanation
          if (_answered) ...[
            GlassCard(
              borderColor: AppColors.accent.withOpacity(0.3),
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question.explanation,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 12),
          ],

          // Action button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: _answered
                    ? (_currentQuizQuestion < widget.lesson.quiz.length - 1
                        ? 'Следующий вопрос'
                        : 'Завершить')
                    : 'Ответить',
                colors: _selectedAnswer == null && !_answered
                    ? [AppColors.textMuted, AppColors.textMuted]
                    : null,
                onPressed: _selectedAnswer == null && !_answered
                    ? () {}
                    : () {
                        if (!_answered) {
                          setState(() {
                            _answered = true;
                            if (_selectedAnswer ==
                                question.correctIndex) {
                              _correctAnswers++;
                              context
                                  .read<GameProvider>()
                                  .answerQuizCorrectly();
                            }
                          });
                        } else {
                          setState(() {
                            if (_currentQuizQuestion <
                                widget.lesson.quiz.length - 1) {
                              _currentQuizQuestion++;
                              _currentPage++;
                              _selectedAnswer = null;
                              _answered = false;
                            } else {
                              _quizCompleted = true;
                              _currentPage++;
                              context
                                  .read<GameProvider>()
                                  .completeLesson(widget.lesson.id);
                            }
                          });
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResult() {
    final total = widget.lesson.quiz.length;
    final percentage = total > 0 ? (_correctAnswers / total * 100).round() : 0;
    final isPassed = percentage >= 50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isPassed ? AppColors.success : AppColors.error)
                  .withOpacity(0.15),
            ),
            child: Center(
              child: Text(
                isPassed ? '🎉' : '📚',
                style: const TextStyle(fontSize: 48),
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 24),

          Text(
            isPassed ? 'Отлично!' : 'Попробуйте ещё!',
            style: AppTextStyles.h1,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),

          Text(
            'Правильных ответов: $_correctAnswers из $total',
            style: AppTextStyles.bodySecondary,
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 24),

          if (isPassed)
            GlassCard(
              borderColor: AppColors.success.withOpacity(0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    '+${widget.lesson.rewardPoints} баллов!',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: 'Вернуться к урокам',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
