#!/bin/bash

echo "正在重启服务..."
docker compose down
docker compose up -d

echo "服务重启完成"
