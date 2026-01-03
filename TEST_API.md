# 🧪 Тестування API на Render

Ваш API доступний за адресою: **https://todo-backend-byzk.onrender.com**

---

## 🚀 Швидкий старт

### 1. Health Check (перевірка що API працює)

```bash
curl https://todo-backend-byzk.onrender.com/api/health
```

Або відкрийте в браузері:
```
https://todo-backend-byzk.onrender.com/api/health
```

**Очікувана відповідь:**
```json
{"status":"ok","timestamp":"2024-01-01T00:00:00.000Z"}
```

---

## 👤 Реєстрація та авторизація

### 2. Реєстрація нового користувача

```bash
curl -X POST https://todo-backend-byzk.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Очікувана відповідь:**
```json
{
  "id": "user-id-here",
  "username": "testuser",
  "email": "test@example.com"
}
```

**Збережіть `id` - він потрібен для авторизації!**

### 3. Вхід (Login)

```bash
curl -X POST https://todo-backend-byzk.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

**Очікувана відповідь:**
```json
{
  "id": "user-id-here",
  "username": "testuser",
  "email": "test@example.com"
}
```

### 4. Отримати профіль (потрібна авторизація)

```bash
# Замініть YOUR-USER-ID на id з реєстрації
curl -X GET https://todo-backend-byzk.onrender.com/api/auth/profile \
  -H "Authorization: YOUR-USER-ID"
```

---

## 📝 Робота з Todos

### 5. Отримати всі todos

```bash
curl https://todo-backend-byzk.onrender.com/api/todos/all
```

### 6. Отримати todos користувача

```bash
# Замініть YOUR-USER-ID на id користувача
curl https://todo-backend-byzk.onrender.com/api/todos/user/YOUR-USER-ID
```

### 7. Створити todo (потрібна авторизація)

```bash
curl -X POST https://todo-backend-byzk.onrender.com/api/todos/create \
  -H "Content-Type: application/json" \
  -H "Authorization: YOUR-USER-ID" \
  -d '{
    "title": "Вивчити Dart",
    "description": "Зробити backend додаток на Dart",
    "isCompleted": false
  }'
```

**Очікувана відповідь:**
```json
{
  "id": "todo-id-here",
  "title": "Вивчити Dart",
  "description": "Зробити backend додаток на Dart",
  "isCompleted": false,
  "userId": "YOUR-USER-ID",
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

**Збережіть `id` todo для наступних операцій!**

### 8. Отримати todo за ID

```bash
# Замініть TODO-ID на id todo
curl https://todo-backend-byzk.onrender.com/api/todos/get/TODO-ID
```

### 9. Оновити todo (потрібна авторизація)

```bash
curl -X PUT https://todo-backend-byzk.onrender.com/api/todos/update/TODO-ID \
  -H "Content-Type: application/json" \
  -H "Authorization: YOUR-USER-ID" \
  -d '{
    "title": "Вивчити Dart (оновлено)",
    "description": "Оновлений опис",
    "isCompleted": true
  }'
```

### 10. Видалити todo (потрібна авторизація)

```bash
curl -X DELETE https://todo-backend-byzk.onrender.com/api/todos/delete/TODO-ID \
  -H "Authorization: YOUR-USER-ID"
```

---

## 📋 Повний приклад робочого потоку

```bash
# 1. Перевірка що API працює
curl https://todo-backend-byzk.onrender.com/api/health

# 2. Реєстрація користувача
USER_RESPONSE=$(curl -s -X POST https://todo-backend-byzk.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "demo",
    "email": "demo@example.com",
    "password": "demo123"
  }')

# Витягнути user ID (потрібно встановити jq або використати інший спосіб)
# USER_ID=$(echo $USER_RESPONSE | jq -r '.id')

# 3. Створити todo
curl -X POST https://todo-backend-byzk.onrender.com/api/todos/create \
  -H "Content-Type: application/json" \
  -H "Authorization: YOUR-USER-ID" \
  -d '{
    "title": "Тестовий todo",
    "description": "Це тестовий запис",
    "isCompleted": false
  }'

# 4. Отримати всі todos користувача
curl https://todo-backend-byzk.onrender.com/api/todos/user/YOUR-USER-ID
```

---

## 🌐 Тестування через браузер

Деякі endpoints можна протестувати прямо в браузері:

1. **Health Check:**
   ```
   https://todo-backend-byzk.onrender.com/api/health
   ```

2. **Всі todos:**
   ```
   https://todo-backend-byzk.onrender.com/api/todos/all
   ```

3. **Todos користувача:**
   ```
   https://todo-backend-byzk.onrender.com/api/todos/user/YOUR-USER-ID
   ```

---

## 🧪 Тестування через Postman / Insomnia

### Налаштування:

1. **Base URL:** `https://todo-backend-byzk.onrender.com`
2. **Headers для авторизованих запитів:**
   ```
   Authorization: YOUR-USER-ID
   Content-Type: application/json
   ```

### Колекція запитів:

1. `GET /api/health`
2. `POST /api/auth/register` (з body)
3. `POST /api/auth/login` (з body)
4. `GET /api/auth/profile` (з Authorization header)
5. `GET /api/todos/all`
6. `GET /api/todos/user/{userId}`
7. `POST /api/todos/create` (з Authorization header та body)
8. `GET /api/todos/get/{id}`
9. `PUT /api/todos/update/{id}` (з Authorization header та body)
10. `DELETE /api/todos/delete/{id}` (з Authorization header)

---

## ⚠️ Важливі примітки

1. **Авторизація:** Для захищених endpoints потрібен заголовок `Authorization: YOUR-USER-ID`
2. **Content-Type:** Для POST/PUT запитів завжди вказуйте `Content-Type: application/json`
3. **Перший запит:** На безкоштовному плані Render перший запит після "засинання" може займати 30-60 секунд
4. **CORS:** Якщо тестуєте з фронтенду, переконайтесь що `ALLOWED_ORIGINS` налаштовано правильно

---

## 🐛 Вирішення проблем

### Помилка: Connection timeout

**Рішення:** Сервіс "спить" на безкоштовному плані. Зачекайте 30-60 секунд і спробуйте знову.

### Помилка: 401 Unauthorized

**Рішення:** Перевірте що ви передаєте правильний `Authorization: YOUR-USER-ID` заголовок.

### Помилка: 404 Not Found

**Рішення:** Перевірте правильність URL та endpoint.

### Помилка: 500 Internal Server Error

**Рішення:** Перевірте логи в Render Dashboard → ваш сервіс → Logs.

---

## 📚 Корисні команди

### Перевірка статусу через bash скрипт:

```bash
#!/bin/bash
API_URL="https://todo-backend-byzk.onrender.com"

echo "Testing API: $API_URL"
echo ""

echo "1. Health Check:"
curl -s "$API_URL/api/health" | jq .
echo ""

echo "2. All Todos:"
curl -s "$API_URL/api/todos/all" | jq .
```

---

**Готово! 🎉 Тепер ви можете тестувати ваш API!**






