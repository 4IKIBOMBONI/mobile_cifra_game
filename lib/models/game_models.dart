import 'dart:math';

class Stock {
  final String id;
  final String name;
  final String ticker;
  final String icon;
  final List<double> priceHistory;
  final StockVolatility volatility;

  const Stock({
    required this.id,
    required this.name,
    required this.ticker,
    required this.icon,
    required this.priceHistory,
    required this.volatility,
  });

  double get currentPrice => priceHistory.last;
  double get previousPrice =>
      priceHistory.length > 1 ? priceHistory[priceHistory.length - 2] : currentPrice;
  double get changePercent =>
      previousPrice > 0 ? ((currentPrice - previousPrice) / previousPrice * 100) : 0;
  bool get isUp => currentPrice >= previousPrice;
}

enum StockVolatility { low, medium, high }

class StockPortfolio {
  final String stockId;
  final int shares;
  final double avgBuyPrice;

  const StockPortfolio({
    required this.stockId,
    required this.shares,
    required this.avgBuyPrice,
  });

  StockPortfolio copyWith({int? shares, double? avgBuyPrice}) {
    return StockPortfolio(
      stockId: stockId,
      shares: shares ?? this.shares,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
    );
  }
}

class DailyQuest {
  final String id;
  final String title;
  final String description;
  final String icon;
  final QuestType type;
  final double targetValue;
  final double currentValue;
  final int rewardPoints;
  final bool completed;

  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    required this.rewardPoints,
    this.completed = false,
  });

  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0;

  DailyQuest copyWith({double? currentValue, bool? completed}) {
    return DailyQuest(
      id: id,
      title: title,
      description: description,
      icon: icon,
      type: type,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewardPoints: rewardPoints,
      completed: completed ?? this.completed,
    );
  }
}

enum QuestType { spendLimit, saveMoney, completeLesson, addExpense, investAction }

class CreditScore {
  final int score; // 300 - 850
  final List<CreditFactor> factors;

  const CreditScore({required this.score, required this.factors});

  String get rating {
    if (score >= 750) return 'Отличный';
    if (score >= 670) return 'Хороший';
    if (score >= 580) return 'Средний';
    if (score >= 450) return 'Низкий';
    return 'Плохой';
  }

  String get emoji {
    if (score >= 750) return '🟢';
    if (score >= 670) return '🔵';
    if (score >= 580) return '🟡';
    if (score >= 450) return '🟠';
    return '🔴';
  }
}

class CreditFactor {
  final String name;
  final String description;
  final CreditImpact impact;

  const CreditFactor({
    required this.name,
    required this.description,
    required this.impact,
  });
}

enum CreditImpact { positive, neutral, negative }

class LifeStage {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredLevel;
  final bool unlocked;
  final List<String> perks;

  const LifeStage({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredLevel,
    this.unlocked = false,
    required this.perks,
  });
}

class BossChallenge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<BossChoice> choices;
  final int month;

  const BossChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.choices,
    required this.month,
  });
}

class BossChoice {
  final String text;
  final double moneyCost;
  final int pointsReward;
  final int creditScoreImpact;
  final String outcome;

  const BossChoice({
    required this.text,
    required this.moneyCost,
    required this.pointsReward,
    required this.creditScoreImpact,
    required this.outcome,
  });
}

class DayAction {
  final String id;
  final String title;
  final String icon;
  final DayActionType type;

  const DayAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.type,
  });
}

enum DayActionType { work, rest, study, invest, shop, save }

class InvestmentSimulator {
  static List<Stock> generateStocks() {
    return [
      Stock(
        id: 'sber',
        name: 'СберБанк',
        ticker: 'SBER',
        icon: '🏦',
        priceHistory: _generatePrices(280, 15, 30),
        volatility: StockVolatility.low,
      ),
      Stock(
        id: 'yandex',
        name: 'Яндекс',
        ticker: 'YNDX',
        icon: '🔍',
        priceHistory: _generatePrices(3200, 200, 30),
        volatility: StockVolatility.medium,
      ),
      Stock(
        id: 'gazprom',
        name: 'Газпром',
        ticker: 'GAZP',
        icon: '⛽',
        priceHistory: _generatePrices(165, 10, 30),
        volatility: StockVolatility.low,
      ),
      Stock(
        id: 'vk',
        name: 'VK Company',
        ticker: 'VKCO',
        icon: '💬',
        priceHistory: _generatePrices(450, 50, 30),
        volatility: StockVolatility.high,
      ),
      Stock(
        id: 'ozon',
        name: 'OZON',
        ticker: 'OZON',
        icon: '📦',
        priceHistory: _generatePrices(2800, 180, 30),
        volatility: StockVolatility.high,
      ),
    ];
  }

