# 📋 Инструкция по созданию репозитория WindowsOptimizer на GitHub

## ⚠️ Почему автоматическое создание невозможно?

При попытке автоматического создания репозитория через GitHub API я получил ошибку:

```
403 Forbidden: "Resource not accessible by integration"
```

**Причина:** Токен доступа GitHub, предоставленный через Abacus.AI интеграцию, имеет **ограниченные разрешения (scopes)**. Он позволяет:
- ✅ Читать репозитории
- ✅ Создавать ветки и коммиты
- ✅ Создавать Pull Request'ы
- ❌ **НЕ позволяет создавать новые репозитории**

Это ограничение безопасности на уровне OAuth-приложения Abacus.AI, и его **невозможно обойти** даже с дополнительными разрешениями в настройках.

---

## 🚀 Решение: Ручное создание репозитория (2 минуты)

### Шаг 1: Создайте репозиторий на GitHub

1. Откройте в браузере: **https://github.com/new**
2. Заполните форму:
   - **Repository name:** `WindowsOptimizer`
   - **Description:** `Windows optimization and configuration tool` (опционально)
   - **Visibility:** Public (или Private, на ваш выбор)
   - ⚠️ **ВАЖНО:** **НЕ** ставьте галочки на:
     - ❌ Add a README file
     - ❌ Add .gitignore
     - ❌ Choose a license
   
   (Эти файлы уже есть в локальном репозитории!)

3. Нажмите **"Create repository"**

### Шаг 2: Автоматическая загрузка (выполните одну команду)

После создания репозитория на GitHub, вернитесь сюда и выполните:

```bash
bash /home/ubuntu/WindowsOptimizer/push_to_github.sh
```

**Готово!** 🎉 Ваш репозиторий будет загружен на GitHub.

---

## 📝 Альтернатива: Ручные команды Git

Если предпочитаете делать вручную, используйте эти команды:

```bash
cd /home/ubuntu/WindowsOptimizer

# Добавьте remote
git remote add origin https://github.com/Serg2206/WindowsOptimizer.git

# Отправьте код на GitHub
git push -u origin main
```

При запросе учетных данных:
- **Username:** `Serg2206`
- **Password:** используйте ваш Personal Access Token (не пароль от аккаунта!)

---

## 🔗 Ссылки

После создания ваш репозиторий будет доступен по адресу:
**https://github.com/Serg2206/WindowsOptimizer**

---

## 📦 Что уже готово в локальном репозитории?

✅ `.gitignore` - правила игнорирования файлов  
✅ `LICENSE` - лицензия MIT  
✅ `README.md` - подробная документация (9.3 KB)  
✅ `WindowsOptimizer.ps1` - основной скрипт PowerShell (11.6 KB)  
✅ Initial commit уже создан: `78aa130`  
✅ Branch: `main`  

Всё готово к загрузке! 🚀
