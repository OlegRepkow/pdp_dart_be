# 📊 Огляд проекту Todo Backend

Короткий опис того, що було створено та як це працює.

---

## 🎯 Що це?

**Todo Backend API** - це RESTful API для управління списком завдань (todos) з авторизацією користувачів.

- **Мова:** Dart
- **Framework:** Shelf
- **База даних:** PostgreSQL
- **Контейнеризація:** Docker
- **Хостинг:** Railway
- **Status:** ✅ Production Ready

---

## 🏗️ Архітектура

```
┌─────────────┐
│   Client    │  (Browser, Mobile App, etc.)
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────────────────────────────┐
│         Railway Platform            │
│  ┌───────────────┐  ┌────────────┐ │
│  │  Dart Backend │──│ PostgreSQL │ │
│  │   (Docker)    │  │  Database  │ │
│  └───────────────┘  └────────────┘ │
└─────────────────────────────────────┘
```

---

## 📁 Структура проекту

```
pdp_dart_be/
├── 📂 bin/
│   └── server.dart                 # Точка входу (main)
│
├── 📂 lib/
│   ├── 📂 config/
│   │   └── app_config.dart         # Конфігурація через env змінні
│   │
│   ├── 📂 controllers/             # HTTP обробники (handlers)
│   │   ├── todo_controller.dart
│   │   └── user_controller.dart
│   │
│   ├── 📂 middleware/              # Middleware для обробки запитів
│   │   └── auth_middleware.dart    # Авторизація
│   │
│   ├── 📂 models/                  # Моделі даних
│   │   ├── todo.dart
│   │   └── user.dart
│   │
│   ├── 📂 routes/                  # API роути
│   │   └── api_routes_generated.dart
│   │
│   └── 📂 services/                # Бізнес-логіка
│       ├── database_service.dart   # PostgreSQL підключення
│       ├── todo_service.dart       # CRUD для todos
│       └── user_service.dart       # CRUD для users
│
├── 📂 scripts/
│   └── test_api.sh                 # Автоматичне тестування API
│
├── 📄 Dockerfile                   # Docker конфігурація
├── 📄 docker-compose.yml           # Локальне середовище
├── 📄 railway.json                 # Railway конфігурація
├── 📄 Makefile                     # Корисні команди
│
└── 📚 Документація/
    ├── README.md                   # Основний README
    ├── GETTING_STARTED.md          # Повний гайд від А до Я ⭐
    ├── PROJECT_OVERVIEW.md         # Цей файл
    └── CHANGELOG.md                # Історія змін
```

---

## 🔄 Як це працює?

### 1. **Запит від клієнта**

```
GET /api/todos/all
```

### 2. **Shelf Router** обробляє запит

```dart
router.get('/api/todos/all', todoController.getAllTodos);
```

### 3. **Middleware** обробляє запит
- CORS headers
- Логування
- Авторизація (якщо потрібна)

### 4. **Controller** викликає сервіс

```dart
Future<Response> getAllTodos(Request request) async {
  final todos = await _todoService.getAllTodos();
  return Response.ok(jsonEncode(todos));
}
```

### 5. **Service** працює з БД

```dart
Future<List<Todo>> getAllTodos() async {
  final result = await _db.connection.execute(
    'SELECT * FROM todos ORDER BY created_at DESC'
  );
  return result.map((row) => Todo.fromJson(row)).toList();
}
```

### 6. **Відповідь клієнту**

```json
[
  {
    "id": 1,
    "title": "Вивчити Dart",
    "description": "Backend розробка",
    "isCompleted": false,
    "userId": "123...",
    "createdAt": "2025-10-26T..."
  }
]
```

---

## 🗄️ Схема бази даних

### Таблиця `users`

