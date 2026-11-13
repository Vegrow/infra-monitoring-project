# Homework
Цели задания: Закрепить навыки написания Bash-скриптов, анализа сетевого трафика, работы с Git, настройки CI/CD и контейнеризации готовых сервисов.

## Что делалось

```bash
# Скрипты
chmod +x scripts/*.sh
./check_api.sh https://httpbin.org/status/200
./analyze_logs.sh

# Docker
docker-compose up -d
curl http://localhost:80
docker-compose down
```

## Безопасный деплой на удалённый сервер (SSH + SCP)

### 1. Генерация SSH-ключа

```bash
ssh-keygen -t ed25519 -C "Вася@стартап" -f ~/.ssh/id_ed25519_deploy
# Публичный ключ: ~/.ssh/id_ed25519_deploy.pub
```

### 2. Копирование публичного ключа на сервер

```bash
ssh-copy-id -i ~/.ssh/id_ed25519_deploy.pub user@server.example.com

# либо вручную:
cat ~/.ssh/id_ed25519_deploy.pub | ssh user@server.example.com \
    'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

### 3. Передача проекта через `scp` (архив)

```bash
# Локально: собрать архив без мусора
tar --exclude='.git' --exclude='*.log' --exclude='report/*.pcapng' \
    -czf infra-monitoring-project.tar.gz .

# Передать на сервер
scp infra-monitoring-project.tar.gz user@server.example.com:/opt/deploy/

# На сервере распаковать
ssh user@server.example.com 'cd /opt/deploy && tar -xzf infra-monitoring-project.tar.gz'
```

### 4. Передача через `tar` + `ssh` (без промежуточного файла)

```bash
tar -czf - --exclude='.git' --exclude='*.log' . \
  | ssh user@server.example.com 'mkdir -p /opt/deploy && tar -xzf - -C /opt/deploy'
```

### 5. Запуск на сервере

```bash
ssh user@server.example.com 'cd /opt/deploy && docker compose up -d'
```
