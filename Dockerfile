FROM openjdk:11-jre
RUN rm -rf deploy
RUN mkdir deploy
WORKDIR deploy
COPY target/*.jar deploy/app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