  static List<double> _generatePrices(double base, double range, int count) {
    final random = Random(42);
    List<double> prices = [];
    double current = base;
    for (int i = 0; i < count; i++) {
      current += (random.nextDouble() - 0.45) * range * 0.3;
      current = current.clamp(base - range, base + range);
      prices.add(double.parse(current.toStringAsFixed(1)));
    }
    return prices;
  }

  static List<double> advancePrice(Stock stock) {
    final random = Random();
    double multiplier;
    switch (stock.volatility) {
      case StockVolatility.low:
        multiplier = 0.02;
        break;
      case StockVolatility.medium:
        multiplier = 0.04;
        break;
      case StockVolatility.high:
        multiplier = 0.07;
        break;
    }

    double change = (random.nextDouble() - 0.45) * stock.currentPrice * multiplier;
    double newPrice = (stock.currentPrice + change).clamp(
      stock.currentPrice * 0.85,
      stock.currentPrice * 1.15,
    );

    List<double> newHistory = [...stock.priceHistory, double.parse(newPrice.toStringAsFixed(1))];
    if (newHistory.length > 60) {
      newHistory = newHistory.sublist(newHistory.length - 60);
    }
    return newHistory;
  }
}

class GameDataExtended {
  static List<DailyQuest> generateDailyQuests(int day) {
    final allQuests = [
      DailyQuest(
        id: 'spend_limit_${day}',
        title: 'Экономный день',
        description: 'Потратьте не больше 500 ₽ за день',
        icon: '💰',
        type: QuestType.spendLimit,
        targetValue: 500,
        rewardPoints: 75,
      ),
      DailyQuest(
        id: 'save_money_${day}',
        title: 'В копилку!',
        description: 'Отложите 1,000 ₽ в накопления',
        icon: '🐷',
        type: QuestType.saveMoney,
        targetValue: 1000,
        rewardPoints: 100,
      ),
      DailyQuest(
        id: 'lesson_${day}',
        title: 'Ученик дня',
        description: 'Пройдите один урок',
        icon: '📚',
        type: QuestType.completeLesson,
        targetValue: 1,
        rewardPoints: 50,
      ),
      DailyQuest(
        id: 'track_expense_${day}',
        title: 'Учёт расходов',
        description: 'Запишите 3 расхода',
        icon: '📝',
        type: QuestType.addExpense,
        targetValue: 3,
        rewardPoints: 60,
      ),
      DailyQuest(
        id: 'invest_${day}',
        title: 'Начинающий инвестор',
        description: 'Совершите 1 сделку на бирже',
        icon: '📈',
        type: QuestType.investAction,
        targetValue: 1,
        rewardPoints: 80,
      ),
    ];

    // Pick 3 random quests for the day
    allQuests.shuffle(Random(day * 7));
    return allQuests.take(3).toList();
  }

  static List<LifeStage> lifeStages() {
    return const [
      LifeStage(
        id: 'student',
        title: 'Студент',
        description: 'Начало пути. Изучите основы финансов.',
        icon: '🎓',
        requiredLevel: 1,
        unlocked: true,
        perks: ['Доступ к базовым урокам', 'Зарплата: 60,000 ₽'],
      ),
      LifeStage(
        id: 'junior',
        title: 'Начинающий специалист',
        description: 'Первая работа и реальные финансы.',
        icon: '💼',
        requiredLevel: 3,
        perks: ['Зарплата: 75,000 ₽', 'Доступ к инвестициям', 'Кредитная карта'],
      ),
      LifeStage(
        id: 'middle',
        title: 'Опытный специалист',
        description: 'Рост дохода и новые возможности.',
        icon: '🚀',
        requiredLevel: 5,
        perks: ['Зарплата: 100,000 ₽', 'Доступ ко всем акциям', 'Ипотека'],
      ),
      LifeStage(
        id: 'senior',
        title: 'Финансовый эксперт',
        description: 'Мастерство управления деньгами.',
        icon: '👑',
        requiredLevel: 8,
        perks: ['Зарплата: 150,000 ₽', 'Пассивный доход', 'Бонус ×2 к баллам'],
      ),
      LifeStage(
        id: 'master',
        title: 'Финансовая свобода',
        description: 'Вы достигли вершины!',
        icon: '🏆',
        requiredLevel: 12,
        perks: ['Зарплата: 250,000 ₽', 'Все достижения ×2', 'Эксклюзивный мерч'],
      ),
    ];
  }

