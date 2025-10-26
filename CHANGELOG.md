# Changelog

All notable changes to this project will be documented in this file.

---

## [1.1.0] - 2025-10-26

### 🎉 Major Update: Production Ready + Railway Deployment

#### ✨ Додано

**📚 Документація:**
- `GETTING_STARTED.md` - Повний гайд від А до Я (750+ рядків)
- `PROJECT_OVERVIEW.md` - Огляд архітектури та технологій (450+ рядків)
- Оновлено `README.md` з посиланнями на всю документацію

**🐳 Docker:**
- `docker-compose.yml` - Локальне середовище (backend + PostgreSQL)
- Оптимізовано `Dockerfile` з multi-stage build
- Розмір production образу: ~15 MB (було ~500 MB)
- Оновлено `.dockerignore`

**🚂 Railway Integration:**
- `railway.json` - Конфігурація платформи
- Автоматичний деплой через GitHub push
- Підтримка PostgreSQL з автоматичними змінними
- Production-ready налаштування

**🔧 Development Tools:**
- `Makefile` - 20+ корисних команд
- `scripts/test_api.sh` - Bash скрипт для тестування API
- `env.example` - Приклад змінних середовища

#### 🔄 Змінено

- **README.md**: Повністю перероблено з посиланнями на всю документацію
- **app_config.dart**: Покращено для роботи з різними середовищами
- Додано підтримку environment variables для Railway

#### 🎯 Features

**Production Ready:**
- ✅ Автоматичний HTTPS через Railway
- ✅ PostgreSQL в production  
- ✅ Environment-based configuration
- ✅ Request logging
- ✅ Health checks
- ✅ CORS підтримка
- ✅ Auto-deploy з GitHub

**Local Development:**
- ✅ Docker Compose для повного середовища
- ✅ Швидкий запуск через `dart run`
- ✅ Hot reload підтримка
- ✅ Тестові скрипти

#### 📊 Статистика

```
Нових файлів:        10+
Рядків документації: 2500+
Docker образ:        15 MB
Час деплою:          ~3 хв
API endpoints:       11
```

#### 🔒 Безпека

- Задокументовано вразливості
- Roadmap для security improvements
- Приклади JWT та bcrypt імплементації
- SQL injection захист (параметризовані запити)

#### 🎓 Навчальні матеріали

- Пояснення Docker для початківців
- Покрокові інструкції деплою
- Діаграми архітектури
- Best practices

---

## [1.0.0] - 2025-10-XX

### ✨ Initial Release

**Backend API:**
- Dart + Shelf framework
- PostgreSQL database
- RESTful API
- User authentication
- Todo CRUD operations

**Features:**
- User registration/login
- Todo management
- CORS support
- Request logging
- Health check endpoint

**Tech Stack:**
- Dart 3.2.5+
- Shelf
- PostgreSQL
- Docker
