# ---------------------------
# Stage 1: Build .war file
# ---------------------------
# Use a Maven/Java 17 image (matches your pom.xml) to build the project
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy the pom.xml first to cache dependencies1
COPY pom.xml .

# Copy the rest of your source code
COPY src ./src

# Build the .war file using Maven. This reads your pom.xml.
# This will create the file /app/target/StudentRegistration.war
RUN mvn clean package -DskipTests

# ---------------------------
# Stage 2: Run the application (ON TOMCAT)
# ---------------------------
# Use the official Tomcat 10.1 image with JDK 17
FROM tomcat:10.1-jdk17-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your custom server.xml (as you requested)
COPY server.xml /usr/local/tomcat/conf/server.xml

# Copy the .war file from the 'builder' stage
# And deploy it as ROOT.war (which is best practice)
COPY --from=builder /app/target/aumsccs.war /usr/local/tomcat/webapps/ROOT.war

# Expose the standard Tomcat port
EXPOSE 8080

# The base image already has the CMD to start Tomcat

