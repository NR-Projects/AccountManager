# Stage 1: Build the application using Maven
FROM maven:3.8.5-openjdk-17-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and the source code to the working directory
COPY pom.xml .
COPY src ./src

# Build the application using Maven
RUN mvn clean install -DskipTests

# Stage 2: Runtime image (no Maven)
FROM eclipse-temurin

# Expose port 8080
EXPOSE 8080

# Copy the application jar from the build stage
COPY --from=builder /app/target/account-management-server-0.0.1-SNAPSHOT.jar app.jar

# Set the entrypoint for the application
ENTRYPOINT ["java", "-jar", "app.jar"]
