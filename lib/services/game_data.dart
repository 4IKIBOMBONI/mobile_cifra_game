import 'package:cifra_game/models/game_state.dart';
import 'package:cifra_game/theme/app_theme.dart';

class GameData {
  static const double defaultSalary = 60000;

  static List<BudgetCategory> defaultCategories() {
    return [
      BudgetCategory(
        id: 'housing',
        name: 'Жильё',
        icon: '🏠',
        allocated: 18900,
        colorValue: AppColors.housing.value,
        type: BudgetCategoryType.mandatory,
      ),
      BudgetCategory(
        id: 'food',
        name: 'Продукты',
        icon: '🛒',
        allocated: 12000,
        colorValue: AppColors.food.value,
        type: BudgetCategoryType.mandatory,
      ),
      BudgetCategory(
        id: 'transport',
        name: 'Транспорт',
        icon: '🚌',
        allocated: 5500,
        colorValue: AppColors.transport.value,
        type: BudgetCategoryType.mandatory,
      ),
      BudgetCategory(
        id: 'utilities',
        name: 'Коммунальные',
        icon: '💡',
        allocated: 4500,
        colorValue: 0xFF3498DB,
        type: BudgetCategoryType.mandatory,
      ),
      BudgetCategory(
        id: 'communication',
        name: 'Связь',
        icon: '📱',
        allocated: 1100,
        colorValue: 0xFFE67E22,
        type: BudgetCategoryType.mandatory,
      ),
      BudgetCategory(
        id: 'entertainment',
        name: 'Развлечения',
        icon: '🎮',
        allocated: 4800,
        colorValue: AppColors.entertainment.value,
        type: BudgetCategoryType.variable,
      ),
      BudgetCategory(
        id: 'cafe',
        name: 'Кафе и рестораны',
        icon: '☕',
        allocated: 3000,
        colorValue: 0xFFD35400,
        type: BudgetCategoryType.variable,
      ),
      BudgetCategory(
        id: 'clothing',
        name: 'Одежда',
        icon: '👕',
        allocated: 2500,
        colorValue: 0xFF9B59B6,
        type: BudgetCategoryType.variable,
      ),
      BudgetCategory(
        id: 'education',
        name: 'Обучение',
        icon: '📚',
        allocated: 4030,
        colorValue: AppColors.education.value,
        type: BudgetCategoryType.variable,
      ),
      BudgetCategory(
        id: 'savings',
        name: 'Накопления',
        icon: '🐷',
        allocated: 3670,
        colorValue: AppColors.savings.value,
        type: BudgetCategoryType.savings,
      ),
    ];
  }

  static List<FinancialGoal> defaultGoals() {
    return [
      const FinancialGoal(
        id: 'emergency',
        name: 'Подушка безопасности',
        icon: '🛡️',
        targetAmount: 180000,
        currentAmount: 45000,
      ),
      const FinancialGoal(
        id: 'vacation',
        name: 'Отпуск',
        icon: '✈️',
        targetAmount: 80000,
        currentAmount: 12000,
      ),
      const FinancialGoal(
        id: 'gadget',
        name: 'Новый гаджет',
        icon: '📱',
        targetAmount: 50000,
        currentAmount: 8500,
      ),
    ];
  }

