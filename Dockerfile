FROM openjdk:11-jre
WORKDIR deploy
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
CMD nohup java -jar /home/ubuntu/deploy/app.jar >> nohup.out 2>&1 &
