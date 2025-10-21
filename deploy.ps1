
<#
.SYNOPSIS
    Скрипт автоматического развёртывания для WindowsOptimizer
    
.DESCRIPTION
    Этот скрипт автоматизирует процесс создания Pull Request для проекта WindowsOptimizer.
    Он создаёт необходимую структуру каталогов, копирует файлы, инициализирует Git репозиторий
    и создаёт draft PR через GitHub CLI.
    
.PARAMETER RepoUrl
    URL GitHub репозитория (по умолчанию: https://github.com/Serg2206/WindowsOptimizer)
    
.PARAMETER BranchName
    Имя ветки для автоматизации (по умолчанию: automation/update-docs)
    
.EXAMPLE
    .\deploy.ps1
    
.EXAMPLE
    .\deploy.ps1 -RepoUrl "https://github.com/username/repo" -BranchName "automation/custom-branch"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$RepoUrl = "https://github.com/Serg2206/WindowsOptimizer",
    
    [Parameter(Mandatory=$false)]
    [string]$BranchName = "automation/update-docs"
)

# Установка режима остановки при ошибках
$ErrorActionPreference = "Stop"

# Цветной вывод
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Логирование
function Write-Step {
    param([string]$Message)
    Write-ColorOutput "`n[STEP] $Message" "Cyan"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[✓] $Message" "Green"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[✗] $Message" "Red"
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput "[i] $Message" "Yellow"
}

# Проверка наличия Git
Write-Step "Проверка установки Git..."
try {
    $gitVersion = git --version
    Write-Success "Git установлен: $gitVersion"
} catch {
    Write-Error "Git не установлен!"
    Write-Info "Скачайте и установите Git с https://git-scm.com/download/win"
    exit 1
}

# Проверка наличия GitHub CLI
Write-Step "Проверка установки GitHub CLI..."
try {
    $ghVersion = gh --version
    Write-Success "GitHub CLI установлен: $($ghVersion[0])"
} catch {
    Write-Error "GitHub CLI не установлен!"
    Write-Info "Устанавливаю GitHub CLI через winget..."
    
    try {
        winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
        Write-Success "GitHub CLI успешно установлен!"
        Write-Info "Пожалуйста, перезапустите PowerShell и запустите скрипт снова."
        exit 0
    } catch {
        Write-Error "Не удалось установить GitHub CLI автоматически."
        Write-Info "Установите вручную: https://cli.github.com/"
        exit 1
    }
}

# Проверка авторизации в GitHub CLI
Write-Step "Проверка авторизации в GitHub..."
try {
    $ghAuth = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Info "Требуется авторизация в GitHub CLI..."
        gh auth login
    } else {
        Write-Success "Вы авторизованы в GitHub CLI"
    }
} catch {
    Write-Error "Ошибка при проверке авторизации!"
    Write-Info "Выполните команду: gh auth login"
    exit 1
}

# Определение путей
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectName = "WindowsOptimizer_Automation"
$workDir = Join-Path $env:TEMP $projectName

Write-Step "Создание рабочего каталога..."
if (Test-Path $workDir) {
    Write-Info "Каталог существует, очищаю..."
    Remove-Item -Path $workDir -Recurse -Force
}
New-Item -ItemType Directory -Path $workDir | Out-Null
Write-Success "Рабочий каталог создан: $workDir"

# Клонирование репозитория
Write-Step "Клонирование репозитория..."
try {
    Set-Location $workDir
    git clone $RepoUrl .
    Write-Success "Репозиторий успешно склонирован"
} catch {
    Write-Error "Ошибка при клонировании репозитория: $_"
    exit 1
}

# Создание новой ветки
Write-Step "Создание ветки автоматизации..."
try {
    git checkout -b $BranchName
    Write-Success "Ветка '$BranchName' создана"
} catch {
    Write-Error "Ошибка при создании ветки: $_"
    exit 1
}

# Создание структуры каталогов
Write-Step "Создание структуры каталогов..."
$directories = @(
    ".github\workflows"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $workDir $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Success "Создан каталог: $dir"
    }
}

# Копирование файлов автоматизации
Write-Step "Копирование файлов автоматизации..."
$filesToCopy = @{
    ".github\workflows\pull_request.yml" = ".github\workflows\pull_request.yml"
    ".github\workflows\pr_with_changelog.yml" = ".github\workflows\pr_with_changelog.yml"
    "CHANGELOG.md" = "CHANGELOG.md"
    "README_AUTOMATION.md" = "README_AUTOMATION.md"
}