  static List<Achievement> allAchievements() {
    return const [
      Achievement(
        id: 'first_budget',
        title: 'Первый бюджет',
        description: 'Составьте свой первый бюджет на месяц',
        icon: '📋',
        points: 50,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'saver_beginner',
        title: 'Начинающий копилка',
        description: 'Отложите 5,000 ₽ на накопления',
        icon: '🐷',
        points: 100,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'budget_master',
        title: 'Мастер бюджета',
        description: 'Не превышайте бюджет в течение 3 месяцев',
        icon: '👑',
        points: 300,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 'financial_guru',
        title: 'Финансовый гуру',
        description: 'Пройдите все образовательные уроки',
        icon: '🎓',
        points: 500,
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: 'crisis_manager',
        title: 'Антикризисный менеджер',
        description: 'Успешно преодолейте 5 случайных событий',
        icon: '🛡️',
        points: 250,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 'quiz_champion',
        title: 'Чемпион викторин',
        description: 'Ответьте правильно на 20 вопросов',
        icon: '🏆',
        points: 200,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Неделя стабильности',
        description: 'Войдите в приложение 7 дней подряд',
        icon: '🔥',
        points: 150,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'streak_30',
        title: 'Месяц дисциплины',
        description: 'Войдите в приложение 30 дней подряд',
        icon: '⭐',
        points: 500,
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: 'goal_reached',
        title: 'Цель достигнута',
        description: 'Достигните первую финансовую цель',
        icon: '🎯',
        points: 300,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 'investor',
        title: 'Инвестор',
        description: 'Накопите подушку безопасности в 3 зарплаты',
        icon: '💎',
        points: 1000,
        rarity: AchievementRarity.legendary,
      ),
      Achievement(
        id: 'smart_shopper',
        title: 'Умный покупатель',
        description: 'Сэкономьте 20% от бюджета на покупки',
        icon: '🛍️',
        points: 200,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 'debt_free',
        title: 'Без долгов',
        description: 'Закончите месяц без перерасхода',
        icon: '✅',
        points: 150,
        rarity: AchievementRarity.common,
      ),
    ];
  }

  static List<MerchItem> allMerchItems() {
    return const [
      MerchItem(
        id: 'tshirt',
        name: 'Футболка FinSim',
        description: 'Стильная футболка с логотипом',
        imageAsset: 'assets/images/merch_tshirt.png',
        price: 500,
        category: MerchCategory.clothing,
      ),
      MerchItem(
        id: 'hoodie',
        name: 'Худи Simulator',
        description: 'Тёплая худи с принтом',
        imageAsset: 'assets/images/merch_hoodie.png',
        price: 1200,
        category: MerchCategory.clothing,
      ),
      MerchItem(
        id: 'cap',
        name: 'Кепка FinSim',
        description: 'Кепка с вышитым логотипом',
        imageAsset: 'assets/images/merch_cap.png',
        price: 400,
        category: MerchCategory.accessories,
      ),
      MerchItem(
        id: 'stickers',
        name: 'Стикеры',
        description: 'Набор стикеров с финансовой тематикой',
        imageAsset: 'assets/images/merch_stickers.png',
        price: 150,
        category: MerchCategory.souvenirs,
      ),
      MerchItem(
        id: 'notebook',
        name: 'Блокнот',
        description: 'Блокнот для финансового планирования',
        imageAsset: 'assets/images/merch_notebook.png',
        price: 300,
        category: MerchCategory.accessories,
      ),
      MerchItem(
        id: 'powerbank',
        name: 'Повербанк',
        description: 'Повербанк с логотипом FinSim',
        imageAsset: 'assets/images/merch_powerbank.png',
        price: 2000,
        category: MerchCategory.accessories,
      ),
    ];
  }

