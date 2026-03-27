import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/services/game_data.dart';

class GameProvider extends ChangeNotifier {
  // User
  UserProfile _user = const UserProfile(name: 'Алексей');
  UserProfile get user => _user;

  // Game state
  int _currentDay = 15;
  int _currentMonth = 2; // February
  int _totalDaysInMonth = 30;
  double _salary = GameData.defaultSalary;
  double _balance = 45230;
  int _points = 2450;
  int _streak = 3;
  int _financialScore = 72;

  int get currentDay => _currentDay;
  int get currentMonth => _currentMonth;
  int get totalDaysInMonth => _totalDaysInMonth;
  int get daysRemaining => _totalDaysInMonth - _currentDay;
  double get monthProgress => _currentDay / _totalDaysInMonth;
  double get salary => _salary;
  double get balance => _balance;
  int get points => _points;
  int get streak => _streak;
  int get financialScore => _financialScore;

  String get monthName {
    const months = [
      '', 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[_currentMonth];
  }

  // Budget categories
  List<BudgetCategory> _categories = GameData.defaultCategories();
  List<BudgetCategory> get categories => _categories;

  List<BudgetCategory> get mandatoryCategories =>
      _categories.where((c) => c.type == BudgetCategoryType.mandatory).toList();

  List<BudgetCategory> get variableCategories =>
      _categories.where((c) => c.type == BudgetCategoryType.variable).toList();

  List<BudgetCategory> get savingsCategories =>
      _categories.where((c) => c.type == BudgetCategoryType.savings).toList();

  double get totalAllocated =>
      _categories.fold(0, (sum, c) => sum + c.allocated);

  double get totalSpent =>
      _categories.fold(0, (sum, c) => sum + c.spent);

  double get mandatoryTotal =>
      mandatoryCategories.fold(0, (sum, c) => sum + c.allocated);

  double get variableTotal =>
      variableCategories.fold(0, (sum, c) => sum + c.allocated);

  double get savingsTotal =>
      savingsCategories.fold(0, (sum, c) => sum + c.allocated);

  // Financial goals
  List<FinancialGoal> _goals = GameData.defaultGoals();
  List<FinancialGoal> get goals => _goals;

  // Achievements
  List<Achievement> _achievements = GameData.allAchievements();
  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.unlocked).toList();
  int get totalAchievementPoints =>
      unlockedAchievements.fold(0, (sum, a) => sum + a.points);

  // Merch
  List<MerchItem> _merchItems = GameData.allMerchItems();
  List<MerchItem> get merchItems => _merchItems;

  // Education
  List<EducationLesson> _lessons = GameData.allLessons();
  List<EducationLesson> get lessons => _lessons;
  int get completedLessonsCount => _lessons.where((l) => l.completed).length;

  // Transactions history
  final List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  // Life events
  List<LifeEvent> _availableEvents = GameData.randomEvents();

  // Financial health
  FinancialHealthScore get healthScore => FinancialHealthScore.calculate(
        savingsRate: savingsTotal / _salary * 100,
        budgetAdherence: totalSpent > 0
            ? ((totalAllocated - totalSpent).abs() / totalAllocated * 100)
                .clamp(0, 100)
            : 100,
        lessonsCompleted: completedLessonsCount,
        daysWithoutOverspending: _currentDay,
      );

  // ===== Actions =====

  void setUserName(String name) {
    _user = _user.copyWith(name: name);
    notifyListeners();
  }

  void addExpense(String categoryId, double amount, String description) {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index == -1) return;

