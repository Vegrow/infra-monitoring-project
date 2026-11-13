#!/bin/bash

LOG_FILE="access.log"
echo "Генерация тестового файла $LOG_FILE "

URLS=(
    "/api/users"
    "/api/login"
    "/index.html"
)

METHODS=("GET" "POST" "PUT" "DELETE")
CODES=(200 201 301 400 401 500 501)

> "$LOG_FILE"

for i in $(seq 1 350); do
    IP=$"10.10.10.$((RANDOM % 256))"
    URL=${URLS[$((RANDOM % ${#URLS[@]}))]}
    METHOD=${METHODS[$((RANDOM % ${#METHODS[@]}))]}
    CODE=${CODES[$((RANDOM % ${#CODES[@]}))]}

    printf '%s - - [15/Aug/2026:10:%02d:%02d] "%s %s HTTP/1.1" %d\n' \
        "$IP" \
        $((i / 60)) \
        $((i % 60)) \
        "$METHOD" "$URL" "$CODE" >> "$LOG_FILE"
done

echo "Файл $LOG_FILE создан."
echo "-----------------------------------"
echo "Общее количество запросов:"

TOTAL=$(grep -Ec \
    '^[0-9]{1,3}(\.[0-9]{1,3}){3} - - \[' "$LOG_FILE")

echo "$TOTAL"
echo "-----------------------------------"
echo "ТОП-3 IP-адреса по количеству запросов:"
grep -Eo \
    '^[0-9]{1,3}(\.[0-9]{1,3}){3}' "$LOG_FILE" |
    sort |
    uniq -c |
    sort -nr |
    head -3
echo "-----------------------------------"
echo "Количество запросов с кодами 4xx:"

COUNT_4XX=$(awk '$NF ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

echo "$COUNT_4XX"
echo "-----------------------------------"
echo "Количество запросов с кодами 5xx:"

COUNT_5XX=$(awk '$NF ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

echo "$COUNT_5XX"
