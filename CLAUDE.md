# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TeeStudio is an AI-driven custom merchandise e-commerce platform built as a **multi-module Maven microservices** project using Spring Boot 3.2 and Java 17. Six services communicate behind an API Gateway, deployed to AWS ECS Fargate.

## Build & Run Commands

```bash
# Build all modules (skip tests during development)
mvn clean package -DskipTests

# Run a specific service
mvn -pl api-gateway spring-boot:run
mvn -pl user-service spring-boot:run
mvn -pl product-service spring-boot:run
mvn -pl design-service spring-boot:run
mvn -pl cart-service spring-boot:run
mvn -pl order-service spring-boot:run

# Run all tests
mvn clean test

# Run tests for a single service
mvn -pl user-service test

# Run a single test class
mvn -pl user-service test -Dtest=UserServiceTest

# Docker build (builds api-gateway only for ECS)
docker build -t teestudio .
docker run -p 8080:8080 teestudio
```

The user-service requires the env var `SPRING_DATASOURCE_PASSWORD` pointing to the shared RDS instance.

## Architecture

### Service Ports
| Service | Port | DB | Notes |
|---------|------|----|-------|
| api-gateway | 8080 | No | Entry point; JWT validation, routing |
| user-service | 8081 | Yes (JPA + Flyway) | Only service with DB configured so far |
| product-service | 8082 | No | Stub; planned Redis caching |
| design-service | 8083 | No | Stub; planned Kafka + S3 + Rekognition |
| cart-service | 8084 | No | Stub; calls Product Service via HTTP |
| order-service | 8085 | No | Stub; planned Stripe + Kafka |

### API Gateway
All external traffic enters via the gateway (`/actuator/health` for ALB health checks). The gateway validates Cognito-issued JWTs and enforces CUSTOMER/ADMIN role-based routing before proxying to downstream services.

### Database
Single shared RDS PostgreSQL instance (`teestudio.cx82akg0y5hs.us-west-1.rds.amazonaws.com:5432`). Each service manages its own tables via Flyway migrations located at `src/main/resources/db/migration/`. JPA DDL is set to `validate` (never auto-create). Only `user-service` has DB configured so far; add JPA + Flyway dependencies from its `pom.xml` when adding DB to other services.

### Async & Caching (Planned)
- **Kafka**: Design Service publishes `design-job` topic; Order Service publishes `order-placed`
- **Redis**: Product Service caches catalog; Gateway caches user lookups
- **AWS Cognito**: Customer authentication — gateway validates tokens, never individual services

## Package Structure Convention

All services share the base package `com.example.teestudio.<service-name>`. Each service has:
- `*Application.java` — main class
- `controller/` — REST controllers
- `entity/` — JPA entities (if DB-enabled)
- `repository/` — Spring Data repositories (if DB-enabled)
- `service/` — business logic (as implemented)

## Deployment

**CI/CD**: Push to `main` triggers `.github/workflows/deploy-ecs.yml` — builds Docker image, pushes to ECR (`us-west-1`), deploys CloudFormation stack `teestudio-stack`.

Required GitHub Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. Optional: `DOMAIN_NAME`, `CERTIFICATE_ARN` for HTTPS.

The Dockerfile only packages `api-gateway`. Multi-service ECS deployment is planned in Phase 8.

## Implementation Phases (PLAN.md)

1. ✅ Repo layout, shared DB, API Gateway skeleton
2. 🔄 User Service (registration, login, confirm, password reset)
3. Product Service (catalog, variants, Redis cache)
4. Design Service (Kafka, AI pipeline, S3, Rekognition)
5. Cart Service (CRUD, HTTP calls to Product Service)
6. Order Service (Stripe webhook, Kafka)
7. React Frontend (Design Lab, checkout, Cognito UI)
8. AWS Production (Route 53, RDS, MSK, multi-service ECS)
9. (Optional) Semantic search, AI reviews, shopping assistant
