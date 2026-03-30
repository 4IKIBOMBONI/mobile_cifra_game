import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/models/game_models.dart';
import 'package:cifra_game/services/game_data.dart';

class GameProvider extends ChangeNotifier {
  // User
  UserProfile _user = const UserProfile(name: 'Алексей');
  UserProfile get user => _user;

  // Game state
  int _currentDay = 1;
  int _currentMonth = 1;
  int _totalDaysInMonth = 30;
  double _salary = GameData.defaultSalary;
  double _balance = 60000;
  int _points = 500;
  int _streak = 0;
  int _financialScore = 72;
  int _totalMonthsPlayed = 0;
  int _todayExpenseCount = 0;
  double _todaySpent = 0;

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
  int get totalMonthsPlayed => _totalMonthsPlayed;

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

  // ===== NEW GAME SYSTEMS =====

  // Stocks / Investments
  List<Stock> _stocks = InvestmentSimulator.generateStocks();
  List<Stock> get stocks => _stocks;
  final List<StockPortfolio> _portfolio = [];
  List<StockPortfolio> get portfolio => _portfolio;

  double get portfolioValue {
    double total = 0;
    for (var p in _portfolio) {
      final stock = _stocks.firstWhere((s) => s.id == p.stockId, orElse: () => _stocks.first);
      total += stock.currentPrice * p.shares;
    }
    return total;
  }

  double get portfolioProfit {
    double total = 0;
    for (var p in _portfolio) {
      final stock = _stocks.firstWhere((s) => s.id == p.stockId, orElse: () => _stocks.first);
      total += (stock.currentPrice - p.avgBuyPrice) * p.shares;
    }
    return total;
  }

  // Credit Score
  int _creditScore = 650;
  int get creditScore => _creditScore;

  CreditScore get creditScoreData {
    List<CreditFactor> factors = [];
    if (_streak >= 7) {
      factors.add(const CreditFactor(name: 'Стабильность', description: 'Регулярная активность', impact: CreditImpact.positive));
    }
    if (totalSpent <= totalAllocated) {
      factors.add(const CreditFactor(name: 'Бюджет', description: 'Расходы в пределах бюджета', impact: CreditImpact.positive));
    } else {
      factors.add(const CreditFactor(name: 'Перерасход', description: 'Расходы выше бюджета', impact: CreditImpact.negative));
    }
    if (savingsTotal > 0) {
      factors.add(const CreditFactor(name: 'Накопления', description: 'Есть сбережения', impact: CreditImpact.positive));
    }
    if (_portfolio.isNotEmpty) {
      factors.add(const CreditFactor(name: 'Инвестиции', description: 'Диверсификация доходов', impact: CreditImpact.positive));
    }
    return CreditScore(score: _creditScore, factors: factors);
  }

  // Daily Quests
  List<DailyQuest> _dailyQuests = [];
  List<DailyQuest> get dailyQuests => _dailyQuests;
  int get completedQuestsCount => _dailyQuests.where((q) => q.completed).length;

  // Life Stages
  List<LifeStage> _lifeStages = GameDataExtended.lifeStages();
  List<LifeStage> get lifeStages => _lifeStages;

  LifeStage get currentStage {
    LifeStage current = _lifeStages.first;
    for (var stage in _lifeStages) {
      if (_user.level >= stage.requiredLevel) {
        current = stage;
      }
    }
    return current;
  }

  // Boss Challenges
  List<BossChallenge> _bossChallenges = GameDataExtended.bossChallenges();
  BossChallenge? get currentBossChallenge {
    final idx = _bossChallenges.indexWhere((b) => b.month == _totalMonthsPlayed + 1);
    if (idx != -1) return _bossChallenges[idx];
    if (_bossChallenges.isNotEmpty) {
      return _bossChallenges[_totalMonthsPlayed % _bossChallenges.length];
    }
    return null;
  }

  // Game over
  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  // Pending reward for UI to show
  String? _pendingReward;
  String? get pendingReward => _pendingReward;
  void clearPendingReward() {
    _pendingReward = null;
    notifyListeners();
  }

