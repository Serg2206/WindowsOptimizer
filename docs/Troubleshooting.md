
# 🛠️ Решение типичных проблем (Troubleshooting)

Эта страница поможет вам решить наиболее распространенные проблемы при использовании WindowsOptimizer.

---

## 🔴 Критические ошибки

### Ошибка: "Отказано в доступе" (Access Denied)

**Симптомы:**
```
Access to the path '...' is denied.
```

**Причины:**
1. Скрипт не запущен от имени администратора
2. Файлы заблокированы другими процессами
3. Антивирус блокирует доступ

**Решение:**

```powershell
# 1. Запустите PowerShell от имени администратора
# Нажмите Win + X → "Windows PowerShell (Администратор)"

# 2. Убедитесь, что у вас есть права
whoami /priv

# Должно показать "SeDebugPrivilege" и другие привилегии

# 3. Запустите скрипт правильно
cd C:\Tools\WindowsOptimizer
.\WindowsOptimizer.ps1

# 4. Если не помогает, закройте все программы и повторите
taskkill /f /im explorer.exe
Start-Process explorer.exe
.\WindowsOptimizer.ps1
```

**Если ошибка сохраняется:**
```powershell
# Проверьте, какие процессы блокируют файлы
# Скачайте и используйте утилиту Handle от Sysinternals
# https://docs.microsoft.com/sysinternals/downloads/handle

.\handle.exe C:\Windows\Temp
```

---

### Ошибка: "Не удается загрузить файл ... не подписан"

**Симптомы:**
```
File ... cannot be loaded because running scripts is disabled on this system.
```

**Причина:** Политика выполнения PowerShell запрещает запуск неподписанных скриптов.

**Решение 1: Временно разрешить выполнение (рекомендуется)**
```powershell
# Запустите PowerShell от имени администратора
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Затем запустите скрипт
.\WindowsOptimizer.ps1
```

**Решение 2: Изменить политику для текущего пользователя**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Подтвердите изменение
Y
```

**Решение 3: Запуск с параметром обхода политики**
```powershell
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Tools\WindowsOptimizer.ps1"
```

**Проверка текущей политики:**
```powershell
Get-ExecutionPolicy -List
```

---

### Ошибка: "Файл заблокирован антивирусом"

**Симптомы:**
- Скрипт не запускается
- Антивирус показывает предупреждение
- Файл автоматически удаляется после загрузки

**Решение:**

1. **Проверьте источник файла**
   - Убедитесь, что скачали из официального репозитория: https://github.com/Serg2206/WindowsOptimizer

2. **Добавьте в исключения антивируса**

   **Windows Defender:**
   ```powershell
   # Откройте PowerShell от имени администратора
   Add-MpPreference -ExclusionPath "C:\Tools\WindowsOptimizer"
   Add-MpPreference -ExclusionProcess "WindowsOptimizer.ps1"
   ```

   **Вручную (для любого антивируса):**
   - Откройте настройки антивируса
   - Найдите "Исключения" или "Exceptions"
   - Добавьте папку `C:\Tools\WindowsOptimizer`

3. **Проверьте файл на VirusTotal**
   - Перейдите: https://www.virustotal.com/
   - Загрузите `WindowsOptimizer.ps1` для сканирования
   - Убедитесь, что нет настоящих угроз

---

## ⚠️ Предупреждения и некритические ошибки

### Проблема: "Space Freed: -85.71 MB" (отрицательное значение)

**Симптомы:**
```
Space Freed: -85.71 MB
```

**Причина:** Во время работы скрипта Windows или другие программы создают новые файлы (обновления, антивирус, логи).

**Это нормально?** Да, если отрицательное значение небольшое (<500 MB).

**Решение:**

1. **Перед запуском закройте все программы**
   ```powershell
   # Закрыть все программы (осторожно!)
   Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Stop-Process -Force
   ```

2. **Временно остановите службы**
   ```powershell
   # Остановить Windows Update (на время очистки)
   Stop-Service -Name wuauserv -Force
   
   # Запустите скрипт
   .\WindowsOptimizer.ps1
   
   # Служба автоматически запустится скриптом
   ```

3. **Проверьте фоновые процессы**
   ```powershell
   # Найти процессы, создающие файлы
   Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10
   ```

4. **Проверьте систему на вирусы**
   ```powershell
   # Запустите полную проверку Windows Defender
   Start-MpScan -ScanType FullScan
   ```

---

### Проблема: Скрипт зависает на SFC (System File Check)

**Симптомы:**
- Скрипт останавливается на шаге "System File Check"
- Нет прогресса более 10 минут
- Процессор загружен на 100%

**Причина:** SFC проверяет целостность всех системных файлов Windows, что может занять 10-30 минут на медленных системах.

**Это нормально?** Да, если:
- CPU активен (проверьте диспетчер задач)
- Диск активен (мигает индикатор)
- Нет сообщений об ошибках

**Решение 1: Дождаться завершения**
```powershell
# Проверьте прогресс в диспетчере задач
# Ctrl+Shift+Esc → Подробности → sfc.exe
# Если CPU > 0% и Disk > 0%, процесс работает
```

**Решение 2: Отключить SFC в скрипте (для быстрых запусков)**
1. Откройте `WindowsOptimizer.ps1` в блокноте
2. Найдите строку: `sfc /scannow`
3. Закомментируйте ее: `# sfc /scannow`
4. Сохраните и запустите снова

