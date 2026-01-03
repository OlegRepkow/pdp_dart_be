# Todo Backend API 🚀

Бекенд для Todo додатку на Dart з використанням Shelf фреймворку та PostgreSQL.

**Задеплоєно на Render:** ✅ Production ready! (Безкоштовний план)

---

## 📚 Документація

- 📖 **[GETTING_STARTED.md](./GETTING_STARTED.md)** - Повний гайд від А до Я
  - Локальна розробка (через Dart та Docker)
  - Деплой на Railway (крок за кроком)
  - Підключення до production БД
  - Тестування API
  - Вирішення проблем
  
- 🚀 **[MIGRATION_TO_RENDER.md](./MIGRATION_TO_RENDER.md)** - Міграція з Railway на Render
  - Експорт даних з Railway
  - Створення проекту на Render
  - Імпорт даних
  - Налаштування та перевірка
  
- 📊 **[PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)** - Огляд проекту
  - Архітектура системи
  - Структура проекту
  - Схема бази даних
  - Технології та інструменти
  
- 📝 **[CHANGELOG.md](./CHANGELOG.md)** - Історія змін проекту

---

## 📋 Зміст

- [Швидкий старт](#-швидкий-старт)
- [API Endpoints](#-api-endpoints)
- [Docker](#-docker)
- [Локальна розробка](#-локальна-розробка)
- [Production на Railway](#-production-на-railway)

---

## 🚀 Швидкий старт

### Локально

```bash
# 1. Встановлення залежностей
dart pub get

# 2. Налаштуйте змінні середовища (скопіюйте env.example)
cp env.example .env

# 3. Запуск PostgreSQL (Docker)
docker run --name postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres

# 4. Запуск сервера
dart run bin/server.dart
```

Сервер запуститься на `http://localhost:8080`

---

## 📡 API Endpoints

### Health Check
- **GET** `/api/health` - Перевірка стану сервера

### Authentication
- **POST** `/api/auth/register` - Реєстрація користувача
  ```json
  {
    "username": "user",
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **POST** `/api/auth/login` - Вхід користувача
  ```json
  {
    "username": "user",
    "password": "password123"
  }
  ```
- **GET** `/api/auth/profile` - Отримати профіль (потрібна авторизація)
- **PUT** `/api/auth/profile` - Оновити профіль (потрібна авторизація)

### Todos
- **GET** `/api/todos/all` - Отримати всі todos
- **GET** `/api/todos/user/{userId}` - Отримати todos користувача
- **POST** `/api/todos/create` - Створити todo (потрібна авторизація)
  ```json
  {
    "title": "Вивчити Dart",
    "description": "Зробити backend додаток",
    "isCompleted": false
  }
  ```
- **GET** `/api/todos/get/{id}` - Отримати todo за ID
- **PUT** `/api/todos/update/{id}` - Оновити todo (потрібна авторизація)
- **DELETE** `/api/todos/delete/{id}` - Видалити todo (потрібна авторизація)

### Авторизація
Для авторізованих запитів додайте заголовок:
```
Authorization: your-user-id
```

---

## 🚀 Production на Render (Безкоштовно!)

**Ваш API готовий до деплою на Render!** 🎉

### URL:
```
https://your-app.onrender.com/api/health
```

### Швидкий деплой:
1. Зареєструйтесь на [Render.com](https://render.com) (безкоштовно)
2. Підключіть GitHub репозиторій
3. Render автоматично визначить `render.yaml` і налаштує все

### Повний гайд:
Детальна інструкція нижче в розділі **[Деплой на Render](#-деплой-на-render)**

---

## 🚀 Деплой на Render (Безкоштовний план)

### Переваги Render:
- ✅ **Безкоштовний план** для веб-сервісів та PostgreSQL
- ✅ Автоматичний деплой з GitHub
- ✅ Безкоштовний SSL сертифікат
- ✅ Автоматичні оновлення при push до main
- ✅ Просте налаштування через `render.yaml`

### Крок 1: Підготовка

1. Зареєструйтесь на [Render.com](https://render.com) (безкоштовно)
2. Підключіть ваш GitHub акаунт
3. Переконайтесь що ваш код є в GitHub репозиторії

### Крок 2: Створення сервісів

**Варіант A: Автоматичний (рекомендовано)**

1. Перейдіть на [Render Dashboard](https://dashboard.render.com)
2. Натисніть "New +" → "Blueprint"
3. Підключіть ваш GitHub репозиторій
4. Render автоматично визначить `render.yaml` і створить:
   - Web Service (backend)
   - PostgreSQL Database
   - Всі змінні середовища

**Варіант B: Ручне створення**

1. **Створіть PostgreSQL базу даних:**
   - Натисніть "New +" → "PostgreSQL"
   - Оберіть план "Free"
   - Назвіть: `todo-postgres`
   - Натисніть "Create Database"

2. **Створіть Web Service:**
   - Натисніть "New +" → "Web Service"
   - Підключіть ваш GitHub репозиторій
   - Налаштування:
     - **Name:** `todo-backend`
     - **Environment:** `Docker`
     - **Plan:** `Free`
     - **Dockerfile Path:** `./Dockerfile`
     - **Docker Command:** `/app/bin/server`

3. **Налаштуйте змінні середовища:**
   В Settings → Environment Variables додайте:
   ```bash
   HOST=0.0.0.0
   PORT=8080
   ENVIRONMENT=production
   ALLOWED_ORIGINS=*
   LOG_LEVEL=info
   ENABLE_REQUEST_LOGGING=true
   ```

4. **Підключіть базу даних:**
   - В розділі "Environment" натисніть "Add Environment Variable"
   - Додайте змінні з Internal Database URL:
     - `DB_HOST` → Internal Database Host
     - `DB_PORT` → Internal Database Port
     - `DB_NAME` → Internal Database Name
     - `DB_USER` → Internal Database User
     - `DB_PASSWORD` → Internal Database Password

### Крок 3: Деплой

1. Натисніть "Create Web Service"
2. Render автоматично почне збірку та деплой
3. Зачекайте 5-10 хвилин (перший деплой довший)
4. Після завершення ви отримаєте URL: `https://your-app.onrender.com`

### Крок 4: Перевірка

```bash
# Health check
curl https://your-app.onrender.com/api/health
```

### ⚠️ Важливо про безкоштовний план Render:

- **Спиння після неактивності:** Безкоштовні сервіси "засинають" після 15 хвилин неактивності
- **Перший запит може бути повільним:** Після "засинання" перший запит може займати 30-60 секунд
- **Обмеження ресурсів:** 512MB RAM, 0.5 CPU
- **Для production:** Рекомендується оновитись до платного плану ($7/міс) для постійної роботи

### 🎯 Власний домен

1. Перейдіть у Settings → Custom Domains
2. Додайте ваш домен (наприклад, `api.yourdomain.com`)
3. Додайте CNAME запис у вашому DNS:
   ```
   CNAME api your-app.onrender.com
   ```

---

## 🚂 Деплой на Railway (Платний план)

### Крок 1: Підготовка

1. Зареєструйтесь на [Railway.app](https://railway.app)
2. Встановіть Railway CLI (опціонально):
   ```bash
   npm install -g @railway/cli
   ```

### Крок 2: Створення проекту

**Варіант A: Через веб-інтерфейс**

1. Натисніть "New Project"
2. Виберіть "Deploy from GitHub repo"
3. Підключіть ваш репозиторій
4. Railway автоматично визначить Dockerfile

**Варіант B: Через CLI**

```bash
# Залогіньтесь
railway login

# Ініціалізуйте проект
railway init

# Деплой
railway up
```

### Крок 3: Додавання PostgreSQL

1. У вашому проекті натисніть "New"
2. Виберіть "Database" → "PostgreSQL"
3. Railway автоматично створить базу даних

### Крок 4: Налаштування змінних середовища

Railway автоматично створить змінні для PostgreSQL:
- `PGHOST` → використовуйте як `DB_HOST`
- `PGPORT` → використовуйте як `DB_PORT`
- `PGDATABASE` → використовуйте як `DB_NAME`
- `PGUSER` → використовуйте як `DB_USER`
- `PGPASSWORD` → використовуйте як `DB_PASSWORD`

**Додайте ці змінні в Settings → Variables:**

```bash
HOST=0.0.0.0
PORT=8080
DB_HOST=${{PGHOST}}
DB_PORT=${{PGPORT}}
DB_NAME=${{PGDATABASE}}
DB_USER=${{PGUSER}}
DB_PASSWORD=${{PGPASSWORD}}
ENVIRONMENT=production
ALLOWED_ORIGINS=*
```

### Крок 5: Отримання URL

Після деплою ви отримаєте URL типу:
```
https://your-project.railway.app
```

API буде доступний за адресою:
```
https://your-project.railway.app/api/health
```

### 🎯 Власний домен

1. Перейдіть у Settings → Domains
2. Натисніть "Generate Domain" або "Custom Domain"
3. Для власного домену (наприклад, `repkow.o`):
   - Додайте CNAME запис у налаштуваннях вашого DNS провайдера:
   ```
   CNAME @ your-project.railway.app
   ```

---

## 🌐 Інші платформи для деплою

### Render.com (Безкоштовний план) ⭐ Рекомендовано

Дивіться детальний гайд вище в розділі **[Деплой на Render](#-деплой-на-render)**

### Fly.io

```bash
# 1. Встановіть flyctl
curl -L https://fly.io/install.sh | sh

# 2. Залогіньтесь
flyctl auth login

# 3. Запустіть проект
flyctl launch

# 4. Додайте PostgreSQL
flyctl postgres create

# 5. Прив'яжіть базу даних
flyctl postgres attach <database-name>

# 6. Деплой
flyctl deploy
```

### Google Cloud Run

```bash
# 1. Встановіть gcloud CLI
# 2. Залогіньтесь
gcloud auth login

# 3. Створіть проект
gcloud projects create YOUR_PROJECT_ID

# 4. Збудуйте образ
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/todo-backend

# 5. Деплойте
gcloud run deploy --image gcr.io/YOUR_PROJECT_ID/todo-backend --platform managed
```

---

## 🐳 Docker

### Локальна збірка та запуск

```bash
# Збірка
docker build -t todo-backend .

# Запуск
docker run -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5432 \
  -e DB_NAME=postgres \
  -e DB_USER=postgres \
  -e DB_PASSWORD=mysecretpassword \
  todo-backend
```

### Docker Compose

Створіть `docker-compose.yml`:

```yaml
version: '3.8'

services:
  backend:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=postgres
      - DB_USER=postgres
      - DB_PASSWORD=mysecretpassword
      - ENVIRONMENT=development
    depends_on:
      - postgres

  postgres:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=mysecretpassword
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Запуск:
```bash
docker-compose up -d
```

---

## 💻 Локальна розробка

### Вимоги

- Dart SDK >= 3.2.5
- PostgreSQL >= 14

### Налаштування

1. **Встановіть залежності:**
   ```bash
   dart pub get
   ```

2. **Налаштуйте PostgreSQL:**
   ```bash
   # macOS (Homebrew)
   brew install postgresql@16
   brew services start postgresql@16

   # Ubuntu/Debian
   sudo apt install postgresql-16
   sudo systemctl start postgresql

   # Windows (використовуйте Docker)
   docker run --name postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
   ```

3. **Налаштуйте змінні середовища:**
   ```bash
   cp env.example .env
   # Відредагуйте .env файл
   ```

4. **Запустіть сервер:**
   ```bash
   dart run bin/server.dart
   ```

### Кодогенерація роутів (опціонально)

```bash
dart run build_runner build
```

### Тестування

```bash
# Запустіть тести
dart test

# Health check
curl http://localhost:8080/api/health

# Реєстрація
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"test123"}'

# Створити todo
curl -X POST http://localhost:8080/api/todos/create \
  -H "Content-Type: application/json" \
  -H "Authorization: your-user-id" \
  -d '{"title":"Вивчити Dart","description":"Backend розробка"}'
```

---

## 📁 Структура проєкту

```
lib/
├── config/
│   └── app_config.dart           # Конфігурація додатку
├── models/
│   ├── todo.dart                 # Модель Todo
│   └── user.dart                 # Модель User
├── services/
│   ├── database_service.dart     # Підключення до PostgreSQL
│   ├── todo_service.dart         # CRUD операції для todos
│   └── user_service.dart         # CRUD операції для users
├── controllers/
│   ├── todo_controller.dart      # HTTP обробники для todos
│   └── user_controller.dart      # HTTP обробники для users
├── middleware/
│   └── auth_middleware.dart      # Middleware авторизації
└── routes/
    ├── api_routes_generated.dart # Згенеровані роути
    └── api_routes_generated.g.dart
```

---

## 🔐 Безпека

⚠️ **Важливо для production:**

1. **Не використовуйте прості паролі** - додайте bcrypt для хешування
2. **Додайте JWT токени** - замість простої авторизації за user-id
3. **Налаштуйте CORS** - обмежте `ALLOWED_ORIGINS`
4. **Використовуйте HTTPS** - Railway надає SSL автоматично
5. **Валідація даних** - додайте перевірку вхідних даних
6. **Rate limiting** - обмежте кількість запитів

---

## 🐛 Вирішення проблем

### Помилка підключення до БД

```bash
# Перевірте чи запущений PostgreSQL
docker ps

# Перевірте змінні середовища
echo $DB_HOST $DB_PORT $DB_NAME
```

### Порт вже використовується

```bash
# Знайдіть процес
lsof -i :8080

# Або змініть порт
export PORT=3000
dart run bin/server.dart
```

### Railway деплой не працює

1. Перевірте логи: `railway logs`
2. Перевірте змінні середовища в Settings → Variables
3. Переконайтесь що PostgreSQL підключена
4. Перевірте Dockerfile

---

## 📚 Додаткові ресурси

- [Dart Documentation](https://dart.dev/guides)
- [Shelf Package](https://pub.dev/packages/shelf)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Railway Docs](https://docs.railway.app/)

---

## 📝 Ліцензія

MIT

---

## 🤝 Внесок

Pull requests вітаються! Для великих змін спочатку створіть issue.

---

**Створено з ❤️ на Dart**