| Колонка | Тип | Опис |
|---------|-----|------|
| id | VARCHAR(64) | PK, хеш пароля (SHA-256) |
| username | VARCHAR(50) | Unique, ім'я користувача |
| email | VARCHAR(100) | Unique, email |
| password_hash | VARCHAR(255) | Пароль (зараз plain text) |
| created_at | TIMESTAMP | Дата створення |
| updated_at | TIMESTAMP | Дата оновлення |

### Таблиця `todos`

| Колонка | Тип | Опис |
|---------|-----|------|
| id | SERIAL | PK, автоінкремент |
| user_id | VARCHAR(64) | FK → users(id) |
| title | VARCHAR(255) | Назва завдання |
| description | TEXT | Опис завдання |
| is_completed | BOOLEAN | Статус виконання |
| created_at | TIMESTAMP | Дата створення |
| updated_at | TIMESTAMP | Дата оновлення |

**Зв'язки:**
- `todos.user_id` → `users.id` (ON DELETE CASCADE)

---

## 🌐 API Endpoints

### Authentication (auth)

```
POST   /api/auth/register     # Реєстрація користувача
POST   /api/auth/login        # Логін користувача
GET    /api/auth/profile      # Отримати профіль [Auth]
PUT    /api/auth/profile      # Оновити профіль [Auth]
```

### Todos

```
GET    /api/todos/all              # Всі todos
GET    /api/todos/user/:userId     # Todos користувача
GET    /api/todos/get/:id          # Todo за ID
POST   /api/todos/create           # Створити todo [Auth]
PUT    /api/todos/update/:id       # Оновити todo [Auth]
DELETE /api/todos/delete/:id       # Видалити todo [Auth]
```

### System

```
GET    /api/health            # Health check
GET    /                      # API info
```

**[Auth]** - потребує заголовок `Authorization: user-id`

---

## 🔧 Технології

### Backend

- **Dart 3.2.5+** - Мова програмування
- **Shelf** - Web framework
- **Shelf Router** - Роутинг
- **Shelf CORS** - CORS підтримка
- **PostgreSQL** - Реляційна БД
- **postgres package** - PostgreSQL клієнт для Dart

### DevOps

- **Docker** - Контейнеризація
- **Docker Compose** - Оркестрація локального середовища
- **Railway** - Хостинг платформа
- **GitHub** - Version control та CI/CD (через Railway)

### Development Tools

- **build_runner** - Кодогенерація
- **shelf_router_generator** - Генерація роутів
- **crypto** - Хешування (для user ID)
- **uuid** - Генерація унікальних ID

---

## 🚀 Способи запуску

### 1. Локально через Dart

```bash
dart run bin/server.dart
```
**Плюси:** Швидко, hot reload  
**Мінуси:** Потрібен PostgreSQL окремо

### 2. Локально через Docker Compose

```bash
docker-compose up -d
```
**Плюси:** Все включено (backend + PostgreSQL)  
**Мінуси:** Повільніше при змінах коду

### 3. Production на Railway

```bash
git push origin main
```
**Плюси:** Автоматичний деплой, SSL, масштабування  
**Мінуси:** Потрібен інтернет

---

## 🔐 Безпека

### ⚠️ Поточний стан:

- ❌ Паролі в plain text (не хешовані)
- ❌ Авторизація через user-id (не JWT)
- ❌ Немає rate limiting
- ❌ CORS відкритий для всіх (`*`)

### ✅ Що працює:

- ✅ Параметризовані SQL запити (захист від SQL injection)
- ✅ HTTPS на Railway (автоматично)
- ✅ Валідація на рівні БД (UNIQUE, NOT NULL)
- ✅ CASCADE DELETE для зв'язаних даних

### 🔜 TODO для production:

1. **bcrypt** для хешування паролів
2. **JWT токени** для авторизації
3. **Rate limiting** для захисту від DDoS
4. **CORS** обмежити до конкретних доменів
5. **Валідація даних** на вході
6. **Email верифікація**

---

## 📈 Що можна покращити?

### Функціонал