    _categories[index] = _categories[index].copyWith(
      spent: _categories[index].spent + amount,
    );
    _balance -= amount;

    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: categoryId,
      description: description,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.expense,
    ));

    _addExperience(10);
    notifyListeners();
  }

  void addToSavings(double amount) {
    if (amount > _balance) return;
    _balance -= amount;

    final savingsIndex = _categories.indexWhere((c) => c.id == 'savings');
    if (savingsIndex != -1) {
      _categories[savingsIndex] = _categories[savingsIndex].copyWith(
        spent: _categories[savingsIndex].spent + amount,
      );
    }

    _addExperience(25);
    _addPoints(50);
    notifyListeners();
  }

  void contributeToGoal(String goalId, double amount) {
    if (amount > _balance) return;

    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index == -1) return;

    _goals[index] = _goals[index].copyWith(
      currentAmount: _goals[index].currentAmount + amount,
    );
    _balance -= amount;

    if (_goals[index].progress >= 1.0) {
      _unlockAchievement('goal_reached');
    }

    _addExperience(30);
    _addPoints(25);
    notifyListeners();
  }

  void updateCategoryAllocation(String categoryId, double newAmount) {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index == -1) return;

    _categories[index] = _categories[index].copyWith(allocated: newAmount);
    notifyListeners();
  }

  void advanceDay() {
    if (_currentDay >= _totalDaysInMonth) {
      _endMonth();
      return;
    }

    _currentDay++;
    _streak++;
    _addExperience(5);

    // Random event chance (20% per day)
    if (Random().nextDouble() < 0.20 && _availableEvents.isNotEmpty) {
      // Event will be triggered by UI
    }

    notifyListeners();
  }

  LifeEvent? getRandomEvent() {
    if (_availableEvents.isEmpty) return null;
    final event = _availableEvents[Random().nextInt(_availableEvents.length)];
    return event;
  }

  void applyEventResult(double amount) {
    _balance += amount;
    if (amount < 0) {
      _addExperience(20);
    } else {
      _addExperience(10);
    }
    _addPoints(25);
    notifyListeners();
  }

  void completeLesson(String lessonId) {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index == -1) return;

    final lesson = _lessons[index];
    _lessons[index] = EducationLesson(
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      icon: lesson.icon,
      difficulty: lesson.difficulty,
      contents: lesson.contents,
      quiz: lesson.quiz,
      rewardPoints: lesson.rewardPoints,
      completed: true,
    );

    _addPoints(lesson.rewardPoints);
    _addExperience(50);

    if (completedLessonsCount >= _lessons.length) {
      _unlockAchievement('financial_guru');
    }

    notifyListeners();
  }

  void answerQuizCorrectly() {
    _addPoints(25);
    _addExperience(15);
    notifyListeners();
  }

  bool purchaseMerch(String itemId) {
    final index = _merchItems.indexWhere((m) => m.id == itemId);
    if (index == -1) return false;

    if (_points < _merchItems[index].price) return false;

    _points -= _merchItems[index].price;
    _merchItems[index] = MerchItem(
      id: _merchItems[index].id,
      name: _merchItems[index].name,
      description: _merchItems[index].description,
      imageAsset: _merchItems[index].imageAsset,
      price: _merchItems[index].price,
      category: _merchItems[index].category,
      purchased: true,
    );

    _addExperience(20);
    notifyListeners();
    return true;
  }

  void _addExperience(int amount) {
    int newExp = _user.experience + amount;
    int level = _user.level;
    int expToNext = _user.experienceToNext;

    while (newExp >= expToNext) {
      newExp -= expToNext;
      level++;
      expToNext = (expToNext * 1.2).round();
    }

    _user = _user.copyWith(
      experience: newExp,
      level: level,
      experienceToNext: expToNext,
    );
  }

  void _addPoints(int amount) {
    _points += amount;
  }

  void _unlockAchievement(String id) {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index == -1 || _achievements[index].unlocked) return;

    _achievements[index] = _achievements[index].copyWith(unlocked: true);
    _addPoints(_achievements[index].points);
  }

  void unlockInitialAchievements() {
    _unlockAchievement('first_budget');
    _unlockAchievement('saver_beginner');
    _unlockAchievement('streak_7');
    notifyListeners();
  }

  void _endMonth() {
    _currentDay = 1;
    _currentMonth = (_currentMonth % 12) + 1;
    _balance += _salary;

    // Reset spending
    _categories = _categories.map((c) => c.copyWith(spent: 0)).toList();

    _unlockAchievement('debt_free');
    _addPoints(100);
    _addExperience(100);

    notifyListeners();
  }

  void initializeGame() {
    unlockInitialAchievements();
    notifyListeners();
  }
}