**Решение 3: Запустить SFC отдельно в фоне**
```powershell
# Запустите SFC в отдельном окне
Start-Process powershell -ArgumentList "sfc /scannow" -Verb RunAs

# Запустите оптимизацию без SFC (измененный скрипт)
.\WindowsOptimizer.ps1
```

---

### Проблема: Оптимизация диска завершается с ошибкой

**Симптомы:**
```
Optimize-Volume : The storage optimizer could not complete the requested operation.
```

**Причина:**
1. Диск уже оптимизирован
2. SSD диск (не требует дефрагментации)
3. Недостаточно свободного места (<15%)

**Решение:**

```powershell
# Проверьте тип диска
Get-PhysicalDisk | Select-Object DeviceId, MediaType, HealthStatus

# Для SSD: выполните TRIM вместо дефрагментации
Optimize-Volume -DriveLetter C -ReTrim -Verbose

# Для HDD: проверьте свободное место
Get-PSDrive C | Select-Object Used,Free

# Если места мало (<15%), освободите его вручную
```

**Пропустить оптимизацию диска:**
```powershell
# Закомментируйте строку в скрипте:
# Optimize-Volume -DriveLetter C -Defrag
```

---

## 🟡 Проблемы производительности

### Проблема: Скрипт работает слишком долго (>15 минут)

**Причины:**
1. Медленный HDD диск
2. Много временных файлов (>10 GB)
3. SFC проверяет поврежденные файлы
4. Низкая производительность системы

**Диагностика:**

```powershell
# 1. Проверьте скорость диска
winsat disk -drive c

# 2. Проверьте объем временных файлов
$tempSize = (Get-ChildItem -Path $env:TEMP -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1GB
Write-Host "Temp folder size: $tempSize GB"

# 3. Проверьте загрузку CPU
Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 5
```

**Решение:**

1. **Отключите SFC (самая долгая операция)**
   - Откройте скрипт и закомментируйте `sfc /scannow`

2. **Запустите очистку без проверки диска**
   - Закомментируйте `Optimize-Volume`

3. **Очистите временные файлы вручную ДО запуска**
   ```powershell
   Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
   Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
   Clear-RecycleBin -Force
   ```