  static List<LifeEvent> randomEvents() {
    return const [
      LifeEvent(
        id: 'car_repair',
        title: 'Поломка автомобиля',
        description: 'Ваш автомобиль сломался и требует ремонта. Нужно оплатить ремонт.',
        icon: '🚗',
        amount: -15000,
        type: LifeEventType.expense,
      ),
      LifeEvent(
        id: 'bonus',
        title: 'Премия на работе!',
        description: 'Отличная работа! Вам начислили квартальную премию.',
        icon: '🎉',
        amount: 10000,
        type: LifeEventType.income,
      ),
      LifeEvent(
        id: 'medical',
        title: 'Визит к врачу',
        description: 'Непредвиденный визит к стоматологу.',
        icon: '🏥',
        amount: -8000,
        type: LifeEventType.expense,
      ),
      LifeEvent(
        id: 'tax_refund',
        title: 'Налоговый вычет',
        description: 'Получен налоговый вычет за обучение.',
        icon: '💰',
        amount: 13000,
        type: LifeEventType.income,
      ),
      LifeEvent(
        id: 'appliance',
        title: 'Сломалась стиральная машина',
        description: 'Стиральная машина вышла из строя. Нужна новая.',
        icon: '🔧',
        amount: -25000,
        type: LifeEventType.expense,
      ),
      LifeEvent(
        id: 'freelance',
        title: 'Подработка',
        description: 'Вам предложили подработку на выходных.',
        icon: '💻',
        amount: 5000,
        type: LifeEventType.income,
      ),
      LifeEvent(
        id: 'sale_choice',
        title: 'Большая распродажа!',
        description: 'В магазине огромные скидки. Купить новый гаджет со скидкой 50% или отложить деньги?',
        icon: '🏷️',
        amount: 0,
        type: LifeEventType.choice,
        choices: [
          EventChoice(
            text: 'Купить со скидкой (-12,000 ₽)',
            amount: -12000,
            pointsReward: 0,
            feedback: 'Вы потратили деньги на импульсивную покупку. Скидка не экономия, если покупка не планировалась!',
          ),
          EventChoice(
            text: 'Отложить деньги (+12,000 ₽ в копилку)',
            amount: 0,
            pointsReward: 100,
            feedback: 'Отличное решение! Вы избежали импульсивной покупки и заработали 100 баллов.',
          ),
        ],
      ),
      LifeEvent(
        id: 'friend_loan',
        title: 'Друг просит в долг',
        description: 'Друг просит одолжить 10,000 ₽. Как поступите?',
        icon: '🤝',
        amount: 0,
        type: LifeEventType.choice,
        choices: [
          EventChoice(
            text: 'Дать в долг (-10,000 ₽)',
            amount: -10000,
            pointsReward: 50,
            feedback: 'Вы помогли другу, но помните — давая в долг, будьте готовы, что деньги могут не вернуть.',
          ),
          EventChoice(
            text: 'Вежливо отказать',
            amount: 0,
            pointsReward: 75,
            feedback: 'Разумное решение. Давать в долг рискованно, особенно если это может подорвать ваш бюджет.',
          ),
        ],
      ),
      LifeEvent(
        id: 'invest_opportunity',
        title: 'Инвестиционная возможность',
        description: 'Вам предложили вложить деньги в перспективный проект. Риск умеренный.',
        icon: '📈',
        amount: 0,
        type: LifeEventType.choice,
        choices: [
          EventChoice(
            text: 'Инвестировать 5,000 ₽',
            amount: -5000,
            pointsReward: 150,
            feedback: 'Вы сделали инвестицию! Диверсификация — ключ к финансовой стабильности.',
          ),
          EventChoice(
            text: 'Пропустить',
            amount: 0,
            pointsReward: 50,
            feedback: 'Осторожность — тоже стратегия. Но иногда разумный риск окупается.',
          ),
        ],
      ),
    ];
  }

