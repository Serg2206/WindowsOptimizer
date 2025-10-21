
# 📥 Установка и настройка WindowsOptimizer

## Системные требования

### Минимальные требования
- **Операционная система:** Windows 10 (версия 1809 или новее) или Windows 11
- **PowerShell:** Версия 5.1 или выше
- **Права доступа:** Администратор системы
- **Свободное место:** Минимум 100 MB для работы скрипта
- **Оперативная память:** Минимум 4 GB

### Рекомендуемые требования
- **Операционная система:** Windows 11 (последняя версия)
- **PowerShell:** Версия 7.x
- **Свободное место:** 500 MB или более
- **Оперативная память:** 8 GB или более

## Способы установки

### Способ 1: Загрузка из GitHub Releases (Рекомендуется)

1. **Перейдите на страницу релизов**
   - Откройте браузер и перейдите: https://github.com/Serg2206/WindowsOptimizer/releases
   - Найдите последний релиз (например, `v1.0.0`)

2. **Скачайте скрипт**
   - Нажмите на файл `WindowsOptimizer.ps1` в разделе Assets
   - Сохраните файл в удобную папку (например, `C:\Tools\`)

3. **Разблокируйте файл**
   - Щелкните правой кнопкой мыши на скачанном файле
   - Выберите "Свойства"
   - Внизу поставьте галочку "Разблокировать"
   - Нажмите "Применить" и "OK"

### Способ 2: Клонирование репозитория через Git

```powershell
# Установите Git, если его нет
# Скачайте с https://git-scm.com/download/win

# Откройте PowerShell и выполните
cd C:\Tools
git clone https://github.com/Serg2206/WindowsOptimizer.git
cd WindowsOptimizer
```

### Способ 3: Загрузка ZIP-архива

1. Перейдите на главную страницу репозитория: https://github.com/Serg2206/WindowsOptimizer
2. Нажмите зеленую кнопку "Code" → "Download ZIP"
3. Распакуйте архив в `C:\Tools\WindowsOptimizer`
4. Разблокируйте файл `WindowsOptimizer.ps1` (см. Способ 1, шаг 3)

## Проверка установки PowerShell

```powershell
# Проверьте версию PowerShell
$PSVersionTable.PSVersion

# Должно показать версию 5.1 или выше
# Например:
# Major  Minor  Build  Revision
# -----  -----  -----  --------
# 5      1      19041  1682
```

### Обновление PowerShell (опционально)

Если у вас PowerShell 5.1 и вы хотите обновиться до 7.x:

```powershell
# Установка PowerShell 7
winget install Microsoft.PowerShell

# Или скачайте с https://github.com/PowerShell/PowerShell/releases
```

## Настройка политики выполнения

По умолчанию Windows блокирует выполнение скриптов. Необходимо временно изменить политику:

### Вариант 1: Изменить политику для текущего пользователя

```powershell
# Запустите PowerShell от имени администратора
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Подтвердите изменение, введя 'Y'
```

### Вариант 2: Разовое выполнение без изменения политики

```powershell
# Запустите скрипт с обходом политики
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Tools\WindowsOptimizer.ps1"
```

## Проверка целостности файла (опционально)

Для проверки, что файл не был изменен при скачивании:

```powershell
# Вычислите хэш-сумму файла
Get-FileHash -Path "C:\Tools\WindowsOptimizer.ps1" -Algorithm SHA256

# Сравните с хэшем на странице релиза GitHub
```

## Подготовка к запуску

### 1. Закройте ненужные программы
Перед запуском закройте все важные приложения, чтобы избежать потери данных.

### 2. Создайте точку восстановления системы

```powershell
# Откройте PowerShell от имени администратора
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Перед запуском WindowsOptimizer" -RestorePointType "MODIFY_SETTINGS"
```

Или вручную:
1. Нажмите `Win + X` → "Система"
2. Выберите "Защита системы"
3. Нажмите "Создать"
4. Введите описание: "Перед WindowsOptimizer"
5. Нажмите "Создать"

### 3. Проверьте свободное место на диске C:

```powershell
Get-PSDrive C | Select-Object Used,Free
```

## Первый запуск

### Запуск через GUI

1. Найдите файл `WindowsOptimizer.ps1` в проводнике
2. Щелкните правой кнопкой мыши → "Запуск от имени администратора"
3. Если появится запрос UAC, нажмите "Да"

### Запуск через PowerShell

```powershell
# Откройте PowerShell от имени администратора
cd C:\Tools\WindowsOptimizer
.\WindowsOptimizer.ps1
```

## Автоматический запуск (опционально)

### Создание ярлыка для быстрого запуска

1. Щелкните правой кнопкой на рабочем столе → "Создать" → "Ярлык"
2. Введите в поле "Расположение объекта":
   ```
   PowerShell.exe -ExecutionPolicy Bypass -File "C:\Tools\WindowsOptimizer.ps1"
   ```
3. Нажмите "Далее"
4. Введите имя: "WindowsOptimizer"
5. Нажмите "Готово"
6. Щелкните правой кнопкой на ярлыке → "Свойства" → "Дополнительно"
7. Поставьте галочку "Запуск от имени администратора"

### Добавление в планировщик задач (еженедельный запуск)

```powershell
# Создание задачи на еженедельный запуск (каждую субботу в 2:00)
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File C:\Tools\WindowsOptimizer.ps1"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Saturday -At 2:00AM
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName "WindowsOptimizer Weekly" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
```

## Удаление (деинсталляция)

Если вы хотите удалить скрипт:

1. **Удалить файлы**
   ```powershell
   Remove-Item -Path "C:\Tools\WindowsOptimizer" -Recurse -Force
   ```

2. **Удалить запланированную задачу (если создавали)**
   ```powershell
   Unregister-ScheduledTask -TaskName "WindowsOptimizer Weekly" -Confirm:$false
   ```

3. **Восстановить политику выполнения (опционально)**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
   ```

## Обновление

### Обновление до новой версии

1. Перейдите на страницу релизов: https://github.com/Serg2206/WindowsOptimizer/releases
2. Скачайте последнюю версию
3. Замените старый файл `WindowsOptimizer.ps1` новым

### Через Git (если клонировали репозиторий)

```powershell
cd C:\Tools\WindowsOptimizer
git pull origin main
```

## Проблемы при установке

Если возникли проблемы, см. страницу [Troubleshooting](Troubleshooting.md).

## Дополнительные ресурсы

- [Руководство по использованию](Usage.md)
- [FAQ - Часто задаваемые вопросы](FAQ.md)
- [Решение проблем](Troubleshooting.md)
- [GitHub Issues](https://github.com/Serg2206/WindowsOptimizer/issues)

---

**Следующий шаг:** [Руководство по использованию →](Usage.md)
