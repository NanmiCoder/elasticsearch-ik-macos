# Elasticsearch IK 中文分词器 (macOS 版本)

🔍 适用于 macOS (包括 M1/M2 芯片) 的 Elasticsearch + IK 中文分词器 Docker 配置

## 功能特性

- ✅ 支持 macOS Intel 和 Apple Silicon (M1/M2) 芯片
- ✅ Elasticsearch 8.11.0 + 官方 IK 分词器插件
- ✅ Kibana 8.11.0 数据可视化界面
- ✅ 开箱即用的 Docker Compose 配置
- ✅ 内存优化配置，适合开发环境
- ✅ 自定义词典支持

## 快速开始

### 环境要求

- Docker Desktop for Mac
- macOS 10.15+ (推荐 macOS 12+)
- 至少 4GB 可用内存

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/NanmiCoder/elasticsearch-ik-macos.git
   cd elasticsearch-ik-macos
   ```

2. **启动服务**
   ```bash
   # 使用脚本启动 (推荐)
   ./start.sh
   
   # 或直接使用 Docker Compose
   docker compose up -d --build
   ```

3. **验证安装**
   ```bash
   # 检查 Elasticsearch 状态
   curl http://localhost:9200/_cluster/health
   
   # 检查 IK 插件
   curl http://localhost:9200/_cat/plugins
   ```

### 访问地址

- **Elasticsearch**: http://localhost:9200
- **Kibana**: http://localhost:5601

## IK 分词器使用

### 基本测试

```bash
# ik_max_word 模式 (最大粒度分词)
curl -X POST "http://localhost:9200/_analyze" \
  -H 'Content-Type: application/json' \
  -d'{"analyzer": "ik_max_word", "text": "我是中国人"}'

# ik_smart 模式 (智能分词)
curl -X POST "http://localhost:9200/_analyze" \
  -H 'Content-Type: application/json' \
  -d'{"analyzer": "ik_smart", "text": "我是中国人"}'
```

### 分词模式对比

| 分词模式 | 说明 | 示例输出 |
|---------|------|----------|
| `ik_max_word` | 最大粒度分词，适合搜索 | 我/是/中国人/中国/国人 |
| `ik_smart` | 智能分词，适合索引 | 我/是/中国人 |

### 在索引中使用

```json
PUT /my_index
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ik_analyzer": {
          "type": "ik_max_word"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "content": {
        "type": "text",
        "analyzer": "ik_analyzer"
      }
    }
  }
}
```

## 自定义词典

### 添加自定义词汇

1. 编辑 `config/analysis-ik/custom.dic`，添加你的自定义词汇：
   ```
   弹性搜索
   机器学习
   人工智能
   ```

2. 重启 Elasticsearch 服务：
   ```bash
   docker compose restart elasticsearch
   ```

### 添加停用词

编辑 `config/analysis-ik/stopword.dic`，添加需要过滤的停用词：
```
的
了
是
```

## 服务管理

### 启动服务
```bash
./start.sh
# 或
docker compose up -d
```

### 停止服务
```bash
./stop.sh
# 或
docker compose down
```

### 重启服务
```bash
./restart.sh
# 或
docker compose restart
```

### 查看日志
```bash
# 查看 Elasticsearch 日志
docker compose logs elasticsearch

# 查看 Kibana 日志
docker compose logs kibana

# 实时跟踪日志
docker compose logs -f
```

## 故障排除

### 常见问题

1. **端口占用**
   ```bash
   # 检查端口占用
   lsof -i :9200
   lsof -i :5601
   ```

2. **内存不足**
   - 调整 `docker-compose.yml` 中的 `ES_JAVA_OPTS` 参数
   - 默认配置: `-Xms1g -Xmx1g` (可根据需要调整)

3. **权限问题**
   ```bash
   # 修复权限
   chmod -R 777 logs data config
   ```

4. **M1/M2 芯片兼容性**
   - 项目已配置 `platform: linux/amd64` 确保兼容性
   - 如遇问题，请确保 Docker Desktop 已更新到最新版本

### 健康检查

```bash
# Elasticsearch 健康状态
curl http://localhost:9200/_cluster/health?pretty

# 节点信息
curl http://localhost:9200/_nodes?pretty

# 插件列表
curl http://localhost:9200/_cat/plugins?v
```

## 配置说明

### 主要配置文件

- `docker-compose.yml`: 服务编排配置
- `config/elasticsearch.yml`: Elasticsearch 主配置
- `config/analysis-ik/IKAnalyzer.cfg.xml`: IK 分词器配置
- `config/analysis-ik/custom.dic`: 自定义词典
- `config/analysis-ik/stopword.dic`: 停用词典

### 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `ES_JAVA_OPTS` | JVM 参数 | `-Xms1g -Xmx1g` |
| `cluster.name` | 集群名称 | `elasticsearch-cluster` |
| `node.name` | 节点名称 | `es-node-1` |

## 性能优化

### 内存配置
根据你的机器配置调整内存设置：

```yaml
# 对于 8GB 内存的机器
- ES_JAVA_OPTS=-Xms2g -Xmx2g

# 对于 16GB 内存的机器  
- ES_JAVA_OPTS=-Xms4g -Xmx4g
```

### 生产环境建议

1. 启用 XPack 安全功能
2. 配置持久化数据卷
3. 设置适当的资源限制
4. 配置监控和日志收集

## 贡献

欢迎提交 Issue 和 Pull Request！

### 开发环境设置

1. Fork 本项目
2. 创建特性分支: `git checkout -b feature/your-feature`
3. 提交改动: `git commit -am 'Add your feature'`
4. 推送分支: `git push origin feature/your-feature`
5. 提交 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 致谢

- [Elasticsearch](https://www.elastic.co/)
- [IK Analysis Plugin](https://github.com/infinilabs/analysis-ik)
- [Docker](https://www.docker.com/)

## 更新日志

### v1.0.0 (2025-07-24)
- 🎉 初始版本发布
- ✅ 支持 macOS M1/M2 芯片
- ✅ Elasticsearch 8.11.0 + IK 分词器
- ✅ Kibana 数据可视化
- ✅ 开箱即用的 Docker 配置

---

📧 如有问题，请提交 [Issue](https://github.com/NanmiCoder/elasticsearch-ik-macos/issues)

⭐ 如果这个项目对你有帮助，请给个 Star！