  static List<EducationLesson> allLessons() {
    return const [
      EducationLesson(
        id: 'budget_basics',
        title: 'Основы бюджетирования',
        description: 'Узнайте, как правильно составить бюджет и следовать ему',
        icon: '📊',
        difficulty: LessonDifficulty.beginner,
        rewardPoints: 100,
        contents: [
          LessonContent(
            title: 'Что такое бюджет?',
            body: 'Бюджет — это план распределения доходов и расходов на определённый период. '
                'Он помогает контролировать финансы и достигать целей.\n\n'
                'Основные принципы:\n'
                '• Записывайте все доходы и расходы\n'
                '• Разделяйте расходы на обязательные и необязательные\n'
                '• Всегда откладывайте часть дохода',
          ),
          LessonContent(
            title: 'Правило 50/30/20',
            body: 'Популярный метод распределения бюджета:\n\n'
                '50% — обязательные расходы (жильё, еда, транспорт)\n'
                '30% — переменные расходы (развлечения, хобби)\n'
                '20% — накопления и инвестиции\n\n'
                'Это базовое правило, которое можно адаптировать под свои нужды.',
          ),
        ],
        quiz: [
          QuizQuestion(
            question: 'Какой процент дохода рекомендуется откладывать по правилу 50/30/20?',
            options: ['10%', '20%', '30%', '50%'],
            correctIndex: 1,
            explanation: 'По правилу 50/30/20, рекомендуется откладывать 20% дохода на накопления и инвестиции.',
          ),
          QuizQuestion(
            question: 'Что из перечисленного относится к обязательным расходам?',
            options: ['Поход в кино', 'Аренда жилья', 'Покупка игры', 'Поход в кафе'],
            correctIndex: 1,
            explanation: 'Аренда жилья — это обязательный расход, без которого нельзя обойтись.',
          ),
        ],
      ),
      EducationLesson(
        id: 'credit_history',
        title: 'Кредитная история',
        description: 'Что такое кредитная история и почему она важна',
        icon: '📝',
        difficulty: LessonDifficulty.beginner,
        rewardPoints: 100,
        contents: [
          LessonContent(
            title: 'Что такое кредитная история?',
            body: 'Кредитная история — это информация обо всех ваших кредитах и займах.\n\n'
                'В ней фиксируется:\n'
                '• Какие кредиты вы брали\n'
                '• Как вовремя платили\n'
                '• Были ли просрочки\n'
                '• Текущие задолженности\n\n'
                'Банки проверяют кредитную историю перед выдачей кредита.',
          ),
          LessonContent(
            title: 'Как улучшить кредитную историю?',
            body: '• Всегда платите вовремя\n'
                '• Не берите много кредитов одновременно\n'
                '• Начните с небольшого кредита или кредитной карты\n'
                '• Регулярно проверяйте свою кредитную историю\n'
                '• Не допускайте просрочек даже на 1 день',
          ),
        ],
        quiz: [
          QuizQuestion(
            question: 'Что фиксируется в кредитной истории?',
            options: ['Только ваша зарплата', 'Все кредиты и платежи по ним', 'Только просрочки', 'Только крупные кредиты'],
            correctIndex: 1,
            explanation: 'В кредитной истории отражаются все кредиты, займы и платежи по ним.',
          ),
        ],
      ),
      EducationLesson(
        id: 'compound_interest',
        title: 'Сложные проценты',
        description: 'Как работают проценты и почему начинать копить нужно рано',
        icon: '📈',
        difficulty: LessonDifficulty.intermediate,
        rewardPoints: 150,
        contents: [
          LessonContent(
            title: 'Простые и сложные проценты',
            body: 'Простые проценты начисляются только на начальную сумму.\n'
                'Сложные проценты начисляются на сумму + ранее начисленные проценты.\n\n'
                'Пример: вклад 100,000 ₽ под 10% годовых\n\n'
                'Простые проценты: каждый год +10,000 ₽\n'
                'Через 5 лет: 150,000 ₽\n\n'
                'Сложные проценты:\n'
                '1 год: 110,000 ₽\n'
                '2 год: 121,000 ₽\n'
                '3 год: 133,100 ₽\n'
                '5 лет: 161,051 ₽\n\n'
                'Разница 11,051 ₽ — и она растёт с каждым годом!',
          ),
          LessonContent(
            title: 'Правило 72',
            body: 'Простой способ узнать, за сколько лет ваши деньги удвоятся:\n\n'
                '72 ÷ процентная ставка = количество лет\n\n'
                'При ставке 8%: 72 ÷ 8 = 9 лет\n'
                'При ставке 12%: 72 ÷ 12 = 6 лет\n\n'
                'Чем раньше начнёте — тем больше заработаете!',
          ),
        ],
        quiz: [
          QuizQuestion(
            question: 'Чем сложные проценты отличаются от простых?',
            options: [
              'Они больше',
              'Начисляются на сумму вместе с процентами',
              'Они фиксированные',
              'Начисляются реже',
            ],
            correctIndex: 1,
            explanation: 'Сложные проценты начисляются на сумму вместе с ранее накопленными процентами — это и есть «процент на процент».',
          ),
          QuizQuestion(
            question: 'По правилу 72, за сколько лет удвоятся деньги при ставке 12%?',
            options: ['4 года', '6 лет', '8 лет', '12 лет'],
            correctIndex: 1,
            explanation: '72 ÷ 12 = 6 лет. Это приблизительный расчёт для сложных процентов.',
          ),
        ],
      ),
      EducationLesson(
        id: 'emergency_fund',
        title: 'Подушка безопасности',
        description: 'Зачем нужен резервный фонд и как его создать',
        icon: '🛡️',
        difficulty: LessonDifficulty.beginner,
        rewardPoints: 100,
        contents: [
          LessonContent(
            title: 'Зачем нужна подушка безопасности?',
            body: 'Подушка безопасности — это денежный резерв на непредвиденные расходы.\n\n'
                'Она нужна для:\n'
                '• Потери работы\n'
                '• Срочного ремонта\n'
                '• Медицинских расходов\n'
                '• Любых форс-мажоров\n\n'
                'Рекомендуемый размер: 3-6 месячных расходов.',
          ),
          LessonContent(
            title: 'Как создать подушку?',
            body: '1. Определите размер (3-6 месяцев расходов)\n'
                '2. Откладывайте фиксированную сумму каждый месяц\n'
                '3. Храните на отдельном накопительном счёте\n'
                '4. Не тратьте на текущие нужды\n'
                '5. Пополняйте после каждого использования',
          ),
        ],
        quiz: [
          QuizQuestion(
            question: 'Какой рекомендуемый размер подушки безопасности?',
            options: ['1 зарплата', '3-6 месяцев расходов', '1 год дохода', '10% от зарплаты'],
            correctIndex: 1,
            explanation: 'Эксперты рекомендуют иметь резерв в размере 3-6 месяцев ваших расходов.',
          ),
        ],
      ),
      EducationLesson(
        id: 'inflation',
        title: 'Инфляция и ваши деньги',
        description: 'Как инфляция влияет на покупательную способность',
        icon: '💸',
        difficulty: LessonDifficulty.intermediate,
        rewardPoints: 150,
        contents: [
          LessonContent(
            title: 'Что такое инфляция?',
            body: 'Инфляция — это рост общего уровня цен на товары и услуги.\n\n'
                'Если инфляция 10% в год, то:\n'
                '• Товар за 1,000 ₽ через год будет стоить 1,100 ₽\n'
                '• Ваши 100,000 ₽ «потеряют» 10,000 ₽ покупательной силы\n\n'
                'Именно поэтому просто хранить деньги «под подушкой» — плохая стратегия.',
          ),
          LessonContent(
            title: 'Как защититься от инфляции?',
            body: '• Размещайте накопления на вкладах с процентом выше инфляции\n'
                '• Рассмотрите инвестиции (акции, облигации)\n'
                '• Вкладывайте в своё образование\n'
                '• Диверсифицируйте сбережения\n'
                '• Не храните все деньги наличными',
          ),
        ],
        quiz: [
          QuizQuestion(
            question: 'Что происходит с покупательной способностью денег при инфляции?',
            options: ['Растёт', 'Снижается', 'Не меняется', 'Зависит от банка'],
            correctIndex: 1,
            explanation: 'При инфляции покупательная способность денег снижается — на ту же сумму можно купить меньше товаров.',
          ),
        ],
      ),
      EducationLesson(
        id: 'investing_basics',
        title: 'Основы инвестирования',
        description: 'Первые шаги в мире инвестиций',
        icon: '🚀',
        difficulty: LessonDifficulty.advanced,
        rewardPoints: 200,
        contents: [
          LessonContent(
            title: 'Виды инвестиций',
            body: 'Основные инструменты:\n\n'
                '🏦 Банковские вклады — низкий риск, невысокая доходность\n'
                '📄 Облигации — умеренный риск, стабильный доход\n'
                '📈 Акции — высокий риск, потенциально высокая доходность\n'
                '🏠 Недвижимость — средний риск, требует большого капитала\n'
                '💰 Фонды (ETF) — диверсификация, подходит для начинающих',
          ),
          LessonContent(
            title: 'Правила начинающего инвестора',
            body: '1. Сначала создайте подушку безопасности\n'
                '2. Инвестируйте только свободные деньги\n'
                '3. Диверсифицируйте — не кладите все яйца в одну корзину\n'
                '4. Инвестируйте регулярно, даже небольшие суммы\n'
                '5. Думайте долгосрочно\n'
                '6. Изучайте, прежде чем вкладывать',
          ),
        ],
        quiz: [
          QuizQuestion(
            question: 'Какое правило самое важное для начинающего инвестора?',
            options: [
              'Вложить все деньги в акции',
              'Сначала создать подушку безопасности',
              'Взять кредит для инвестиций',
              'Инвестировать только в криптовалюту',
            ],
            correctIndex: 1,
            explanation: 'Прежде чем инвестировать, необходимо создать финансовую подушку безопасности.',
          ),
        ],
      ),
    ];
  }
}
