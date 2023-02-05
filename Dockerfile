FROM openjdk:11-jre
ENV JAVA_OPTS="-XX:InitialRAMPercentage=40.0 -XX:MaxRAMPercentage=80.0"
ADD ./deploy/app.jar /home/ubuntu/app.jar
CMD nohup java -jar /home/ubuntu/app.jar 1> /dev/null 2>&1
EXPOSE 8080
