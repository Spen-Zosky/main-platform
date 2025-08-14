#!/bin/bash

# Load environment
source config.env
export DB_USER DB_NAME DB_PASS JWT_SECRET GRAFANA_PASS PUBLIC_IP

echo "🚀 Starting deployment..."

# Pull images
echo "📦 Pulling Docker images..."
docker compose pull

# Build services
echo "🔨 Building services..."
docker compose build --no-cache

# Start services
echo "🏃 Starting services..."
docker compose up -d

# Wait for database
echo "⏳ Waiting for database..."
sleep 10

# Initialize database
echo "🗄️ Initializing database..."
docker compose exec -T db psql -U $DB_USER -d $DB_NAME << SQL
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SQL

echo "✅ Deployment complete!"
echo ""
docker compose ps
echo ""
echo "🌐 Access Points:"
echo "   Application:  http://${PUBLIC_IP}"
echo "   API:         http://${PUBLIC_IP}/api"
echo "   Traefik:     http://${PUBLIC_IP}:8080"
echo "   Grafana:     http://${PUBLIC_IP}:3000 (admin / ${GRAFANA_PASS})"
echo "   Prometheus:  http://${PUBLIC_IP}:9090"
