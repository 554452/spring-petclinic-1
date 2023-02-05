FROM openjdk:11-jre
USER root
COPY target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
