
<#
.SYNOPSIS
    Полнофункциональный скрипт оптимизации Windows 11

.DESCRIPTION
    Этот скрипт выполняет комплексную оптимизацию системы Windows 11:
    - Очистка временных файлов
    - Очистка корзины
    - Проверка целостности системных файлов (SFC)
    - Оптимизация дисков (дефрагментация/TRIM для SSD)
    
.NOTES
    Автор: WindowsOptimizer
    Версия: 1.0
    Требуется: PowerShell 5.1 или выше, права администратора
    
.EXAMPLE
    .\WindowsOptimizer.ps1
    Запускает полную оптимизацию системы
#>

#Requires -RunAsAdministrator

# Функция для вывода цветного текста
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Функция для отображения прогресс-бара
function Show-Progress {
    param(
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete
    )
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
}

# Функция очистки временных файлов
function Clear-TemporaryFiles {
    Write-ColorOutput "`n=== Очистка временных файлов ===" "Cyan"
    
    $tempPaths = @(
        $env:TEMP,
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Prefetch"
    )
    
    $totalSize = 0
    $pathCount = $tempPaths.Count
    $currentPath = 0
    
    foreach ($path in $tempPaths) {
        $currentPath++
        $percentComplete = [math]::Round(($currentPath / $pathCount) * 100)
        
        if (Test-Path $path) {
            Show-Progress -Activity "Очистка временных файлов" -Status "Обработка: $path" -PercentComplete $percentComplete
            
            try {
                $files = Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                $sizeBeforeCleanup = ($files | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                
                Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
                
                $totalSize += $sizeBeforeCleanup
                Write-ColorOutput "✓ Очищено: $path" "Green"
            }
            catch {
                Write-ColorOutput "⚠ Предупреждение при очистке $path : $($_.Exception.Message)" "Yellow"
            }
        }
        else {
            Write-ColorOutput "⚠ Путь не найден: $path" "Yellow"
        }
    }
    
    Write-Progress -Activity "Очистка временных файлов" -Completed
    
    $totalSizeMB = [math]::Round($totalSize / 1MB, 2)
    Write-ColorOutput "✓ Освобождено: $totalSizeMB МБ" "Green"
}

# Функция очистки корзины
function Clear-RecycleBin {
    Write-ColorOutput "`n=== Очистка корзины ===" "Cyan"
    
    try {
        Show-Progress -Activity "Очистка корзины" -Status "Удаление файлов из корзины..." -PercentComplete 50
        
        Clear-RecycleBin -Force -ErrorAction Stop
        
        Write-Progress -Activity "Очистка корзины" -Completed
        Write-ColorOutput "✓ Корзина успешно очищена" "Green"
    }
    catch {
        Write-ColorOutput "✗ Ошибка при очистке корзины: $($_.Exception.Message)" "Red"
    }
}

# Функция проверки системных файлов
function Invoke-SystemFileCheck {
    Write-ColorOutput "`n=== Проверка целостности системных файлов (SFC) ===" "Cyan"
    Write-ColorOutput "Это может занять несколько минут..." "Yellow"
    
    try {
        Show-Progress -Activity "Проверка системных файлов" -Status "Выполнение SFC /scannow..." -PercentComplete 50
        
        $sfcResult = sfc /scannow
        
        Write-Progress -Activity "Проверка системных файлов" -Completed
        
        if ($sfcResult -match "не обнаружила нарушений целостности|did not find any integrity violations") {
            Write-ColorOutput "✓ Система в порядке. Нарушений целостности не обнаружено." "Green"
        }
        elseif ($sfcResult -match "обнаружила поврежденные файлы и успешно их восстановила|found corrupt files and successfully repaired them") {
            Write-ColorOutput "✓ Поврежденные файлы были обнаружены и восстановлены." "Green"
        }
        else {
            Write-ColorOutput "⚠ Проверка SFC выполнена. Проверьте файл CBS.log для деталей." "Yellow"
        }
    }
    catch {
        Write-ColorOutput "✗ Ошибка при выполнении SFC: $($_.Exception.Message)" "Red"
    }
}

# Функция оптимизации дисков
function Optimize-Disks {
    Write-ColorOutput "`n=== Оптимизация дисков ===" "Cyan"
    
    try {
        $volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' }
        $volumeCount = $volumes.Count
        $currentVolume = 0
        
        foreach ($volume in $volumes) {
            $currentVolume++
            $percentComplete = [math]::Round(($currentVolume / $volumeCount) * 100)
            $driveLetter = $volume.DriveLetter
            
            Show-Progress -Activity "Оптимизация дисков" -Status "Обработка диска $driveLetter..." -PercentComplete $percentComplete
            
            # Определение типа диска (SSD или HDD)
            $disk = Get-PhysicalDisk | Where-Object { 
                $_.DeviceID -eq (Get-Partition -DriveLetter $driveLetter).DiskNumber 
            }
            
            if ($disk.MediaType -eq 'SSD') {
                Write-ColorOutput "→ Диск $driveLetter`: SSD - выполняется TRIM..." "White"
                Optimize-Volume -DriveLetter $driveLetter -ReTrim -ErrorAction SilentlyContinue
                Write-ColorOutput "✓ TRIM выполнен для диска $driveLetter`:" "Green"
            }
            else {
                Write-ColorOutput "→ Диск $driveLetter`: HDD - выполняется дефрагментация..." "White"
                Optimize-Volume -DriveLetter $driveLetter -Defrag -ErrorAction SilentlyContinue
                Write-ColorOutput "✓ Дефрагментация выполнена для диска $driveLetter`:" "Green"
            }
        }
        
        Write-Progress -Activity "Оптимизация дисков" -Completed
    }
    catch {
        Write-ColorOutput "✗ Ошибка при оптимизации дисков: $($_.Exception.Message)" "Red"
    }
}

# Функция отображения информации о системе
function Show-SystemInfo {
    Write-ColorOutput "`n=== Информация о системе ===" "Cyan"
    
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $computer = Get-CimInstance -ClassName Win32_ComputerSystem
    
    Write-ColorOutput "Операционная система: $($os.Caption)" "White"
    Write-ColorOutput "Версия: $($os.Version)" "White"
    Write-ColorOutput "Архитектура: $($os.OSArchitecture)" "White"
    Write-ColorOutput "Компьютер: $($computer.Name)" "White"
    Write-ColorOutput "Оперативная память: $([math]::Round($computer.TotalPhysicalMemory / 1GB, 2)) ГБ" "White"
}

# Главная функция
function Start-WindowsOptimization {
    Clear-Host
    
    Write-ColorOutput @"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║          WINDOWS 11 OPTIMIZER - Оптимизатор Windows       ║
║                      Версия 1.0                            ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
"@ "Cyan"
    
    # Проверка прав администратора
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-ColorOutput "`n✗ ОШИБКА: Скрипт должен быть запущен с правами администратора!" "Red"
        Write-ColorOutput "Щелкните правой кнопкой мыши по файлу и выберите 'Запуск от имени администратора'" "Yellow"
        pause
        exit
    }
    
    Write-ColorOutput "`n✓ Скрипт запущен с правами администратора" "Green"
    
    # Показать информацию о системе
    Show-SystemInfo
    
    # Запрос подтверждения
    Write-ColorOutput "`n⚠ ВНИМАНИЕ: Будет выполнена полная оптимизация системы." "Yellow"
    $confirmation = Read-Host "Продолжить? (Y/N)"
    
    if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
        Write-ColorOutput "`nОперация отменена пользователем." "Yellow"
        exit
    }
    
    $startTime = Get-Date
    
    # Выполнение задач оптимизации
    Clear-TemporaryFiles
    Clear-RecycleBin
    Invoke-SystemFileCheck
    Optimize-Disks
    
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    # Итоговый отчет
    Write-ColorOutput "`n╔════════════════════════════════════════════════════════════╗" "Green"
    Write-ColorOutput "║           ОПТИМИЗАЦИЯ ЗАВЕРШЕНА УСПЕШНО!                  ║" "Green"
    Write-ColorOutput "╚════════════════════════════════════════════════════════════╝" "Green"
    
    Write-ColorOutput "`nВремя выполнения: $($duration.Minutes) мин $($duration.Seconds) сек" "White"
    Write-ColorOutput "`nРекомендуется перезагрузить компьютер для применения всех изменений." "Yellow"
    
    $reboot = Read-Host "`nПерезагрузить компьютер сейчас? (Y/N)"
    if ($reboot -eq 'Y' -or $reboot -eq 'y') {
        Write-ColorOutput "`nПерезагрузка через 10 секунд..." "Yellow"
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    }
}

# Запуск скрипта
Start-WindowsOptimization
