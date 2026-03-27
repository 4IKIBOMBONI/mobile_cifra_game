import 'package:flutter/foundation.dart';

class UserProfile {
  final String name;
  final String avatarUrl;
  final int level;
  final int experience;
  final int experienceToNext;

  const UserProfile({
    required this.name,
    this.avatarUrl = '',
    this.level = 1,
    this.experience = 0,
    this.experienceToNext = 1000,
  });

  UserProfile copyWith({
    String? name,
    String? avatarUrl,
    int? level,
    int? experience,
    int? experienceToNext,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      experienceToNext: experienceToNext ?? this.experienceToNext,
    );
  }
}

class BudgetCategory {
  final String id;
  final String name;
  final String icon;
  final double allocated;
  final double spent;
  final int colorValue;
  final BudgetCategoryType type;

  const BudgetCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.allocated,
    this.spent = 0,
    required this.colorValue,
    required this.type,
  });

  double get remaining => allocated - spent;
  double get percentage => allocated > 0 ? (spent / allocated * 100) : 0;
  Color get color => Color(colorValue);

  BudgetCategory copyWith({
    double? allocated,
    double? spent,
  }) {
    return BudgetCategory(
      id: id,
      name: name,
      icon: icon,
      allocated: allocated ?? this.allocated,
      spent: spent ?? this.spent,
      colorValue: colorValue,
      type: type,
    );
  }
}

enum BudgetCategoryType { mandatory, variable, savings }

class Transaction {
  final String id;
  final String categoryId;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;

  const Transaction({
    required this.id,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}

enum TransactionType { expense, income, savings }

class FinancialGoal {
  final String id;
  final String name;
  final String icon;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;

  const FinancialGoal({
    required this.id,
    required this.name,
    required this.icon,
    required this.targetAmount,
    this.currentAmount = 0,
    this.deadline,
  });

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount) : 0;

  FinancialGoal copyWith({double? currentAmount}) {
    return FinancialGoal(
      id: id,
      name: name,
      icon: icon,
      targetAmount: targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int points;
  final bool unlocked;
  final AchievementRarity rarity;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    this.unlocked = false,
    required this.rarity,
  });

  Achievement copyWith({bool? unlocked}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      points: points,
      unlocked: unlocked ?? this.unlocked,
      rarity: rarity,
    );
  }
}

enum AchievementRarity { common, rare, epic, legendary }

class MerchItem {
  final String id;
  final String name;
  final String description;
  final String imageAsset;
  final int price;
  final MerchCategory category;
  final bool purchased;

  const MerchItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
    required this.category,
    this.purchased = false,
  });
}

enum MerchCategory { clothing, accessories, souvenirs }

class LifeEvent {
  final String id;
  final String title;
  final String description;
  final String icon;
  final double amount;
  final LifeEventType type;
  final List<EventChoice>? choices;

  const LifeEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.amount,
    required this.type,
    this.choices,
  });
}

enum LifeEventType { expense, income, choice }

class EventChoice {
  final String text;
  final double amount;
  final int pointsReward;
  final String feedback;

  const EventChoice({
    required this.text,
    required this.amount,
    required this.pointsReward,
    required this.feedback,
  });
}

class EducationLesson {
  final String id;
  final String title;
  final String description;
  final String icon;
  final LessonDifficulty difficulty;
  final List<LessonContent> contents;
  final List<QuizQuestion> quiz;
  final int rewardPoints;
  final bool completed;

  const EducationLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.difficulty,
    required this.contents,
    required this.quiz,
    required this.rewardPoints,
    this.completed = false,
  });
}

enum LessonDifficulty { beginner, intermediate, advanced }

class LessonContent {
  final String title;
  final String body;
  final String? imageAsset;

  const LessonContent({
    required this.title,
    required this.body,
    this.imageAsset,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class FinancialHealthScore {
  final int score; // 0-100
  final String grade; // A-F
  final List<String> tips;

  const FinancialHealthScore({
    required this.score,
    required this.grade,
    required this.tips,
  });

  static FinancialHealthScore calculate({
    required double savingsRate,
    required double budgetAdherence,
    required int lessonsCompleted,
    required int daysWithoutOverspending,
  }) {
    double raw = 0;
    raw += savingsRate.clamp(0, 30) / 30 * 25;
    raw += budgetAdherence.clamp(0, 100) / 100 * 35;
    raw += (lessonsCompleted.clamp(0, 10) / 10) * 20;
    raw += (daysWithoutOverspending.clamp(0, 30) / 30) * 20;

    int score = raw.round();
    String grade;
    if (score >= 90) {
      grade = 'A';
    } else if (score >= 80) {
      grade = 'B';
    } else if (score >= 70) {
      grade = 'C';
    } else if (score >= 60) {
      grade = 'D';
    } else {
      grade = 'F';
    }

    List<String> tips = [];
    if (savingsRate < 20) tips.add('Старайтесь откладывать не менее 20% дохода');
    if (budgetAdherence < 80) tips.add('Следите за бюджетом — не превышайте лимиты');
    if (lessonsCompleted < 5) tips.add('Пройдите больше уроков для повышения грамотности');
    if (daysWithoutOverspending < 15) tips.add('Контролируйте ежедневные расходы');

    return FinancialHealthScore(score: score, grade: grade, tips: tips);
  }
}

class MonthSummary {
  final int month;
  final double totalIncome;
  final double totalExpenses;
  final double totalSaved;
  final String grade;
  final int pointsEarned;
  final List<String> highlights;

  const MonthSummary({
    required this.month,
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalSaved,
    required this.grade,
    required this.pointsEarned,
    required this.highlights,
  });
}
