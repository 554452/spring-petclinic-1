FROM openjdk:11-jre
RUN rm -rf app
RUN mkdir -p app
WORKDIR app
ADD target/*.jar app/app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