4. **Используйте облегченную версию скрипта** (только базовая очистка):
   ```powershell
   # Создайте новый скрипт WindowsOptimizer_Fast.ps1
   Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
   Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
   Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
   Clear-RecycleBin -Force -ErrorAction SilentlyContinue
   Write-Host "Fast cleanup completed!"
   ```

---

### Проблема: Система тормозит во время выполнения

**Причина:** Скрипт использует много ресурсов CPU и диска.

**Решение:**

```powershell
# Снизить приоритет процесса PowerShell
$process = Get-Process -Id $PID
$process.PriorityClass = "BelowNormal"

# Затем запустите скрипт
.\WindowsOptimizer.ps1
```

**Или создайте обертку:**
```powershell
# RunOptimizer_LowPriority.ps1
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File C:\Tools\WindowsOptimizer.ps1" -Verb RunAs -WindowStyle Normal -Wait -Priority BelowNormal
```

---

## 🔵 Проблемы с логами

### Проблема: Лог-файл не создается

**Причина:** Нет доступа к `C:\Windows\Temp` или лог отключен.

**Решение:**

```powershell
# Проверьте доступ к папке логов
Test-Path "C:\Windows\Temp"

# Проверьте права
icacls "C:\Windows\Temp"

# Создайте лог вручную
New-Item -Path "C:\Windows\Temp\WindowsOptimizer.log" -ItemType File -Force

# Запустите скрипт с перенаправлением вывода
.\WindowsOptimizer.ps1 | Tee-Object -FilePath "C:\Windows\Temp\WindowsOptimizer.log"
```

---

### Проблема: Лог-файл слишком большой (>100 MB)

**Решение:**

```powershell
# Очистить старый лог
Remove-Item "C:\Windows\Temp\WindowsOptimizer.log" -Force

# Или архивировать логи
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
Move-Item "C:\Windows\Temp\WindowsOptimizer.log" "C:\Tools\Logs\WindowsOptimizer_$timestamp.log"

# Удалить старые логи (старше 30 дней)
Get-ChildItem "C:\Tools\Logs" -Filter "*.log" | 
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | 
    Remove-Item -Force
```

---

## 🟢 Проблемы с автоматизацией

### Проблема: Запланированная задача не выполняется

**Причины:**
1. Компьютер выключен в момент запуска
2. Нет прав для выполнения
3. Задача отключена

**Диагностика:**

```powershell
# Проверить статус задачи
Get-ScheduledTask -TaskName "WindowsOptimizer*" | Select-Object TaskName,State,LastRunTime,LastTaskResult

# Просмотр истории выполнения
Get-ScheduledTask -TaskName "WindowsOptimizer Weekly" | Get-ScheduledTaskInfo
```

**Решение:**

```powershell
# 1. Включить задачу
Enable-ScheduledTask -TaskName "WindowsOptimizer Weekly"

# 2. Настроить запуск при пропуске
$task = Get-ScheduledTask -TaskName "WindowsOptimizer Weekly"
$settings = $task.Settings
$settings.StartWhenAvailable = $true
$settings.RunOnlyIfNetworkAvailable = $false
Set-ScheduledTask -TaskName "WindowsOptimizer Weekly" -Settings $settings

# 3. Тестовый запуск
Start-ScheduledTask -TaskName "WindowsOptimizer Weekly"
```

---

### Проблема: Задача запускается, но ничего не происходит

**Причина:** Неправильные параметры запуска.

**Решение:**

```powershell
# Проверьте параметры задачи
$task = Get-ScheduledTask -TaskName "WindowsOptimizer Weekly"
$task.Actions

# Пересоздайте задачу с правильными параметрами
Unregister-ScheduledTask -TaskName "WindowsOptimizer Weekly" -Confirm:$false

$action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Tools\WindowsOptimizer\WindowsOptimizer.ps1"

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Saturday -At 3:00AM

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 2)

Register-ScheduledTask `
    -TaskName "WindowsOptimizer Weekly" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings
