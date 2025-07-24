FROM docker.elastic.co/elasticsearch/elasticsearch:8.11.0

# 设置工作目录
WORKDIR /usr/share/elasticsearch

# 安装必要的工具
USER root
RUN apt-get update && apt-get install -y curl wget && rm -rf /var/lib/apt/lists/*

# 切换到elasticsearch用户
USER elasticsearch

# 安装infinilabs版本的IK分词器
RUN bin/elasticsearch-plugin install --batch https://get.infini.cloud/elasticsearch/analysis-ik/8.11.0 || \
    bin/elasticsearch-plugin install --batch https://github.com/infinilabs/analysis-ik/releases/download/v8.11.0/elasticsearch-analysis-ik-8.11.0.zip

# 创建自定义配置目录
RUN mkdir -p config/analysis-ik

# 复制自定义配置文件
COPY --chown=elasticsearch:elasticsearch config/ config/custom/

# 暴露端口
EXPOSE 9200 9300

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:9200/_cluster/health || exit 1
