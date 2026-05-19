.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: new
new: ## Railsアプリを生成（初回のみ）
	docker compose -f compose.development.yaml --env-file .env.development run --no-deps railsapp \
		rails new . --force --database=postgresql --css=tailwind --skip-test

.PHONY: up
up: ## コンテナを起動（http://localhost:3003）
	docker compose -f compose.development.yaml --env-file .env.development up -d
	@echo "アプリケーションが起動しました: http://localhost:3003"

.PHONY: down
down: ## コンテナを停止
	docker compose -f compose.development.yaml --env-file .env.development down --remove-orphans

.PHONY: bash
bash: ## railsappコンテナに入る
	docker compose -f compose.development.yaml --env-file .env.development exec railsapp bash

.PHONY: generate
generate: ## rails generateコマンド（例: make generate ARGS="model Foo"）
	docker compose -f compose.development.yaml --env-file .env.development exec railsapp rails generate $(ARGS)

.PHONY: migrate
migrate: ## マイグレーション実行
	docker compose -f compose.development.yaml --env-file .env.development exec railsapp rails db:migrate

.PHONY: clean
clean: ## Docker関連をクリーン
	docker compose -f compose.development.yaml --env-file .env.development down -v --rmi local
