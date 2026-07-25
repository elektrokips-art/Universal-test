enum AppLanguage { ru, uz }

/// Lightweight hand-rolled i18n (no codegen) for the two supported
/// interface languages: Russian and Uzbek (Latin).
class AppStrings {
  static const Map<String, Map<AppLanguage, String>> _t = {
    'appTitle': {
      AppLanguage.ru: 'Universal Test',
      AppLanguage.uz: 'Universal Test',
    },
    'myTests': {
      AppLanguage.ru: 'Мои тесты',
      AppLanguage.uz: 'Mening testlarim',
    },
    'newTest': {
      AppLanguage.ru: 'Новый тест',
      AppLanguage.uz: 'Yangi test',
    },
    'noTests': {
      AppLanguage.ru: 'Пока нет сохранённых тестов',
      AppLanguage.uz: 'Hozircha saqlangan testlar yo\'q',
    },
    'start': {
      AppLanguage.ru: 'Запустить',
      AppLanguage.uz: 'Boshlash',
    },
    'edit': {
      AppLanguage.ru: 'Изменить',
      AppLanguage.uz: 'Tahrirlash',
    },
    'delete': {
      AppLanguage.ru: 'Удалить',
      AppLanguage.uz: 'O\'chirish',
    },
    'gradeScale': {
      AppLanguage.ru: 'Шкала оценок',
      AppLanguage.uz: 'Baholash shkalasi',
    },
    'testName': {
      AppLanguage.ru: 'Название теста',
      AppLanguage.uz: 'Test nomi',
    },
    'question': {
      AppLanguage.ru: 'Вопрос',
      AppLanguage.uz: 'Savol',
    },
    'answersCount': {
      AppLanguage.ru: 'Кол-во ответов',
      AppLanguage.uz: 'Javoblar soni',
    },
    'answer': {
      AppLanguage.ru: 'Ответ',
      AppLanguage.uz: 'Javob',
    },
    'correct': {
      AppLanguage.ru: 'Верный',
      AppLanguage.uz: 'To\'g\'ri',
    },
    'save': {
      AppLanguage.ru: 'Сохранить',
      AppLanguage.uz: 'Saqlash',
    },
    'saveAsRecipe': {
      AppLanguage.ru: 'Сохранить как рецепт',
      AppLanguage.uz: 'Retsept sifatida saqlash',
    },
    'cancel': {
      AppLanguage.ru: 'Отмена',
      AppLanguage.uz: 'Bekor qilish',
    },
    'grade5': {
      AppLanguage.ru: 'Оценка 5',
      AppLanguage.uz: 'Baho 5',
    },
    'grade4': {
      AppLanguage.ru: 'Оценка 4',
      AppLanguage.uz: 'Baho 4',
    },
    'grade3': {
      AppLanguage.ru: 'Оценка 3',
      AppLanguage.uz: 'Baho 3',
    },
    'grade2': {
      AppLanguage.ru: 'Оценка 2',
      AppLanguage.uz: 'Baho 2',
    },
    'from': {
      AppLanguage.ru: 'от',
      AppLanguage.uz: 'dan',
    },
    'to': {
      AppLanguage.ru: 'до',
      AppLanguage.uz: 'gacha',
    },
    'startSession': {
      AppLanguage.ru: 'Начать сеанс тестирования',
      AppLanguage.uz: 'Test seansini boshlash',
    },
    'scanQr': {
      AppLanguage.ru: 'Ученики сканируют QR-код и подключаются к точке доступа',
      AppLanguage.uz:
          'O\'quvchilar QR-kodni skanerlab, tarmoqqa ulanadilar',
    },
    'ipAddress': {
      AppLanguage.ru: 'Адрес',
      AppLanguage.uz: 'Manzil',
    },
    'submissions': {
      AppLanguage.ru: 'Сдали тест',
      AppLanguage.uz: 'Topshirganlar',
    },
    'noSubmissionsYet': {
      AppLanguage.ru: 'Пока никто не сдал тест',
      AppLanguage.uz: 'Hozircha hech kim topshirmagan',
    },
    'generatePdf': {
      AppLanguage.ru: 'Сформировать PDF',
      AppLanguage.uz: 'PDF shakllantirish',
    },
    'stopSession': {
      AppLanguage.ru: 'Завершить сеанс',
      AppLanguage.uz: 'Seansni yakunlash',
    },
    'fio': {
      AppLanguage.ru: 'Фамилия Имя',
      AppLanguage.uz: 'Familiya Ism',
    },
    'studentClass': {
      AppLanguage.ru: 'Класс',
      AppLanguage.uz: 'Sinf',
    },
    'startTest': {
      AppLanguage.ru: 'Начать тест',
      AppLanguage.uz: 'Testni boshlash',
    },
    'submit': {
      AppLanguage.ru: 'Отправить',
      AppLanguage.uz: 'Yuborish',
    },
    'thankYou': {
      AppLanguage.ru: 'Спасибо! Тест сдан.',
      AppLanguage.uz: 'Rahmat! Test topshirildi.',
    },
    'fillAllFields': {
      AppLanguage.ru: 'Заполните все поля',
      AppLanguage.uz: 'Barcha maydonlarni to\'ldiring',
    },
    'answerAllQuestions': {
      AppLanguage.ru: 'Ответьте на все вопросы',
      AppLanguage.uz: 'Barcha savollarga javob bering',
    },
    'aiGenerate': {
      AppLanguage.ru: 'Сгенерировать с ИИ',
      AppLanguage.uz: 'AI bilan yaratish',
    },
    'aiTopic': {
      AppLanguage.ru: 'Тема теста',
      AppLanguage.uz: 'Test mavzusi',
    },
    'aiQuestionsCount': {
      AppLanguage.ru: 'Количество вопросов',
      AppLanguage.uz: 'Savollar soni',
    },
    'aiOptionsCount': {
      AppLanguage.ru: 'Вариантов ответа на вопрос',
      AppLanguage.uz: 'Har savolga javob varianti',
    },
    'aiGenerating': {
      AppLanguage.ru: 'Генерация вопросов…',
      AppLanguage.uz: 'Savollar yaratilmoqda…',
    },
    'aiMissingKey': {
      AppLanguage.ru: 'Сначала укажите API-ключ в настройках',
      AppLanguage.uz: 'Avval sozlamalarda API kalitini kiriting',
    },
    'aiError': {
      AppLanguage.ru: 'Не удалось сгенерировать вопросы. Проверьте ключ и интернет',
      AppLanguage.uz: 'Savollarni yaratib bo\'lmadi. Kalit va internetni tekshiring',
    },
    'aiGenerated': {
      AppLanguage.ru: 'Вопросы сгенерированы и добавлены в тест',
      AppLanguage.uz: 'Savollar yaratildi va testga qo\'shildi',
    },
    'aiWillOverwrite': {
      AppLanguage.ru: 'Сгенерированные вопросы заполнят пустые слоты сверху вниз',
      AppLanguage.uz: 'Yaratilgan savollar bo\'sh joylarni tepadan boshlab to\'ldiradi',
    },
    'settings': {
      AppLanguage.ru: 'Настройки',
      AppLanguage.uz: 'Sozlamalar',
    },
    'apiKeySettings': {
      AppLanguage.ru: 'Настройки ИИ (OpenRouter)',
      AppLanguage.uz: 'AI sozlamalari (OpenRouter)',
    },
    'apiKeyLabel': {
      AppLanguage.ru: 'API-ключ OpenRouter',
      AppLanguage.uz: 'OpenRouter API kaliti',
    },
    'modelLabel': {
      AppLanguage.ru: 'Модель (напр. deepseek/deepseek-chat, google/gemini-2.5-flash)',
      AppLanguage.uz: 'Model (masalan, deepseek/deepseek-chat, google/gemini-2.5-flash)',
    },
    'apiKeyHint': {
      AppLanguage.ru: 'Ключ хранится только на этом устройстве. Получить можно на openrouter.ai',
      AppLanguage.uz: 'Kalit faqat shu qurilmada saqlanadi. openrouter.ai saytidan olish mumkin',
    },
    'generate': {
      AppLanguage.ru: 'Сгенерировать',
      AppLanguage.uz: 'Yaratish',
    },
    'questionEnabled': {
      AppLanguage.ru: 'Включён в тест',
      AppLanguage.uz: 'Testga kiritilgan',
    },
    'minActiveQuestions': {
      AppLanguage.ru: 'Минимум включённых вопросов',
      AppLanguage.uz: 'Kamida shuncha savol yoqilgan bo\'lishi kerak',
    },
    'themeLight': {
      AppLanguage.ru: 'Светлая тема',
      AppLanguage.uz: 'Yorug\' mavzu',
    },
    'themeDark': {
      AppLanguage.ru: 'Тёмная тема',
      AppLanguage.uz: 'Qorong\'i mavzu',
    },
    'importTest': {
      AppLanguage.ru: 'Импорт из Excel',
      AppLanguage.uz: 'Excel dan import',
    },
    'exportTest': {
      AppLanguage.ru: 'Экспорт в Excel',
      AppLanguage.uz: 'Excel ga eksport',
    },
    'importSuccess': {
      AppLanguage.ru: 'Тест импортирован',
      AppLanguage.uz: 'Test import qilindi',
    },
    'importError': {
      AppLanguage.ru: 'Не удалось импортировать файл',
      AppLanguage.uz: 'Faylni import qilib bo\'lmadi',
    },
    'exportSuccess': {
      AppLanguage.ru: 'Файл сохранён',
      AppLanguage.uz: 'Fayl saqlandi',
    },
    'exportError': {
      AppLanguage.ru: 'Не удалось сохранить файл',
      AppLanguage.uz: 'Faylni saqlab bo\'lmadi',
    },
  };

  static String t(String key, AppLanguage lang) {
    return _t[key]?[lang] ?? key;
  }
}
