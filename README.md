# Main Platform v1.0.0

Full-stack platform running on Oracle Cloud Infrastructure Always-Free tier.

## 🚀 Production Status

**FULLY OPERATIONAL** - All services running and healthy

- **Live URL**: http://79.72.47.188
- **API Endpoint**: http://79.72.47.188/api
- **Traefik Dashboard**: http://79.72.47.188:8080
- **Monitoring**: http://79.72.47.188:3000

## 🛠️ Tech Stack

- **Reverse Proxy**: Traefik v3.0
- **Backend**: Node.js + Fastify + TypeScript
- **Frontend**: Static HTML (Vue-ready)
- **Database**: PostgreSQL 16
- **Cache**: Redis 7
- **Monitoring**: Prometheus + Grafana
- **Orchestration**: Docker Compose

## 📋 Quick Start

```bash
# Clone repository
git clone https://github.com/Spen-Zosky/main-platform.git
cd main-platform

# Setup configuration
cp .env.example config.env
# Edit config.env with your values

# Deploy
./scripts/deploy.sh

# Check status
docker compose ps
📊 Architecture
See fullstack-architecture-doc-en-v3.md for complete documentation.
👤 Author
Enzo Spenuso (@Spen-Zosky)
📝 License
MIT
