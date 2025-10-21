
# 📚 Wiki документация WindowsOptimizer

Добро пожаловать в Wiki-документацию проекта WindowsOptimizer!

## 📖 Содержание

- **[Home](Home.md)** - Главная страница Wiki с обзором проекта
- **[Installation](Installation.md)** - Подробная инструкция по установке и настройке
- **[Usage](Usage.md)** - Детальные примеры использования с различными сценариями
- **[FAQ](FAQ.md)** - Расширенный список часто задаваемых вопросов
- **[Troubleshooting](Troubleshooting.md)** - Решение типичных проблем

## 🚀 Быстрый старт

1. Перейдите на страницу [Installation](Installation.md) для установки
2. Изучите [Usage](Usage.md) для практических примеров
3. Посетите [FAQ](FAQ.md) для ответов на частые вопросы

## 🌐 Как настроить Wiki на GitHub

### Вариант 1: Использование GitHub Wiki (Рекомендуется)

GitHub Wiki — это встроенная функция для создания документации вашего проекта.

#### Шаги настройки:

1. **Включите Wiki в репозитории**
   - Откройте ваш репозиторий на GitHub: https://github.com/Serg2206/WindowsOptimizer
   - Перейдите в **Settings** (Настройки)
   - Прокрутите вниз до раздела **Features** (Функции)
   - Поставьте галочку **Wikis**

2. **Перейдите в Wiki**
   - Вернитесь на главную страницу репозитория
   - Нажмите на вкладку **Wiki** (в верхнем меню рядом с Issues, Pull requests)

3. **Создайте главную страницу**
   - GitHub автоматически предложит создать главную страницу
   - Нажмите **Create the first page**
   - Скопируйте содержимое файла `docs/Home.md` в редактор
   - Нажмите **Save Page**

4. **Добавьте остальные страницы**
   - Нажмите **New Page** (справа вверху)
   - Создайте страницу с названием `Installation`
   - Скопируйте содержимое `docs/Installation.md`
   - Повторите для страниц: `Usage`, `FAQ`, `Troubleshooting`

5. **Настройте боковое меню (Sidebar)**
   - В Wiki нажмите **Add a custom sidebar**
   - Добавьте навигацию:
     ```markdown
     ### 📚 Документация
     * [Главная](Home)
     * [Установка](Installation)
     * [Использование](Usage)
     * [FAQ](FAQ)
     * [Решение проблем](Troubleshooting)
     
     ### 🔗 Ссылки
     * [GitHub Repo](https://github.com/Serg2206/WindowsOptimizer)
     * [Releases](https://github.com/Serg2206/WindowsOptimizer/releases)
     * [Issues](https://github.com/Serg2206/WindowsOptimizer/issues)
     ```
   - Нажмите **Save Page**

6. **Готово!** Теперь Wiki доступно по адресу:
   ```
   https://github.com/Serg2206/WindowsOptimizer/wiki
   ```

---

### Вариант 2: Использование GitHub Pages (Альтернатива)

GitHub Pages позволяет создать полноценный сайт документации из файлов Markdown.

#### Шаги настройки:

1. **Создайте файл конфигурации Jekyll**
   
   Создайте файл `docs/_config.yml`:
   ```yaml
   theme: jekyll-theme-cayman
   title: WindowsOptimizer
   description: Официальная документация WindowsOptimizer
   ```

2. **Создайте индексную страницу**
   
   Переименуйте `docs/Home.md` в `docs/index.md` (или скопируйте содержимое).

3. **Включите GitHub Pages**
   - Откройте **Settings** репозитория
   - Прокрутите до раздела **Pages**
   - В разделе **Source** выберите:
     - Branch: `main`
     - Folder: `/docs`
   - Нажмите **Save**

4. **Подождите несколько минут**
   - GitHub автоматически построит сайт
   - Сайт будет доступен по адресу:
     ```
     https://Serg2206.github.io/WindowsOptimizer/
     ```

5. **Настройте навигацию**
   
   Создайте файл `docs/_layouts/default.html` для кастомной навигации (опционально).

---

### Вариант 3: Документация в папке docs (Текущий вариант)

Если не хотите использовать Wiki или Pages, можно оставить документацию в папке `docs/` репозитория.

**Преимущества:**
- Документация версионируется вместе с кодом
- Легко редактировать через Pull Request
- Доступна в любом GitHub клиенте

**Недостатки:**
- Нет встроенной навигации
- Пользователи должны вручную открывать файлы

**Как использовать:**
- Пользователи открывают файлы напрямую:
  - https://github.com/Serg2206/WindowsOptimizer/blob/main/docs/Home.md
  - https://github.com/Serg2206/WindowsOptimizer/blob/main/docs/Installation.md
  - и т.д.

---

## 📝 Рекомендации по использованию

### Для проекта WindowsOptimizer рекомендуется:

1. **GitHub Wiki** (Вариант 1) — для простоты и быстрой настройки
   - ✅ Простая навигация
   - ✅ Встроенный поиск
   - ✅ Боковое меню
   - ✅ Не засоряет основной репозиторий

2. **GitHub Pages** (Вариант 2) — если нужен красивый сайт
   - ✅ Профессиональный вид
   - ✅ Кастомный дизайн
   - ✅ SEO оптимизация
   - ❌ Требует больше настройки

3. **Папка docs/** (Вариант 3) — для версионирования документации
   - ✅ Версионируется с кодом
   - ✅ Легко редактировать через PR
   - ❌ Нет навигации

---

## 🔄 Обновление документации

### Если используете GitHub Wiki:

1. Клонируйте Wiki локально:
   ```bash
   git clone https://github.com/Serg2206/WindowsOptimizer.wiki.git
   ```

2. Редактируйте файлы:
   ```bash
   cd WindowsOptimizer.wiki
   # Отредактируйте .md файлы
   ```

3. Закоммитьте и запушьте:
   ```bash
   git add .
   git commit -m "Update documentation"
   git push origin master
   ```

### Если используете GitHub Pages:

1. Отредактируйте файлы в папке `docs/`
2. Закоммитьте изменения:
   ```bash
   git add docs/
   git commit -m "Update documentation"
   git push origin main
   ```

3. GitHub автоматически пересоберет сайт

---

## 📧 Контакты

Если у вас есть вопросы по документации:
- Создайте [Issue на GitHub](https://github.com/Serg2206/WindowsOptimizer/issues)
- Изучите [FAQ](FAQ.md)

---

## 📄 Лицензия

Документация распространяется под лицензией [MIT License](../LICENSE), как и сам проект.

---

**Следующий шаг:** Выберите один из вариантов выше и настройте Wiki для вашего проекта!