```

---

## 🟣 Другие проблемы

### Проблема: Не удается скачать файл с GitHub

**Причины:**
1. GitHub недоступен
2. Файл удален или перемещен
3. Проблемы с интернет-соединением

**Решение:**

```powershell
# Проверьте доступность GitHub
Test-NetConnection -ComputerName github.com -Port 443

# Скачайте файл через PowerShell
$url = "https://github.com/Serg2206/WindowsOptimizer/releases/download/v1.0.0/WindowsOptimizer.ps1"
$output = "C:\Tools\WindowsOptimizer.ps1"
Invoke-WebRequest -Uri $url -OutFile $output

# Проверьте, что файл скачался
Test-Path $output
```

**Альтернативный способ:**
```powershell
# Клонировать через Git
git clone https://github.com/Serg2206/WindowsOptimizer.git C:\Tools\WindowsOptimizer
```

---

### Проблема: После оптимизации система работает хуже

**Причины:**
1. Удалены нужные временные файлы
2. Очищен prefetch (программы запускаются медленнее в первый раз)
3. Проблемы с системными файлами после SFC

**Решение:**

1. **Восстановите систему из точки восстановления**
   ```powershell
   # Откройте Recovery
   rstrui.exe
   
   # Выберите точку восстановления "Перед WindowsOptimizer"
   ```

2. **Дайте системе время на индексацию**
   - Prefetch восстановится после нескольких запусков программ
   - Подождите 1-2 часа

3. **Проверьте целостность системы**
   ```powershell
   # Проверка образа системы
   DISM /Online /Cleanup-Image /RestoreHealth
   
   # Проверка системных файлов
   sfc /scannow
   ```

4. **Перезагрузите систему**
   ```powershell
   Restart-Computer -Force
   ```

---

### Проблема: PowerShell показывает красный текст (ошибки)

**Это нормально?** Да, если это предупреждения о недоступных файлах.

**Как отличить критические ошибки:**
- 🔴 Красный текст + "Error" = критическая ошибка
- 🟡 Красный текст + "Access denied" = предупреждение (файл используется)
- 🟢 Красный текст + "Not found" = нормально (файл уже удален)

**Подавить некритические ошибки:**
```powershell
# В скрипте измените:
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# SilentlyContinue подавляет ошибки "файл не найден" и "доступ запрещен"
```

---

## 📞 Как получить помощь

Если проблема не решена:

1. **Соберите диагностическую информацию**
   ```powershell
   # Создайте отчет
   $report = @"
   === System Info ===
   OS: $((Get-CimInstance Win32_OperatingSystem).Caption)
   Version: $((Get-CimInstance Win32_OperatingSystem).Version)
   PowerShell: $($PSVersionTable.PSVersion)
   
   === Disk Info ===
   $(Get-PSDrive C | Select-Object Used,Free | Out-String)
   
   === Last Error ===
   $($Error[0] | Out-String)
   
   === Log Content (last 50 lines) ===
   $(Get-Content "C:\Windows\Temp\WindowsOptimizer.log" -Tail 50 -ErrorAction SilentlyContinue)
   "@
   
   $report | Out-File "$env:USERPROFILE\Desktop\WindowsOptimizer_Report.txt"
   Write-Host "Report saved to Desktop"
   ```

2. **Создайте Issue на GitHub**
   - Перейдите: https://github.com/Serg2206/WindowsOptimizer/issues
   - Нажмите "New Issue"
   - Опишите проблему и прикрепите отчет

3. **Проверьте существующие Issues**
   - Возможно, проблема уже известна и есть решение

---

## 🔗 Дополнительные ресурсы

- [FAQ - Часто задаваемые вопросы](FAQ.md)
- [Руководство по использованию](Usage.md)
- [Установка](Installation.md)
- [GitHub Issues](https://github.com/Serg2206/WindowsOptimizer/issues)

---

**Вернуться к:** [Главная страница Wiki](Home.md)