- [ ] Email верифікація
- [ ] Відновлення пароля
- [ ] Категорії для todos
- [ ] Пріоритети (high, medium, low)
- [ ] Due dates (терміни виконання)
- [ ] Прикріплення файлів
- [ ] Пошук та фільтрація
- [ ] Пагінація

### Безпека

- [ ] JWT токени
- [ ] bcrypt для паролів
- [ ] Rate limiting
- [ ] CORS налаштування
- [ ] Input validation
- [ ] XSS захист

### DevOps

- [ ] GitHub Actions CI/CD
- [ ] Автоматичні тести
- [ ] Integration tests
- [ ] Моніторинг (Sentry)
- [ ] Логування
- [ ] Backup БД
- [ ] Health checks
- [ ] Metrics (Prometheus)

### Performance

- [ ] Кешування (Redis)
- [ ] Індекси в БД
- [ ] Connection pooling
- [ ] Compression (gzip)
- [ ] CDN для статики

---

## 📊 Статистика проекту

```
Файлів коду:          ~15
Рядків коду:          ~1500
API endpoints:        11
Таблиць БД:           2
Docker images:        2
Час деплою:           ~3 хвилини
Розмір Docker image:  ~15 MB (production)
```

---

## 🎓 Що ви навчилися?

Працюючи з цим проектом, ви освоїли:

### Dart Backend
- ✅ Shelf framework
- ✅ Routing та middleware
- ✅ MVC архітектура
- ✅ Асинхронне програмування (async/await)
- ✅ Error handling

### Бази даних
- ✅ PostgreSQL
- ✅ SQL запити
- ✅ Міграції (через код)
- ✅ Зв'язки (Foreign Keys)
- ✅ Transactions

### Docker
- ✅ Dockerfile
- ✅ Docker Compose
- ✅ Multi-stage builds
- ✅ Контейнеризація додатків
- ✅ Volumes та networks

### DevOps
- ✅ Git/GitHub
- ✅ Деплой на Railway
- ✅ Environment variables
- ✅ CI/CD (через git push)
- ✅ Production налаштування

### API Design
- ✅ RESTful API
- ✅ HTTP методи (GET, POST, PUT, DELETE)
- ✅ Status codes
- ✅ JSON responses
- ✅ CORS

---

## 📚 Документація

Весь проект детально задокументований:

1. **[GETTING_STARTED.md](./GETTING_STARTED.md)** ⭐ - Почніть звідси!
   - Повний гайд від встановлення до деплою
   - Крок за кроком з поясненнями
   - Ідеально для початківців

2. **[README.md](./README.md)** - Основна документація
   - Огляд проекту
   - API endpoints
   - Швидкі команди

3. **[PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)** - Цей файл
   - Архітектура системи
   - Схема бази даних
   - Технічні деталі

4. **[CHANGELOG.md](./CHANGELOG.md)** - Історія змін
   - Всі версії
   - Що додано/змінено/виправлено

---

## 🌟 Фічі проекту

### Що вже працює ✅

- ✅ Реєстрація та логін користувачів
- ✅ CRUD операції для todos
- ✅ PostgreSQL база даних
- ✅ Docker підтримка
- ✅ Railway деплой
- ✅ CORS підтримка
- ✅ Health check endpoint
- ✅ Логування запитів
- ✅ Environment variables
- ✅ Production ready
- ✅ Автоматичний SSL (Railway)
- ✅ Auto-deploy з GitHub

### В розробці 🚧

- 🚧 JWT авторизація
- 🚧 Хешування паролів
- 🚧 Email верифікація
- 🚧 Rate limiting
- 🚧 Автоматичні тести
- 🚧 API documentation (Swagger)

---

## 🤝 Команда

Проект створений як навчальний приклад для вивчення Dart backend розробки.

**Створено:** 2025  
**Ліцензія:** MIT  
**Мова:** Українська 🇺🇦

---

**Готові почати? Відкрийте [GETTING_STARTED.md](./GETTING_STARTED.md)! 🚀**