  static List<BossChallenge> bossChallenges() {
    return const [
      BossChallenge(
        id: 'boss_rent_increase',
        title: 'Повышение аренды!',
        description: 'Арендодатель поднимает стоимость на 20%. У вас 3 варианта.',
        icon: '🏠',
        month: 1,
        choices: [
          BossChoice(
            text: 'Согласиться и платить больше',
            moneyCost: -4000,
            pointsReward: 25,
            creditScoreImpact: 10,
            outcome: 'Вы сохранили жильё, но бюджет стал теснее. Кредитный рейтинг вырос — вы надёжный арендатор.',
          ),
          BossChoice(
            text: 'Найти соседа и разделить расходы',
            moneyCost: -1000,
            pointsReward: 150,
            creditScoreImpact: 5,
            outcome: 'Отличное решение! Вы нашли компромисс и сэкономили. +150 баллов за находчивость!',
          ),
          BossChoice(
            text: 'Переехать в район подешевле',
            moneyCost: -8000,
            pointsReward: 100,
            creditScoreImpact: 0,
            outcome: 'Переезд стоил денег, но в долгосрочной перспективе вы будете экономить каждый месяц.',
          ),
        ],
      ),
      BossChallenge(
        id: 'boss_job_offer',
        title: 'Предложение о работе',
        description: 'Вам предлагают новую работу. Зарплата выше, но есть нюансы.',
        icon: '💼',
        month: 2,
        choices: [
          BossChoice(
            text: 'Принять (+15,000 ₽/мес, но далеко)',
            moneyCost: -3000,
            pointsReward: 200,
            creditScoreImpact: 15,
            outcome: 'Вы приняли оффер! Расходы на дорогу выросли, но доход перекрывает это с запасом.',
          ),
          BossChoice(
            text: 'Остаться и попросить повышение',
            moneyCost: 0,
            pointsReward: 100,
            creditScoreImpact: 5,
            outcome: 'Босс оценил лояльность и дал +5,000 ₽/мес. Иногда стабильность — лучшая стратегия.',
          ),
          BossChoice(
            text: 'Принять и переехать ближе к офису',
            moneyCost: -20000,
            pointsReward: 250,
            creditScoreImpact: 20,
            outcome: 'Смелый ход! Большие расходы сейчас, но максимальная выгода в будущем. +250 баллов!',
          ),
        ],
      ),
      BossChallenge(
        id: 'boss_car_decision',
        title: 'Нужен автомобиль',
        description: 'Без машины стало сложно. Как решите транспортный вопрос?',
        icon: '🚗',
        month: 3,
        choices: [
          BossChoice(
            text: 'Взять в кредит новую',
            moneyCost: -15000,
            pointsReward: 50,
            creditScoreImpact: -10,
            outcome: 'Кредит на 3 года. Ежемесячный платёж 15,000 ₽. Кредитная нагрузка выросла.',
          ),
          BossChoice(
            text: 'Купить б/у за накопления',
            moneyCost: -150000,
            pointsReward: 200,
            creditScoreImpact: 15,
            outcome: 'Мудрый выбор! Без кредита и переплат. Кредитный рейтинг вырос!',
          ),
          BossChoice(
            text: 'Оформить каршеринг',
            moneyCost: -5000,
            pointsReward: 150,
            creditScoreImpact: 5,
            outcome: 'Экономное решение! 5,000 ₽/мес вместо владения. Гибкость — тоже навык.',
          ),
        ],
      ),
    ];
  }
}
