# Todo Backend API

Бекенд для Todo додатку на Dart з використанням Shelf фреймворку.

## 🚀 Швидкий старт

### 1. Встановлення залежностей
```bash
dart pub get
```

### 2. Налаштування PostgreSQL
Створіть базу даних PostgreSQL та оновіть параметри підключення в `lib/services/database_service.dart`:
```dart
_connection = await Connection.open(
  Endpoint(
    host: 'localhost',      // Ваш хост
    port: 5432,            // Ваш порт
    database: 'your_db',    // Назва БД
    username: 'your_user',  // Користувач
    password: 'your_pass',  // Пароль
  ),
);
```

### 3. Запуск сервера
```bash
dart run bin/server.dart
```

## 📡 API Endpoints

### Health Check
- **GET** `/api/health` - Перевірка стану сервера

### Todos
- **GET** `/api/todos` - Отримати всі todos
- **POST** `/api/todos` - Створити новий todo
- **GET** `/api/todos/{id}` - Отримати todo за ID
- **PUT** `/api/todos/{id}` - Оновити todo
- **DELETE** `/api/todos/{id}` - Видалити todo

## 🔧 Кодогенерація (Опціонально)

Для використання автоматичної генерації роутів:

### 1. Встановіть залежності
```bash
dart pub get
```

### 2. Запустіть кодогенерацію
```bash
dart run build_runner build
```

### 3. Використовуйте згенеровані роути
Замість `lib/routes/api_routes.dart` використовуйте `lib/routes/api_routes_generated.dart`

## 🧪 Тестування API

### Створити todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Dart", "description": "Study backend development"}'
```

### Отримати всі todos
```bash
curl http://localhost:8080/api/todos
```

### Оновити todo
```bash
curl -X PUT http://localhost:8080/api/todos/{uuid} \
  -H "Content-Type: application/json" \
  -d '{"is_completed": true}'
```

### Видалити todo
```bash
curl -X DELETE http://localhost:8080/api/todos/{uuid}
```

## 🐳 Docker

### Збірка
```bash
docker build -t todo-backend .
```

### Запуск
```bash
docker run -p 8080:8080 todo-backend
```

## 📁 Структура проєкту

```
lib/
├── models/
│   └── todo.dart              # Модель Todo
├── services/
│   ├── database_service.dart  # Підключення до PostgreSQL
│   └── todo_service.dart      # CRUD операції
├── controllers/
│   └── todo_controller.dart   # HTTP обробники
└── routes/
    ├── api_routes.dart         # Ручні роути
    └── api_routes_generated.dart # Згенеровані роути
```

## 🔄 Переваги кодогенерації

✅ **Типобезпека** - компілятор перевіряє правильність роутів  
✅ **Автодоповнення** - IDE підказує доступні методи  
✅ **Рефакторинг** - автоматичне оновлення при зміні назв  
✅ **Документація** - автоматична генерація OpenAPI схем  
✅ **Валідація** - перевірка параметрів на етапі компіляції  

## 🚀 Деплой

### Render/Railway
1. Підключіть PostgreSQL базу
2. Встановіть змінні середовища:
   - `DATABASE_HOST`
   - `DATABASE_PORT` 
   - `DATABASE_NAME`
   - `DATABASE_USER`
   - `DATABASE_PASSWORD`
3. Задеплойте через Git
