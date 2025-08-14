# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Backend Development
```bash
# Build TypeScript backend
cd backend && npm run build

# Run backend in development mode (with hot reload)
cd backend && npm run dev

# Start production backend
cd backend && npm start
```

### Docker Operations
```bash
# Deploy entire stack
./deploy.sh

# View all services status
docker compose ps

# View logs for specific service
docker compose logs -f [service_name]  # services: traefik, db, redis, backend, frontend, prometheus, grafana

# Rebuild and restart services
docker compose build --no-cache && docker compose up -d

# Stop all services
docker compose down

# Stop and remove volumes (WARNING: deletes data)
docker compose down -v
```

### Database Access
```bash
# Access PostgreSQL
docker compose exec db psql -U mainuser -d maindb

# Run SQL directly
docker compose exec -T db psql -U mainuser -d maindb -c "SELECT * FROM users;"
```

### Monitoring
- Traefik Dashboard: http://79.72.47.188:8080
- Grafana: http://79.72.47.188:3000 (credentials in config.env)
- Prometheus: http://79.72.47.188:9090

## Architecture

### Service Communication Flow
1. **Traefik** (port 80/8080) - Reverse proxy that routes all incoming traffic
   - Routes `/api/*` to backend service (strips `/api` prefix)
   - Routes `/` to frontend service
   - Provides dashboard on port 8080

2. **Backend** (Fastify/TypeScript) - API server at `backend/src/index.ts`
   - Connects to PostgreSQL via `DATABASE_URL`
   - Connects to Redis via `REDIS_URL`
   - Exposes endpoints: `/`, `/health`, `/test`
   - Runs on port 3000 internally

3. **Frontend** - Static site served by nginx
   - Single page at `frontend/dist/index.html`
   - Served on port 80 internally

4. **Data Layer**
   - PostgreSQL 16: Primary database with `users` table
   - Redis 7: Cache layer with persistence

5. **Monitoring Stack**
   - Prometheus: Metrics collection
   - Grafana: Visualization dashboards

### Network Architecture
- **web network**: External-facing services (traefik, frontend, backend)
- **internal network**: Internal services (db, redis, prometheus, grafana)

### Key Configuration Files
- `config.env`: Environment variables (DB credentials, JWT secret, public IP)
- `docker-compose.yml`: Service definitions and orchestration
- `backend/tsconfig.json`: TypeScript configuration
- `monitoring/prometheus.yml`: Prometheus scrape configuration

### Database Schema
```sql
users table:
- id: SERIAL PRIMARY KEY
- email: VARCHAR(255) UNIQUE NOT NULL
- created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

## Development Workflow

### Adding New API Endpoints
1. Edit `backend/src/index.ts`
2. Rebuild: `docker compose build backend`
3. Restart: `docker compose restart backend`
4. Check logs: `docker compose logs -f backend`

### Updating Frontend
1. Edit `frontend/dist/index.html`
2. Rebuild: `docker compose build frontend`
3. Restart: `docker compose restart frontend`

### Environment Variables
Located in `config.env`:
- `DB_USER`, `DB_NAME`, `DB_PASS`: PostgreSQL credentials
- `JWT_SECRET`: Authentication secret
- `GRAFANA_PASS`: Grafana admin password
- `PUBLIC_IP`: Server public IP (79.72.47.188)

## Production Notes
- All services configured with `restart: unless-stopped`
- Health checks configured for db and redis
- Traefik handles routing based on IP address (79.72.47.188)
- Data persisted in Docker volumes: postgres_data, redis_data, prometheus_data, grafana_data