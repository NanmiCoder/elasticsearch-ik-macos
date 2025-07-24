#!/bin/bash

echo "正在启动 Elasticsearch + IK 分词器..."

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "错误: Docker 未运行，请先启动 Docker"
    exit 1
fi

# 设置权限
sudo chown -R 1000:1000 data logs config 2>/dev/null || true

# 构建并启动服务
echo "构建镜像并启动服务..."
docker compose up -d --build

echo "等待服务启动..."
sleep 30

# 检查服务状态
echo "检查服务状态..."
docker compose ps

# 检查Elasticsearch健康状态
echo "检查 Elasticsearch 健康状态..."
for i in {1..10}; do
    if curl -s http://localhost:9200/_cluster/health > /dev/null; then
        echo "✅ Elasticsearch 启动成功!"
        break
    else
        echo "⏳ 等待 Elasticsearch 启动... ($i/10)"
        sleep 10
    fi
done

# 检查IK插件
echo "检查 IK 分词器插件..."
curl -s http://localhost:9200/_cat/plugins

echo ""
echo "🎉 安装完成!"
echo "Elasticsearch: http://localhost:9200"
echo "Kibana: http://localhost:5601"
echo ""
echo "测试IK分词器:"
echo "curl -X POST \"http://localhost:9200/_analyze\" -H 'Content-Type: application/json' -d'{\"analyzer\": \"ik_max_word\", \"text\": \"我是中国人\"}'"
