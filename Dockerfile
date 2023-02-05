FROM openjdk:11-jre
WORKDIR deploy
COPY target/*.jar app.jar
CMD nohup java -jar /home/ubuntu/deploy/app.jar >> nohup.out 2>&1 &
