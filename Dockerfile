FROM adoptopenjdk/openjdk11
RUN mkdir -p /app
WORKDIR /app
ADD target/spring-petclinic-2.7.3.jar /app/spring-petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic.jar"]
