#FROM eclipse-temurin:17-jdk-alpine
#
#EXPOSE 8080
#
#ENV APP_HOME /usr/src/app
#
#COPY target/*.jar $APP_HOME/app.jar
#
#WORKDIR $APP_HOME
#
#CMD ["java", "-jar", "app.jar"]


# Stage 1: Build the application using standard Maven
FROM eclipse-temurin:17-jdk-alpine as builder

# Install Maven
RUN apk add --no-cache maven

# Set the working directory in the container
WORKDIR /workspace/app

# Copy the pom.xml and source code into the image
COPY pom.xml .
COPY src src

# Build the application
RUN mvn install -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine

# Expose port 8080 for the application
EXPOSE 8080

# Set environment variable for application home
ENV APP_HOME /usr/src/app

# Create application directory
RUN mkdir -p $APP_HOME

# Copy only the built jar file from the builder stage
COPY --from=builder /workspace/app/target/*.jar $APP_HOME/app.jar

# Set the working directory in the container
WORKDIR $APP_HOME

# Command to run the application
CMD ["java", "-jar", "app.jar"]