  // Financial health
  FinancialHealthScore get healthScore => FinancialHealthScore.calculate(
        savingsRate: _salary > 0 ? savingsTotal / _salary * 100 : 0,
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
    _todaySpent += amount;
    _todayExpenseCount++;

    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: categoryId,
      description: description,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.expense,
    ));

    // Update quests
    _updateQuestProgress(QuestType.addExpense, 1);
    if (_todaySpent <= 500) {
      _updateQuestProgress(QuestType.spendLimit, _todaySpent);
    }

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

    _updateQuestProgress(QuestType.saveMoney, amount);
    _creditScore = (_creditScore + 2).clamp(300, 850);
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
      _pendingReward = '🎯 Цель "${_goals[index].name}" достигнута! +300 баллов';
    }

    _creditScore = (_creditScore + 3).clamp(300, 850);
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

  // ===== Day Simulation =====

  bool advanceDay() {
    if (_currentDay >= _totalDaysInMonth) {
      return false; // Signal: month ended, show boss
    }

    _currentDay++;
    _streak++;
    _todaySpent = 0;
    _todayExpenseCount = 0;

    // Advance stock prices
    _stocks = _stocks.map((stock) {
      final newHistory = InvestmentSimulator.advancePrice(stock);
      return Stock(
        id: stock.id,
        name: stock.name,
        ticker: stock.ticker,
        icon: stock.icon,
        priceHistory: newHistory,
        volatility: stock.volatility,
      );
    }).toList();

    // Generate new daily quests every day
    _dailyQuests = GameDataExtended.generateDailyQuests(_currentDay + _currentMonth * 30);

    // Auto-deduct daily mandatory expenses
    double dailyMandatory = mandatoryTotal / _totalDaysInMonth;
    _balance -= dailyMandatory;

    _addExperience(5);

    // Check for streak achievements
    if (_streak >= 7) _unlockAchievement('streak_7');
    if (_streak >= 30) _unlockAchievement('streak_30');

    // Update life stages
    _updateLifeStages();

    notifyListeners();
    return true; // Day advanced normally
  }

  LifeEvent? getRandomEvent() {
    if (_availableEvents.isEmpty) return null;
    // 25% chance
    if (Random().nextDouble() > 0.25) return null;
    final event = _availableEvents[Random().nextInt(_availableEvents.length)];
    return event;
  }

  void applyEventResult(double amount) {
    _balance += amount;
    if (amount < 0) {
      _addExperience(20);
      _creditScore = (_creditScore - 5).clamp(300, 850);
    } else {
      _addExperience(10);
      _creditScore = (_creditScore + 3).clamp(300, 850);
    }
    _unlockAchievement('crisis_manager');
    _addPoints(25);
    notifyListeners();
  }

  // ===== Investment Actions =====

  bool buyStock(String stockId, int shares) {
    final stock = _stocks.firstWhere((s) => s.id == stockId, orElse: () => _stocks.first);
    double cost = stock.currentPrice * shares;
    if (cost > _balance) return false;

    _balance -= cost;

    final existingIdx = _portfolio.indexWhere((p) => p.stockId == stockId);
    if (existingIdx != -1) {
      final existing = _portfolio[existingIdx];
      final totalShares = existing.shares + shares;
      final avgPrice = (existing.avgBuyPrice * existing.shares + cost) / totalShares;
      _portfolio[existingIdx] = existing.copyWith(shares: totalShares, avgBuyPrice: avgPrice);
    } else {
      _portfolio.add(StockPortfolio(
        stockId: stockId,
        shares: shares,
        avgBuyPrice: stock.currentPrice,
      ));
    }

    _updateQuestProgress(QuestType.investAction, 1);
    _unlockAchievement('investor');
    _creditScore = (_creditScore + 1).clamp(300, 850);
    _addExperience(15);
    _addPoints(10);
    notifyListeners();
    return true;
  }

  bool sellStock(String stockId, int shares) {
    final portIdx = _portfolio.indexWhere((p) => p.stockId == stockId);
    if (portIdx == -1) return false;

    final holding = _portfolio[portIdx];
    if (holding.shares < shares) return false;

    final stock = _stocks.firstWhere((s) => s.id == stockId, orElse: () => _stocks.first);
    double revenue = stock.currentPrice * shares;
    _balance += revenue;

    if (holding.shares == shares) {
      _portfolio.removeAt(portIdx);
    } else {
      _portfolio[portIdx] = holding.copyWith(shares: holding.shares - shares);
    }

    double profit = (stock.currentPrice - holding.avgBuyPrice) * shares;
    if (profit > 0) {
      _addPoints((profit / 100).round().clamp(5, 200));
      _pendingReward = '📈 Прибыль от продажи: +${profit.toStringAsFixed(0)} ₽!';
    }

    _addExperience(15);
    notifyListeners();
    return true;
  }

  // ===== Education =====

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
    _creditScore = (_creditScore + 5).clamp(300, 850);

    _updateQuestProgress(QuestType.completeLesson, 1);

    if (completedLessonsCount >= _lessons.length) {
      _unlockAchievement('financial_guru');
      _pendingReward = '🎓 Все уроки пройдены! +500 баллов!';
    }

    notifyListeners();
  }

  void answerQuizCorrectly() {
    _addPoints(25);
    _addExperience(15);
    _unlockAchievement('quiz_champion');
    notifyListeners();
  }

  // ===== Shop =====

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

    _unlockAchievement('smart_shopper');
    _addExperience(20);
    notifyListeners();
    return true;
  }

  // ===== Boss Challenge =====

  void applyBossChoice(BossChoice choice) {
    _balance += choice.moneyCost;
    _addPoints(choice.pointsReward);
    _creditScore = (_creditScore + choice.creditScoreImpact).clamp(300, 850);
    _addExperience(75);
    notifyListeners();
  }

  void endMonth() {
    _currentDay = 1;
    _currentMonth = (_currentMonth % 12) + 1;
    _totalMonthsPlayed++;
    _balance += _salary;
    _todaySpent = 0;
    _todayExpenseCount = 0;

    // Reset spending
    _categories = _categories.map((c) => c.copyWith(spent: 0)).toList();

    // Level-based salary increases
    _updateLifeStages();

    _unlockAchievement('debt_free');
    _addPoints(100);
    _addExperience(100);
    _creditScore = (_creditScore + 5).clamp(300, 850);

    // Regenerate quests
    _dailyQuests = GameDataExtended.generateDailyQuests(_currentDay + _currentMonth * 30);

    // Game over after 12 months
    if (_totalMonthsPlayed >= 12) {
      _isGameOver = true;
    }

    notifyListeners();
  }

  void resetGame() {
    _user = const UserProfile(name: 'Алексей');
    _currentDay = 1;
    _currentMonth = 1;
    _totalDaysInMonth = 30;
    _salary = GameData.defaultSalary;
    _balance = 60000;
    _points = 500;
    _streak = 0;
    _financialScore = 72;
    _totalMonthsPlayed = 0;
    _todayExpenseCount = 0;
    _todaySpent = 0;
    _creditScore = 650;
    _isGameOver = false;
    _pendingReward = null;
    _categories = GameData.defaultCategories();
    _goals = GameData.defaultGoals();
    _achievements = GameData.allAchievements();
    _merchItems = GameData.allMerchItems();
    _lessons = GameData.allLessons();
    _transactions.clear();
    _availableEvents = GameData.randomEvents();
    _stocks = InvestmentSimulator.generateStocks();
    _portfolio.clear();
    _lifeStages = GameDataExtended.lifeStages();
    _bossChallenges = GameDataExtended.bossChallenges();
    _dailyQuests = GameDataExtended.generateDailyQuests(1);
    initializeGame();
  }

  // ===== Quest System =====

  void _updateQuestProgress(QuestType type, double value) {
    for (int i = 0; i < _dailyQuests.length; i++) {
      final quest = _dailyQuests[i];
      if (quest.type == type && !quest.completed) {
        double newValue;
        if (type == QuestType.spendLimit) {
          // For spend limit, we track total spent — complete if under limit
          newValue = value;
          if (_todaySpent <= quest.targetValue) {
            _dailyQuests[i] = quest.copyWith(currentValue: quest.targetValue, completed: true);
            _addPoints(quest.rewardPoints);
            _pendingReward = '✅ Квест "${quest.title}" выполнен! +${quest.rewardPoints} баллов';
          }
        } else {
          newValue = quest.currentValue + value;
          if (newValue >= quest.targetValue) {
            _dailyQuests[i] = quest.copyWith(currentValue: newValue, completed: true);
            _addPoints(quest.rewardPoints);
            _pendingReward = '✅ Квест "${quest.title}" выполнен! +${quest.rewardPoints} баллов';
          } else {
            _dailyQuests[i] = quest.copyWith(currentValue: newValue);
          }
        }
        break;
      }
    }
  }

  // ===== Life Stages =====

  void _updateLifeStages() {
    _lifeStages = _lifeStages.map((stage) {
      if (_user.level >= stage.requiredLevel) {
        return LifeStage(
          id: stage.id,
          title: stage.title,
          description: stage.description,
          icon: stage.icon,
          requiredLevel: stage.requiredLevel,
          unlocked: true,
          perks: stage.perks,
        );
      }
      return stage;
    }).toList();

    // Update salary based on stage
    final stage = currentStage;
    switch (stage.id) {
      case 'junior':
        _salary = 75000;
        break;
      case 'middle':
        _salary = 100000;
        break;
      case 'senior':
        _salary = 150000;
        break;
      case 'master':
        _salary = 250000;
        break;
      default:
        _salary = 60000;
    }
  }

  // ===== Internal Helpers =====

  void _addExperience(int amount) {
    int newExp = _user.experience + amount;
    int level = _user.level;
    int expToNext = _user.experienceToNext;
    bool leveledUp = false;

    while (newExp >= expToNext) {
      newExp -= expToNext;
      level++;
      expToNext = (expToNext * 1.2).round();
      leveledUp = true;
    }

    if (leveledUp) {
      _pendingReward = '🎉 Уровень $level! Новые возможности открыты!';
      _updateLifeStages();
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
    _pendingReward = '🏆 Достижение: ${_achievements[index].title}! +${_achievements[index].points} баллов';
  }

  void initializeGame() {
    _dailyQuests = GameDataExtended.generateDailyQuests(_currentDay + _currentMonth * 30);
    _unlockAchievement('first_budget');
    _updateLifeStages();
    notifyListeners();
  }
}