foreach ($file in $filesToCopy.Keys) {
    $sourcePath = Join-Path $scriptDir $file
    $destPath = Join-Path $workDir $filesToCopy[$file]
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Success "Скопирован: $file"
    } else {
        Write-Info "Файл не найден (будет пропущен): $file"
    }
}

# Создание примера README.md если его нет
if (-not (Test-Path (Join-Path $workDir "README.md"))) {
    Write-Step "Создание README.md..."
    @"
# WindowsOptimizer

Утилита для оптимизации Windows системы.

## 🚀 Возможности
- Автоматическая очистка системы
- Оптимизация производительности
- Управление службами

## 📋 Требования
- Windows 10/11
- PowerShell 5.1 или выше

## 📦 Установка
```powershell
# Клонирование репозитория
git clone $RepoUrl
```

## 🤖 Автоматизация
Подробная инструкция по использованию автоматизации доступна в [README_AUTOMATION.md](README_AUTOMATION.md)

"@ | Out-File -FilePath (Join-Path $workDir "README.md") -Encoding UTF8
    Write-Success "README.md создан"
}

# Коммит изменений
Write-Step "Коммит изменений..."
try {
    git config user.name "Automation Script"
    git config user.email "automation@windowsoptimizer.local"
    
    git add .
    git commit -m "chore: добавление автоматизации для создания PR

- Добавлены GitHub Actions workflows
- Создан CHANGELOG.md
- Добавлена документация по автоматизации
- Настроен deploy.ps1 скрипт"
    
    Write-Success "Изменения закоммичены"
} catch {
    Write-Error "Ошибка при коммите: $_"
    exit 1
}

# Отправка в удалённый репозиторий
Write-Step "Отправка изменений в удалённый репозиторий..."
try {
    git push -u origin $BranchName
    Write-Success "Изменения отправлены в ветку '$BranchName'"
} catch {
    Write-Error "Ошибка при отправке в репозиторий: $_"
    Write-Info "Убедитесь, что у вас есть права на запись в репозиторий"
    exit 1
}

# Создание Pull Request
Write-Step "Создание Draft Pull Request..."
try {
    $prBody = @"
## 🤖 Автоматическое обновление системы автоматизации

Этот PR добавляет автоматизацию для проекта WindowsOptimizer.

### 📋 Что включено:
- ✅ GitHub Actions workflows для автоматического создания PR
- ✅ CHANGELOG.md с историей изменений
- ✅ README_AUTOMATION.md с подробной инструкцией
- ✅ PowerShell скрипт deploy.ps1 для развёртывания

### 🔧 Workflows:
1. **pull_request.yml** - Автоматически создаёт PR при изменении документации
2. **pr_with_changelog.yml** - Создаёт PR с обновлённым CHANGELOG

### 📝 Следующие шаги:
1. Проверьте все файлы автоматизации
2. Убедитесь, что workflows настроены корректно
3. Прочитайте README_AUTOMATION.md для инструкций
4. Утвердите и объедините этот PR

---
🚀 Создано автоматически через deploy.ps1
"@

    gh pr create `
        --title "feat: добавление системы автоматизации PR" `
        --body $prBody `
        --base main `
        --head $BranchName `
        --draft `
        --label "automation,enhancement"
    
    Write-Success "Draft Pull Request успешно создан!"
} catch {
    Write-Error "Ошибка при создании PR: $_"
    Write-Info "Вы можете создать PR вручную на GitHub"
    exit 1
}

# Финальное сообщение
Write-ColorOutput "`n========================================" "Green"
Write-ColorOutput "✅ РАЗВЁРТЫВАНИЕ ЗАВЕРШЕНО УСПЕШНО!" "Green"
Write-ColorOutput "========================================`n" "Green"

Write-Info "Что дальше?"
Write-Host "1. Перейдите на GitHub и проверьте созданный Draft PR" -ForegroundColor White
Write-Host "2. Проверьте файлы в ветке '$BranchName'" -ForegroundColor White
Write-Host "3. Прочитайте README_AUTOMATION.md для дальнейших инструкций" -ForegroundColor White
Write-Host "4. Утвердите и объедините PR с основной веткой" -ForegroundColor White

Write-ColorOutput "`n🎉 Автоматизация настроена и готова к использованию!" "Cyan"

# Открытие браузера с PR (опционально)
$openBrowser = Read-Host "`nОткрыть PR в браузере? (y/n)"
if ($openBrowser -eq 'y') {
    gh pr view --web
}

# Возврат в исходный каталог
Set-Location $scriptDir
