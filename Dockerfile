FROM openjdk:11-jre
WORKDIR deploy/
CMD nohup java -jar /home/ubuntu/deploy/spring-petclinic-2.7.3.jar >> nohup.out 2>&1 &
