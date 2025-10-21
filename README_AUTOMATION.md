
# 🤖 Автоматизация WindowsOptimizer

Полное руководство по настройке и использованию системы автоматизации для проекта WindowsOptimizer.

---

## 📑 Содержание

1. [Обзор](#обзор)
2. [Компоненты системы](#компоненты-системы)
3. [Требования](#требования)
4. [Установка](#установка)
5. [Использование](#использование)
6. [Структура файлов](#структура-файлов)
7. [GitHub Actions Workflows](#github-actions-workflows)
8. [PowerShell скрипты](#powershell-скрипты)
9. [Решение проблем](#решение-проблем)
10. [FAQ](#faq)

---

## 🎯 Обзор

Эта система автоматизации создана для упрощения процесса разработки и публикации изменений в проекте WindowsOptimizer. Она автоматически создаёт Pull Request при изменениях в документации и других ключевых файлах, генерирует CHANGELOG и упрощает процесс развёртывания.

### Основные возможности:

✅ Автоматическое создание Draft Pull Request  
✅ Мониторинг изменений в ключевых файлах  
✅ Генерация CHANGELOG с историей изменений  
✅ Интеграция с GitHub CLI для быстрого развёртывания  
✅ Цветной вывод и подробное логирование  
✅ Обработка ошибок и информативные сообщения  

---

## 🧩 Компоненты системы

### 1. GitHub Actions Workflows

#### `pull_request.yml`
- **Назначение**: Автоматическое создание PR при изменениях в документации
- **Триггер**: Push в ветки с паттерном `automation/*`
- **Мониторит**:
  - `README.md`
  - `.github/workflows/release.yml`
  - `RELEASE_TEMPLATE.md`
- **Результат**: Создаёт Draft PR с описанием изменений

#### `pr_with_changelog.yml`
- **Назначение**: Создание PR с автоматической генерацией CHANGELOG
- **Триггер**: Push в ветки с паттерном `automation/*`
- **Функции**:
  - Генерирует обновлённый CHANGELOG.md
  - Создаёт Draft PR со списком изменённых файлов
  - Добавляет метки для категоризации

### 2. PowerShell скрипты

#### `deploy.ps1`
- **Назначение**: Автоматизация процесса развёртывания
- **Функции**:
  - Проверка и установка необходимых инструментов (Git, GitHub CLI)
  - Клонирование репозитория
  - Создание ветки автоматизации
  - Копирование файлов
  - Коммит и push изменений
  - Создание Draft PR через GitHub CLI

### 3. Документация

#### `CHANGELOG.md`
- История изменений проекта
- Структурированный формат с версиями
- Автоматически обновляется при релизах

#### `README_AUTOMATION.md`
- Этот файл с полной документацией
- Инструкции по использованию
- Решение распространённых проблем

---

## 📋 Требования

### Обязательные инструменты:

1. **Git** (версия 2.0 или выше)
   - Скачать: https://git-scm.com/download/win
   - Проверка: `git --version`

2. **GitHub CLI** (gh)
   - Скачать: https://cli.github.com/
   - Проверка: `gh --version`
   - Или установка через скрипт (автоматически)

3. **PowerShell** (версия 5.1 или выше)
   - Встроен в Windows 10/11
   - Проверка: `$PSVersionTable.PSVersion`

### Учётная запись GitHub:

- Активная учётная запись GitHub
- Права на запись в репозиторий WindowsOptimizer
- Настроенная аутентификация через GitHub CLI

---

## 🚀 Установка

### Шаг 1: Подготовка инструментов

#### Установка Git (если не установлен):
```powershell
# Скачайте установщик с https://git-scm.com/download/win
# Или используйте winget:
winget install --id Git.Git -e --source winget
```

#### Установка GitHub CLI:
```powershell
# Автоматически через winget:
winget install --id GitHub.cli
```

#### Проверка установки:
```powershell
git --version
gh --version
```

### Шаг 2: Авторизация в GitHub CLI

```powershell
# Запустите процесс авторизации:
gh auth login

# Следуйте инструкциям:
# 1. Выберите GitHub.com
# 2. Выберите HTTPS
# 3. Выберите "Login with a web browser"
# 4. Скопируйте код и вставьте в браузере
```

### Шаг 3: Клонирование репозитория с автоматизацией

```powershell
# Создайте рабочий каталог:
mkdir C:\Projects
cd C:\Projects

# Скачайте файлы автоматизации:
# (получите их от администратора или из release)
```

### Шаг 4: Настройка файлов

Убедитесь, что у вас есть следующие файлы:
```
WindowsOptimizer_Automation/
├── .github/
│   └── workflows/
│       ├── pull_request.yml
│       └── pr_with_changelog.yml
├── deploy.ps1
├── CHANGELOG.md
└── README_AUTOMATION.md
```

---

## 💼 Использование

### Метод 1: Использование deploy.ps1 (Рекомендуется)

Это самый простой способ развернуть автоматизацию.

```powershell
# Перейдите в каталог с файлами автоматизации:
cd C:\Projects\WindowsOptimizer_Automation

# Запустите скрипт с параметрами по умолчанию:
.\deploy.ps1

# Или с пользовательскими параметрами:
.\deploy.ps1 -RepoUrl "https://github.com/YourUsername/YourRepo" -BranchName "automation/my-update"
```

#### Что делает скрипт:

1. ✅ Проверяет наличие Git
2. ✅ Проверяет наличие GitHub CLI (устанавливает при необходимости)
3. ✅ Проверяет авторизацию в GitHub
4. ✅ Создаёт временный рабочий каталог
5. ✅ Клонирует репозиторий
6. ✅ Создаёт новую ветку `automation/*`
7. ✅ Копирует файлы автоматизации
8. ✅ Создаёт коммит с изменениями
9. ✅ Отправляет изменения в GitHub
10. ✅ Создаёт Draft Pull Request

#### Параметры скрипта:

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `-RepoUrl` | URL GitHub репозитория | `https://github.com/Serg2206/WindowsOptimizer` |
| `-BranchName` | Имя ветки для автоматизации | `automation/update-docs` |

#### Примеры использования:

```powershell
# Базовое использование:
.\deploy.ps1

# С другим репозиторием:
.\deploy.ps1 -RepoUrl "https://github.com/MyOrg/MyProject"

# С пользовательским именем ветки:
.\deploy.ps1 -BranchName "automation/feature-update"

# Комбинация параметров:
.\deploy.ps1 -RepoUrl "https://github.com/MyOrg/Project" -BranchName "automation/v2-update"
```

### Метод 2: Ручная настройка

Если вы предпочитаете ручной контроль над процессом:

#### Шаг 1: Клонирование репозитория
```powershell
git clone https://github.com/Serg2206/WindowsOptimizer
cd WindowsOptimizer
```

#### Шаг 2: Создание ветки
```powershell
git checkout -b automation/manual-setup
```

#### Шаг 3: Копирование файлов
```powershell
# Создайте структуру каталогов:
mkdir -p .github/workflows

# Скопируйте файлы автоматизации:
Copy-Item "path\to\automation\files\*" -Destination . -Recurse
```

#### Шаг 4: Коммит и push
```powershell
git add .
git commit -m "chore: добавление автоматизации"
git push -u origin automation/manual-setup
```

#### Шаг 5: Создание PR
```powershell
gh pr create --title "Добавление автоматизации" --body "Настройка GitHub Actions" --draft
```

### Метод 3: Использование существующей ветки

Если ветка автоматизации уже существует:

```powershell
git checkout automation/update-docs
git pull origin automation/update-docs

# Внесите изменения в файлы
# ...

git add .
git commit -m "docs: обновление документации"
git push origin automation/update-docs

# GitHub Actions автоматически создаст PR!
```

---

## 📁 Структура файлов

### Полная структура проекта с автоматизацией:

```
WindowsOptimizer/
├── .github/
│   └── workflows/
│       ├── pull_request.yml          # Workflow для автоматического PR
│       ├── pr_with_changelog.yml     # Workflow с CHANGELOG
│       └── release.yml               # Workflow для релизов (если есть)
│
├── src/                               # Исходный код проекта
│   └── ...
│
├── docs/                              # Документация
│   └── ...
│
├── CHANGELOG.md                       # История изменений
├── README.md                          # Основной README проекта
├── README_AUTOMATION.md               # Документация по автоматизации
├── RELEASE_TEMPLATE.md                # Шаблон для релизов (если есть)
│
└── deploy.ps1                         # Скрипт развёртывания (хранится отдельно)
```

### Описание ключевых файлов:

#### `.github/workflows/pull_request.yml`
```yaml
name: Create Automated Pull Request
on:
  push:
    branches:
      - 'automation/*'
    paths:
      - 'README.md'
      - '.github/workflows/release.yml'
      - 'RELEASE_TEMPLATE.md'
```
**Когда срабатывает**: При push в ветку `automation/*` с изменениями в указанных файлах  
**Что делает**: Создаёт Draft PR в main с описанием изменений  
**Метки**: `automation`, `documentation`

#### `.github/workflows/pr_with_changelog.yml`
```yaml
name: Create PR with Changelog
on:
  push:
    branches:
      - 'automation/*'
```
**Когда срабатывает**: При любом push в ветку `automation/*`  
**Что делает**: Генерирует CHANGELOG.md и создаёт Draft PR  
**Метки**: `automation`, `changelog`, `release`

---

## ⚙️ GitHub Actions Workflows

### Как работают workflows?

1. **Триггер**: Вы делаете push в ветку с паттерном `automation/*`
2. **Проверка**: GitHub Actions проверяет, какие файлы изменились
3. **Выполнение**: Запускается соответствующий workflow
4. **Создание PR**: Автоматически создаётся Draft Pull Request

### Настройка прав доступа

Workflows уже настроены с необходимыми правами:
```yaml
permissions:
  contents: write        # Для чтения и записи файлов
  pull-requests: write   # Для создания PR
```

### Просмотр логов workflow:

1. Перейдите на GitHub в ваш репозиторий
2. Откройте вкладку "Actions"
3. Выберите нужный workflow run
4. Просмотрите детальные логи каждого шага

### Ручной запуск workflow (если настроено):

```yaml
# Добавьте в workflow для ручного запуска:
on:
  workflow_dispatch:
```

Затем на GitHub:
1. Вкладка "Actions"
2. Выберите workflow
3. Нажмите "Run workflow"

---

## 🔧 PowerShell скрипты

### deploy.ps1 - Подробное описание

#### Параметры:

```powershell
param(
    [string]$RepoUrl = "https://github.com/Serg2206/WindowsOptimizer",
    [string]$BranchName = "automation/update-docs"
)
```

#### Функции:

##### 1. Проверка инструментов
```powershell
# Проверяет наличие Git
try {
    $gitVersion = git --version
    Write-Success "Git установлен: $gitVersion"
} catch {
    Write-Error "Git не установлен!"
    exit 1
}
```

##### 2. Автоматическая установка GitHub CLI
```powershell
# Если GitHub CLI не установлен, пытается установить через winget
try {
    winget install --id GitHub.cli --silent
    Write-Success "GitHub CLI установлен!"
} catch {
    Write-Error "Не удалось установить GitHub CLI"
}
```

##### 3. Цветной вывод
```powershell
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { Write-ColorOutput "[✓] $1" "Green" }
function Write-Error { Write-ColorOutput "[✗] $1" "Red" }
function Write-Info { Write-ColorOutput "[i] $1" "Yellow" }
```

##### 4. Создание структуры
```powershell
# Создаёт временный рабочий каталог
$workDir = Join-Path $env:TEMP $projectName
New-Item -ItemType Directory -Path $workDir | Out-Null
```

##### 5. Git операции
```powershell
# Клонирование, создание ветки, коммит, push
git clone $RepoUrl .
git checkout -b $BranchName
git add .
git commit -m "chore: добавление автоматизации"
git push -u origin $BranchName
```

##### 6. Создание PR через GitHub CLI
```powershell
gh pr create `
    --title "feat: добавление системы автоматизации PR" `
    --body $prBody `
    --base main `
    --head $BranchName `
    --draft `
    --label "automation,enhancement"
```

#### Обработка ошибок:

Скрипт использует `$ErrorActionPreference = "Stop"` и блоки try-catch для перехвата ошибок:

```powershell
try {
    # Критическая операция
    git push -u origin $BranchName
    Write-Success "Успешно!"
} catch {
    Write-Error "Ошибка: $_"
    Write-Info "Попробуйте выполнить вручную"
    exit 1
}
```

---

## 🐛 Решение проблем

### Проблема 1: Git не установлен

**Симптомы:**
```
[✗] Git не установлен!
```

**Решение:**
1. Скачайте Git: https://git-scm.com/download/win
2. Установите с настройками по умолчанию
3. Перезапустите PowerShell
4. Проверьте: `git --version`

### Проблема 2: GitHub CLI не устанавливается автоматически

**Симптомы:**
```
[✗] Не удалось установить GitHub CLI автоматически
```

**Решение:**
1. Скачайте вручную: https://cli.github.com/
2. Установите MSI installer
3. Перезапустите PowerShell
4. Проверьте: `gh --version`

### Проблема 3: Ошибка авторизации в GitHub

**Симптомы:**
```
error: authentication required
```

**Решение:**
```powershell
# Выполните повторную авторизацию:
gh auth logout
gh auth login

# Выберите:
# - GitHub.com
# - HTTPS
# - Login with a web browser
```

### Проблема 4: Нет прав на создание PR

**Симптомы:**
```
[✗] Ошибка при создании PR: permission denied
```

**Решение:**
1. Убедитесь, что у вас есть права на запись в репозитории
2. Проверьте, что вы авторизованы под правильной учётной записью:
   ```powershell
   gh auth status
   ```
3. Если нужно, переключите учётную запись:
   ```powershell
   gh auth switch
   ```

### Проблема 5: Ошибка при push в репозиторий

**Симптомы:**
```
error: failed to push some refs to 'https://github.com/...'
```

**Решение:**
```powershell
# Проверьте, нет ли конфликтов:
git fetch origin
git status

# Если есть изменения на сервере:
git pull --rebase origin main
git push origin your-branch
```

### Проблема 6: Workflow не запускается

**Симптомы:**
- Push выполнен, но PR не создаётся автоматически

**Решение:**
1. Проверьте, что ветка имеет паттерн `automation/*`:
   ```powershell
   git branch  # Должно быть automation/something
   ```
2. Проверьте логи на GitHub:
   - Перейдите на вкладку "Actions"
   - Найдите workflow run
   - Проверьте ошибки

3. Убедитесь, что изменения в правильных файлах:
   - Для `pull_request.yml`: README.md, release.yml, RELEASE_TEMPLATE.md
   - Для `pr_with_changelog.yml`: любые файлы

### Проблема 7: PowerShell Execution Policy

**Симптомы:**
```
cannot be loaded because running scripts is disabled on this system
```

**Решение:**
```powershell
# Временно разрешить выполнение скриптов (для текущей сессии):
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Или постоянно (требует прав администратора):
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Проблема 8: Кодировка файлов (кириллица)

**Симптомы:**
- Кракозябры в коммитах или PR

**Решение:**
```powershell
# Настройте кодировку Git:
git config --global core.quotepath false
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8

# В PowerShell:
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

---

## ❓ FAQ

### Q1: Как часто можно использовать автоматизацию?

**A:** Без ограничений. Каждый push в ветку `automation/*` запускает workflow.

### Q2: Могу ли я изменить имя ветки?

**A:** Да, но убедитесь, что оно соответствует паттерну `automation/*`:
```powershell
.\deploy.ps1 -BranchName "automation/my-custom-name"
```

### Q3: Как удалить автоматизацию?

**A:** Удалите следующие файлы:
```powershell
rm -r .github/workflows/pull_request.yml
rm -r .github/workflows/pr_with_changelog.yml
rm CHANGELOG.md
rm README_AUTOMATION.md
```

### Q4: Можно ли использовать с другими репозиториями?

**A:** Да! Просто укажите другой URL:
```powershell
.\deploy.ps1 -RepoUrl "https://github.com/YourOrg/YourRepo"
```

### Q5: Как отредактировать сообщение PR?

**A:** 
1. После создания PR перейдите на GitHub
2. Откройте PR
3. Нажмите "Edit" на заголовке или описании
4. Внесите изменения

### Q6: Нужно ли объединять каждый автоматически созданный PR?

**A:** Нет. Draft PR создаются для предварительного просмотра. Объединяйте только те, которые содержат нужные изменения.

### Q7: Как настроить автоматическое объединение PR?

**A:** Измените workflow, удалив `draft: true`:
```yaml
# Вместо:
draft: true

# Используйте:
draft: false
```

**Внимание!** Будьте осторожны с автоматическим объединением.

### Q8: Можно ли добавить больше файлов для мониторинга?

**A:** Да! Отредактируйте `.github/workflows/pull_request.yml`:
```yaml
paths:
  - 'README.md'
  - '.github/workflows/release.yml'
  - 'RELEASE_TEMPLATE.md'
  - 'docs/**'           # Добавьте свои файлы
  - 'src/config.json'
```

### Q9: Как запустить скрипт без интернета?

**A:** Это невозможно, так как скрипт взаимодействует с GitHub. Но вы можете:
1. Клонировать репозиторий заранее
2. Работать локально
3. Push изменений при наличии интернета

### Q10: Как получить уведомления о созданных PR?

**A:** Настройте уведомления на GitHub:
1. Settings → Notifications
2. Включите "Participating" и "Watching"
3. Выберите "Pull Request reviews"

---

## 🔐 Безопасность

### Рекомендации по безопасности:

1. **Не храните токены в коде**
   - GitHub CLI использует безопасное хранилище
   - Токены не передаются в plaintext

2. **Используйте только доверенные репозитории**
   - Проверяйте URL перед клонированием
   - Не запускайте скрипты из ненадёжных источников

3. **Проверяйте права доступа**
   - Workflows имеют минимальные необходимые права
   - `contents: write` - только для файлов
   - `pull-requests: write` - только для создания PR

4. **Регулярно обновляйте инструменты**
   ```powershell
   winget upgrade --id Git.Git
   winget upgrade --id GitHub.cli
   ```

---

## 📞 Поддержка и контакты

### Нужна помощь?

1. **GitHub Issues**: https://github.com/Serg2206/WindowsOptimizer/issues
2. **Документация GitHub Actions**: https://docs.github.com/actions
3. **Документация GitHub CLI**: https://cli.github.com/manual/

### Внесение вклада

Если вы хотите улучшить автоматизацию:
1. Fork репозитория
2. Создайте feature branch
3. Внесите изменения
4. Создайте Pull Request

---

## 📝 История версий

| Версия | Дата | Изменения |
|--------|------|-----------|
| 1.0.0 | 2025-10-21 | Первый релиз автоматизации |

---

## 📄 Лицензия

Эта автоматизация распространяется под той же лицензией, что и основной проект WindowsOptimizer.

---

## 🎉 Заключение

Поздравляем! Теперь у вас есть полная система автоматизации для проекта WindowsOptimizer. 

### Основные преимущества:

✅ Экономия времени на рутинных задачах  
✅ Меньше ошибок благодаря автоматизации  
✅ Прозрачная история изменений через CHANGELOG  
✅ Удобный процесс code review через Draft PR  
✅ Простое развёртывание одним скриптом  

### Следующие шаги:

1. Запустите `.\deploy.ps1` для первого развёртывания
2. Проверьте созданный PR на GitHub
3. Внесите необходимые изменения
4. Объедините PR с основной веткой
5. Наслаждайтесь автоматизацией! 🚀

---

**Удачи в разработке!** 💻✨

---

*Документация актуальна на 21 октября 2025 года*
