pipeline {
    agent any
    tools {
        maven 'M3'
        jdk 'JDK11'
    }
    environment {
        DOCKER_IMAGE = "spring-petclinic/spring-petclinic"
        DOCKER_TAG = "1.0"
  }
    stages {
        stage('Git clone') {
            steps {
                git url: 'https://github.com/s4616/spring-petclinic.git', branch: 'main', credentialsId: 's4616'
            }
            post {
                success {
                    echo 'success clone project'
                }
                failure {
                    error 'fail clone project' // exit pipeline
                }
            }
        }
        
        stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml' 
                }
            }
        }
        
        stage ('Docker Build') {
            steps {
                dir("${env.WORKSPACE}") {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
            
            post {
                always {
                    echo "Docker build success!"
                }
            }
        }
        
    }
}
