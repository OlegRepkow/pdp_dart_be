.PHONY: help install run dev build test docker-build docker-run docker-compose-up docker-compose-down clean deploy-railway

# Кольори для виводу
GREEN  := \033[0;32m
YELLOW := \033[0;33m
NC     := \033[0m # No Color

help: ## Показати цю довідку
	@echo "$(GREEN)Доступні команди:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Встановити залежності
	@echo "$(GREEN)Встановлення залежностей...$(NC)"
	dart pub get

run: ## Запустити сервер
	@echo "$(GREEN)Запуск сервера...$(NC)"
	dart run bin/server.dart

dev: ## Запустити в режимі розробки (з hot reload)
	@echo "$(GREEN)Запуск в режимі розробки...$(NC)"
	dart run --observe bin/server.dart

build: ## Зібрати проект
	@echo "$(GREEN)Збірка проекту...$(NC)"
	dart compile exe bin/server.dart -o bin/server

generate: ## Згенерувати код (routes)
	@echo "$(GREEN)Генерація коду...$(NC)"
	dart run build_runner build --delete-conflicting-outputs

watch: ## Watch mode для генерації коду
	@echo "$(GREEN)Watch mode...$(NC)"
	dart run build_runner watch --delete-conflicting-outputs

test: ## Запустити тести
	@echo "$(GREEN)Запуск тестів...$(NC)"
	dart test

format: ## Форматувати код
	@echo "$(GREEN)Форматування коду...$(NC)"
	dart format .

analyze: ## Аналіз коду
	@echo "$(GREEN)Аналіз коду...$(NC)"
	dart analyze

fix: ## Автоматичне виправлення проблем
	@echo "$(GREEN)Виправлення коду...$(NC)"
	dart fix --apply

lint: format analyze ## Форматування та аналіз

docker-build: ## Збудувати Docker образ
	@echo "$(GREEN)Збірка Docker образу...$(NC)"
	docker build -t todo-backend .

docker-run: ## Запустити Docker контейнер
	@echo "$(GREEN)Запуск Docker контейнера...$(NC)"
	docker run -p 8080:8080 \
		-e DB_HOST=host.docker.internal \
		-e DB_PORT=5432 \
		-e DB_NAME=postgres \
		-e DB_USER=postgres \
		-e DB_PASSWORD=mysecretpassword \
		todo-backend

docker-compose-up: ## Запустити через Docker Compose
	@echo "$(GREEN)Запуск через Docker Compose...$(NC)"
	docker-compose up -d

docker-compose-down: ## Зупинити Docker Compose
	@echo "$(GREEN)Зупинка Docker Compose...$(NC)"
	docker-compose down

docker-compose-logs: ## Переглянути логи Docker Compose
	docker-compose logs -f

docker-compose-restart: ## Перезапустити Docker Compose
	@echo "$(GREEN)Перезапуск Docker Compose...$(NC)"
	docker-compose restart

docker-clean: ## Очистити Docker
	@echo "$(GREEN)Очищення Docker...$(NC)"
	docker-compose down -v
	docker rmi todo-backend 2>/dev/null || true

clean: ## Очистити build артефакти
	@echo "$(GREEN)Очищення...$(NC)"
	rm -rf build/
	rm -rf .dart_tool/
	rm -f bin/server

setup-env: ## Створити .env файл
	@if [ ! -f .env ]; then \
		echo "$(GREEN)Створення .env файлу...$(NC)"; \
		cp env.example .env; \
		echo "$(YELLOW)Відредагуйте .env файл!$(NC)"; \
	else \
		echo "$(YELLOW).env файл вже існує$(NC)"; \
	fi

# Railway команди (потрібен railway CLI)
deploy-railway: ## Деплой на Railway
	@echo "$(GREEN)Деплой на Railway...$(NC)"
	railway up

railway-logs: ## Переглянути логи Railway
	railway logs

railway-vars: ## Переглянути змінні Railway
	railway variables

railway-open: ## Відкрити проект Railway в браузері
	railway open

# Корисні команди
health-check: ## Перевірити health endpoint
	@echo "$(GREEN)Перевірка health check...$(NC)"
	curl -s http://localhost:8080/api/health | jq . || curl -s http://localhost:8080/api/health

test-api: ## Тестування API (локально)
	@echo "$(GREEN)Тестування API...$(NC)"
	@echo "\n$(YELLOW)1. Health Check:$(NC)"
	curl -s http://localhost:8080/api/health | jq .
	@echo "\n$(YELLOW)2. Реєстрація користувача:$(NC)"
	curl -s -X POST http://localhost:8080/api/auth/register \
		-H "Content-Type: application/json" \
		-d '{"username":"testuser","email":"test@example.com","password":"test123"}' | jq .

# Повний цикл розробки
all: clean install lint test build ## Повний цикл: clean -> install -> lint -> test -> build

# Швидкий старт
quickstart: install setup-env docker-compose-up ## Швидкий старт з Docker Compose
	@echo "$(GREEN)✓ Проект готовий!$(NC)"
	@echo "$(YELLOW)API доступний на: http://localhost:8080$(NC)"
	@echo "$(YELLOW)Health check: http://localhost:8080/api/health$(NC)"
	@sleep 3
	@make health-check

# Development workflow
dev-start: docker-compose-up run ## Запустити PostgreSQL та backend

# Production build
prod-build: clean install test docker-build ## Production збірка з тестами

# CI/CD simulation
ci: install lint test build ## Симуляція CI/CD pipeline
	@echo "$(GREEN)✓ CI pipeline пройшов успішно!$(NC)"

