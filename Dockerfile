# Build stage – multi-module: build api-gateway (port 8080) for ECS
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
COPY api-gateway ./api-gateway
COPY user-service ./user-service
COPY product-service ./product-service
COPY design-service ./design-service
COPY cart-service ./cart-service
COPY order-service ./order-service

RUN mvn clean package -DskipTests -pl api-gateway

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/api-gateway/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
