# 🚀 Todo Backend - Повний гайд від А до Я

Детальна інструкція як створити, запустити локально та задеплоїти Dart backend з PostgreSQL на Railway.

---

## 📋 Зміст

1. [Що ми створили](#що-ми-створили)
2. [Локальна розробка](#локальна-розробка)
3. [Docker для локального тестування](#docker-для-локального-тестування)
4. [Деплой на Railway](#деплой-на-railway)
5. [Підключення до БД](#підключення-до-бд)
6. [Тестування API](#тестування-api)

---

## 🎯 Що ми створили

### Backend API на Dart
- **Framework:** Shelf
- **База даних:** PostgreSQL
- **Контейнеризація:** Docker
- **Хостинг:** Railway
- **API:** RESTful

### Функціонал:
- ✅ Реєстрація та авторизація користувачів
- ✅ CRUD операції для todos
- ✅ PostgreSQL база даних
- ✅ CORS підтримка
- ✅ Логування запитів
- ✅ Health check endpoint

### Структура проекту:
```
pdp_dart_be/
├── bin/
│   └── server.dart              # Entry point
├── lib/
│   ├── config/
│   │   └── app_config.dart      # Конфігурація через env
│   ├── controllers/
│   │   ├── todo_controller.dart # Todo HTTP handlers
│   │   └── user_controller.dart # User HTTP handlers
│   ├── middleware/
│   │   └── auth_middleware.dart # Авторизація
│   ├── models/
│   │   ├── todo.dart            # Todo модель
│   │   └── user.dart            # User модель
│   ├── routes/
│   │   └── api_routes_generated.dart # Роути
│   └── services/
│       ├── database_service.dart     # PostgreSQL підключення
│       ├── todo_service.dart         # Todo бізнес-логіка
│       └── user_service.dart         # User бізнес-логіка
├── Dockerfile                   # Docker конфігурація
├── docker-compose.yml           # Локальне середовище
├── railway.json                 # Railway конфігурація
└── pubspec.yaml                 # Dart залежності
```

---

## 💻 Локальна розробка

### Крок 1: Встановлення залежностей

```bash
# Перейти в директорію проекту
cd pdp_dart_be

# Встановити Dart залежності
dart pub get
```

### Крок 2: Налаштування змінних середовища

Створіть файл `.env` (на основі `env.example`):

```bash
cp env.example .env
```

Відредагуйте `.env`:

```bash
# Server
HOST=0.0.0.0
PORT=8080

# Database (локальна PostgreSQL)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=mysecretpassword

# Application
ENVIRONMENT=development
ALLOWED_ORIGINS=*
LOG_LEVEL=info
ENABLE_REQUEST_LOGGING=true
```

### Крок 3: Запуск PostgreSQL

**Варіант A: Через Docker (рекомендовано)**

```bash
docker run --name postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  -d postgres:16-alpine
```

**Варіант B: Тільки PostgreSQL з docker-compose**

```bash
docker-compose up postgres -d
```

### Крок 4: Запуск backend сервера

```bash
dart run bin/server.dart
```

Ви побачите:
```
🚀 Todo Backend Server started!
📍 Server listening on 0.0.0.0:8080
🔗 Health check: http://0.0.0.0:8080/api/health
```

### Крок 5: Перевірка

Відкрийте в браузері або через curl:

```bash
# Health check
curl http://localhost:8080/api/health

# Головна сторінка
curl http://localhost:8080/
```

---

## 🐳 Docker для локального тестування

Docker дозволяє запустити все середовище (backend + PostgreSQL) в ізольованих контейнерах.

### Що дає Docker?

- ✅ Все працює ізольовано
- ✅ PostgreSQL автоматично встановлюється
- ✅ Той самий код що буде на продакшені
- ✅ Легко перезапускати

### Крок 1: Встановлення Docker Desktop

**macOS:**
1. Завантажте з https://www.docker.com/products/docker-desktop/
2. Встановіть Docker Desktop
3. Запустіть і дочекайтесь іконки 🐳 у верхній панелі

**Перевірка:**
```bash
docker --version
```

### Крок 2: Запуск через Docker Compose

Docker Compose запускає обидва сервіси одночасно:

```bash
# Запустити все (backend + PostgreSQL)
docker-compose up -d

# Подивитися що працює
docker ps

# Логи backend
docker logs todo-backend -f

# Логи PostgreSQL
docker logs todo-postgres -f

# Обидва логи разом
docker-compose logs -f
```

### Крок 3: Перевірка

```bash
# Health check
curl http://localhost:8080/api/health

# Тест всіх endpoints
./scripts/test_api.sh
```

### Крок 4: Управління Docker

```bash
# Зупинити все
docker-compose down

# Зупинити і видалити дані БД
docker-compose down -v

# Перезапустити
docker-compose restart

# Перебудувати після змін коду
docker-compose up -d --build

# Подивитися статус
docker ps
```

### Типовий робочий процес

**Для розробки (швидко):**
```bash
# Запустити тільки PostgreSQL
docker-compose up postgres -d

# Запустити код напряму
dart run bin/server.dart

# При змінах коду - Ctrl+C і знову
dart run bin/server.dart
```

**Для тестування перед деплоєм:**
```bash
# Запустити все через Docker
docker-compose up -d

# Протестувати
./scripts/test_api.sh

# Якщо все ок - деплоїмо!
```

---

## 🚂 Деплой на Railway

Railway - це платформа для хостингу додатків з безкоштовним tier'ом.

### Чому Railway?

- ✅ 500 годин безкоштовно щомісяця
- ✅ Автоматичний SSL (HTTPS)
- ✅ Безкоштовний PostgreSQL
- ✅ Деплой з GitHub одним кліком
- ✅ Автоматичне масштабування

### Крок 1: Підготовка коду

**Переконайтесь що код на GitHub:**

```bash
# Перевірити статус
git status

# Якщо є зміни - закомітити
git add .
git commit -m "feat: готово до деплою"

# Запушити на GitHub
git push origin main
```

**Важливо:** Railway читає код з GitHub, тому код ОБОВ'ЯЗКОВО має бути запушений!

### Крок 2: Реєстрація на Railway

1. Відкрийте https://railway.app
2. Натисніть **"Login with GitHub"**
3. Авторизуйте Railway (дозвольте доступ до репозиторіїв)
4. Ви потрапите в Dashboard

### Крок 3: Створення проекту

1. Натисніть **"New Project"**
2. Виберіть **"Deploy from GitHub repo"**
3. Знайдіть і виберіть ваш репозиторій: **`pdp_dart_be`**
4. Railway автоматично:
   - Знайде `Dockerfile`
   - Почне збірку проекту
   - Створить сервіс

**Ви побачите логи збірки в реальному часі!**

### Крок 4: Додавання PostgreSQL

**Поки йде збірка backend:**

1. У вашому проекті натисніть **"+ New"** (кнопка справа вгорі)
2. Виберіть **"Database"**
3. Виберіть **"Add PostgreSQL"**
4. Railway створить PostgreSQL сервер з усіма змінними

**Тепер у вас в одному проекті два сервіси:**
- 🐳 `pdp-dart-be` - ваш backend
- 🐘 `Postgres` - база даних

### Крок 5: Налаштування змінних середовища

**Це найважливіший крок! Без цього backend не підключиться до БД.**

1. Клікніть на **backend сервіс** (pdp-dart-be)
2. Перейдіть у вкладку **"Variables"**
3. Додайте змінні через **Reference** (найпростіше):

**Для кожної змінної:**
- Натисніть **"+ New Variable"**
- Виберіть **"Add Reference"**
- У лівому полі - назва змінної
- У правому - виберіть значення з Postgres

**Додайте ці 5 змінних:**

| Variable Name | Reference to Postgres |
|--------------|----------------------|
| `DB_HOST` | `PGHOST` |
| `DB_PORT` | `PGPORT` |
| `DB_NAME` | `PGDATABASE` |
| `DB_USER` | `PGUSER` |
| `DB_PASSWORD` | `PGPASSWORD` |

4. Додайте ще 3 змінні **вручну** (натисніть "Raw Editor"):

```bash
HOST=0.0.0.0
ENVIRONMENT=production
ALLOWED_ORIGINS=*
```

5. Збережіть (автоматично) або натисніть "Deploy"

**Всього має бути 8 змінних!**

### Крок 6: Перевірка деплою

1. Клікніть на **backend сервіс**
2. Вкладка **"Deployments"**
3. Дочекайтесь статусу:
   - 🟡 **Building** - збирається (~2-3 хв)
   - 🟢 **Active** - працює! ✅
   - 🔴 **Failed** - помилка (дивіться логи)

**Якщо Failed:**
- Перевірте логи у вкладці "Deployments" → клік на деплой → "View Logs"
- Найчастіша помилка: змінні БД не налаштовані правильно
- Перевірте що всі 8 змінних додані

### Крок 7: Отримання публічного URL

1. У backend сервісі перейдіть у **"Settings"**
2. Прокрутіть до розділу **"Networking"**
3. Натисніть **"Generate Domain"**

Ви отримаєте URL:
```
https://pdp-dart-be-production-XXXX.up.railway.app
```

### Крок 8: Тестування production API

```bash
# Health check
curl https://your-url.railway.app/api/health

# Або у браузері
https://your-url.railway.app
```

**Якщо бачите відповідь - вітаю! Ваш API в інтернеті! 🎉**

### Автоматичні оновлення

**Найкраща частина:** Кожен git push автоматично деплоїться!

```bash
# Змінили код
git add .
git commit -m "feat: new feature"
git push origin main

# Railway автоматично:
# 1. Отримає зміни з GitHub
# 2. Збудує новий образ
# 3. Задеплоїть оновлення
# 4. Перевірить health check
```

---

## 🔌 Підключення до БД

Ви можете підключитися до production БД через будь-який PostgreSQL клієнт.

### Крок 1: Отримання credentials

**У Railway:**

1. Клікніть на сервіс **"Postgres"** (не backend!)
2. Вкладка **"Connect"** або **"Variables"**
3. Скопіюйте **"Postgres Connection URL"**

Виглядає так:
```
postgresql://postgres:PASSWORD@HOST:PORT/railway
```

### Крок 2: Підключення через клієнт

**Популярні клієнти:**
- **TablePlus** - https://tableplus.com/ (рекомендую)
- **DBeaver** - https://dbeaver.io/
- **pgAdmin** - https://www.pgadmin.org/
- **DataGrip** - https://www.jetbrains.com/datagrip/

**Налаштування підключення:**

Якщо клієнт підтримує Connection String:
```
postgresql://postgres:PASSWORD@HOST:PORT/railway
```

Або окремо:
```
Host: yamanote.proxy.rlwy.net (ваш буде інший!)
Port: 16985 (ваш буде інший!)
Username: postgres
Password: [довгий рядок з Railway]
Database: railway
SSL: Enabled (обов'язково!)
```

### Крок 3: Перегляд таблиць

Після підключення ви побачите дві таблиці:
- **users** - користувачі
  - id, username, email, password_hash, created_at, updated_at
- **todos** - завдання
  - id, user_id, title, description, is_completed, created_at, updated_at

---

## 🧪 Тестування API

### Через браузер

Відкрийте:
```
https://your-url.railway.app
```

Побачите список всіх endpoints.

### Через curl

```bash
# 1. Health check
curl https://your-url.railway.app/api/health

# 2. Реєстрація користувача
curl -X POST https://your-url.railway.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "test123"
  }'

# Відповідь: {"message":"User registered successfully","user":{...}}
# Скопіюйте "id" користувача!

# 3. Логін
curl -X POST https://your-url.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "test123"
  }'

# 4. Створити todo (замініть YOUR_USER_ID)
curl -X POST https://your-url.railway.app/api/todos/create \
  -H "Content-Type: application/json" \
  -H "Authorization: YOUR_USER_ID" \
  -d '{
    "title": "Вивчити Dart",
    "description": "Backend розробка на Dart",
    "isCompleted": false
  }'

# 5. Отримати всі todos
curl https://your-url.railway.app/api/todos/all

# 6. Отримати todos користувача
curl https://your-url.railway.app/api/todos/user/YOUR_USER_ID

# 7. Оновити todo (замініть TODO_ID)
curl -X PUT https://your-url.railway.app/api/todos/update/TODO_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: YOUR_USER_ID" \
  -d '{
    "isCompleted": true
  }'

# 8. Видалити todo
curl -X DELETE https://your-url.railway.app/api/todos/delete/TODO_ID \
  -H "Authorization: YOUR_USER_ID"
```

### Через тестовий скрипт

```bash
# Локально
./scripts/test_api.sh

# Production
API_URL=https://your-url.railway.app ./scripts/test_api.sh
```

### Через Postman

1. Імпортуйте колекцію (створіть на основі curl команд вище)
2. Додайте змінну `base_url`: `https://your-url.railway.app`
3. Тестуйте!

---

## 📊 Доступні API Endpoints

### Authentication

| Method | Endpoint | Опис | Auth |
|--------|----------|------|------|
| POST | `/api/auth/register` | Реєстрація | ❌ |
| POST | `/api/auth/login` | Логін | ❌ |
| GET | `/api/auth/profile` | Отримати профіль | ✅ |
| PUT | `/api/auth/profile` | Оновити профіль | ✅ |

### Todos

| Method | Endpoint | Опис | Auth |
|--------|----------|------|------|
| GET | `/api/todos/all` | Всі todos | ❌ |
| GET | `/api/todos/user/:userId` | Todos користувача | ❌ |
| GET | `/api/todos/get/:id` | Todo за ID | ❌ |
| POST | `/api/todos/create` | Створити todo | ✅ |
| PUT | `/api/todos/update/:id` | Оновити todo | ✅ |
| DELETE | `/api/todos/delete/:id` | Видалити todo | ✅ |

### System

| Method | Endpoint | Опис | Auth |
|--------|----------|------|------|
| GET | `/api/health` | Health check | ❌ |
| GET | `/` | API info | ❌ |

**Auth:** Додайте заголовок `Authorization: USER_ID`

---

## 🛠️ Корисні команди

### Локальна розробка

```bash
# Встановити залежності
dart pub get

# Запустити сервер
dart run bin/server.dart

# Форматування коду
dart format .

# Аналіз коду
dart analyze

# Тести
dart test

# Генерація коду (routes)
dart run build_runner build
```

### Docker

```bash
# Запустити все
docker-compose up -d

# Зупинити
docker-compose down

# Очистити дані
docker-compose down -v

# Логи
docker-compose logs -f

# Статус
docker ps

# Rebuild після змін
docker-compose up -d --build
```

### Git

```bash
# Статус
git status

# Додати зміни
git add .

# Commit
git commit -m "feat: опис змін"

# Push (автоматичний деплой!)
git push origin main
```

### Railway CLI (опціонально)

```bash
# Встановити
npm install -g @railway/cli

# Логін
railway login

# Логи
railway logs

# Змінні
railway variables

# Відкрити в браузері
railway open
```

---

## 🔍 Вирішення проблем

### Backend не підключається до БД

**Проблема:** `Connection refused` або `Database not connected`

**Рішення:**
1. Перевірте що PostgreSQL запущена: `docker ps`
2. Перевірте змінні середовища
3. У Railway: перевірте що всі 8 змінних додані правильно
4. Перевірте що використовуєте `${{Postgres.PGHOST}}` а не просто `localhost`

### Railway деплой Failed

**Проблема:** Збірка падає або сервіс не запускається

**Рішення:**
1. Перевірте логи: Deployments → клік на деплой → View Logs
2. Переконайтесь що `Dockerfile` на місці
3. Перевірте що код запушений на GitHub
4. Перевірте змінні БД

### Docker контейнери не запускаються

**Проблема:** `docker-compose up` падає

**Рішення:**
```bash
# Очистити все
docker-compose down -v

# Запустити знову
docker-compose up -d

# Перевірити логи
docker-compose logs
```

### Port вже зайнятий

**Проблема:** `Port 8080 already in use`

**Рішення:**
```bash
# Знайти процес
lsof -i :8080

# Вбити процес
kill -9 PID

# Або змінити порт у .env
PORT=3000
```

---

## 📚 Додаткові ресурси

### Документація
- [Dart Language](https://dart.dev/guides)
- [Shelf Package](https://pub.dev/packages/shelf)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [Docker](https://docs.docker.com/)
- [Railway Docs](https://docs.railway.app/)

### Документація проекту
- [README.md](./README.md) - Основний файл проекту
- [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md) - Архітектура та технічні деталі
- [CHANGELOG.md](./CHANGELOG.md) - Історія змін

---

## 🎉 Вітаємо!

Ви успішно:
- ✅ Створили Dart backend API
- ✅ Налаштували PostgreSQL
- ✅ Запустили локально через Docker
- ✅ Задеплоїли на Railway
- ✅ Підключилися до production БД
- ✅ Протестували API

**Ваш API тепер доступний в інтернеті 24/7!** 🌍

---

## 🚀 Що далі?

### Рекомендації для покращення:

1. **Безпека:**
   - Додати JWT токени замість простого user-id
   - Хешувати паролі (bcrypt)
   - Додати rate limiting
   - Налаштувати CORS для конкретних доменів

2. **Функціонал:**
   - Email верифікація
   - Відновлення пароля
   - Фільтрація та пагінація todos
   - Пошук
   - Категорії для todos

3. **DevOps:**
   - CI/CD через GitHub Actions
   - Автоматичні тести
   - Моніторинг (Sentry)
   - Backup БД

4. **Frontend:**
   - Створити веб-додаток (React/Vue/Flutter Web)
   - Мобільний додаток (Flutter)
   - Desktop додаток (Flutter Desktop)

---

**Успіхів у розробці! 💪**

Якщо виникнуть питання - дивіться інші гайди в репозиторії або створюйте issue на GitHub.

