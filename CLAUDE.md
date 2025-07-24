# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Elasticsearch deployment with Chinese IK (Intelligent Keyword) analyzer plugin, containerized using Docker Compose. The project sets up Elasticsearch 8.11.0 with the IK Chinese text analyzer for improved Chinese language search capabilities, along with Kibana for visualization.

## Development Commands

### Service Management
- Start services: `./start.sh` or `docker compose up -d --build`
- Stop services: `./stop.sh` or `docker compose down`  
- Restart services: `./restart.sh`

### Testing IK Analyzer
Test the Chinese text segmentation:
```bash
curl -X POST "http://localhost:9200/_analyze" -H 'Content-Type: application/json' -d'{"analyzer": "ik_max_word", "text": "我是中国人"}'
```

### Health Checks
- Elasticsearch health: `curl http://localhost:9200/_cluster/health`
- Check installed plugins: `curl http://localhost:9200/_cat/plugins`
- View service status: `docker compose ps`

## Architecture

### Services
- **Elasticsearch**: Main search engine with IK analyzer plugin on port 9200
- **Kibana**: Web UI for Elasticsearch on port 5601

### Key Configuration Files
- `docker-compose.yml`: Service orchestration with memory optimization for M1 chips
- `Dockerfile`: Custom Elasticsearch image with IK plugin installation
- `config/elasticsearch.yml`: Elasticsearch configuration with CORS and performance tuning
- `config/analysis-ik/IKAnalyzer.cfg.xml`: IK analyzer configuration
- `config/analysis-ik/custom.dic`: Custom dictionary for additional terms
- `config/analysis-ik/stopword.dic`: Stop words dictionary

### Data Persistence
- `es_data` volume: Elasticsearch data persistence
- `./logs`: Elasticsearch logs
- `./data`: Local data directory (mounted to container)

### Security Configuration
- XPack security disabled (development environment)
- CORS enabled for cross-origin requests
- Memory limits: 1GB heap size optimized for development

## IK Analyzer Features
- `ik_max_word`: Maximum granularity segmentation
- `ik_smart`: Smart segmentation mode
- Custom dictionary support for domain-specific terms
- Stop words filtering for Chinese text