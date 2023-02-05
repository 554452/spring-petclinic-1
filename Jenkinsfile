pipeline {
    agent any
    tools {
        maven 'M3'
        jdk 'JDK11'
    }
    parameters {
      booleanParam(name : 'BUILD_DOCKER_IMAGE', defaultValue : true, description : 'BUILD_DOCKER_IMAGE')
      booleanParam(name : 'RUN_TEST', defaultValue : true, description : 'RUN_TEST')
      booleanParam(name : 'PUSH_DOCKER_IMAGE', defaultValue : true, description : 'PUSH_DOCKER_IMAGE')
      booleanParam(name : 'PROMPT_FOR_DEPLOY', defaultValue : false, description : 'PROMPT_FOR_DEPLOY')
      booleanParam(name : 'DEPLOY_WORKLOAD', defaultValue : true, description : 'DEPLOY_WORKLOAD')

      // CI
      string(name : 'AWS_ACCOUNT_ID', defaultValue : '257307634175', description : 'AWS_ACCOUNT_ID')
      string(name : 'DOCKER_IMAGE_NAME', defaultValue : 'spring-petclinic', description : 'DOCKER_IMAGE_NAME')
      string(name : 'DOCKER_TAG', defaultValue : '1.0', description : 'DOCKER_TAG')

      // CD
      string(name : 'TARGET_SVR_USER', defaultValue : 'ubuntu', description : 'TARGET_SVR_USER')
      string(name : 'TARGET_SVR_PATH', defaultValue : '/home/ubuntu/', description : 'TARGET_SVR_PATH')
      string(name : 'TARGET_SVR', defaultValue : '10.0.3.61', description : 'TARGET_SVR')
    }

    environment {
      REGION = "ap-northeast-2"
      ECR_REPOSITORY = "${params.AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-2.amazonaws.com"
      ECR_DOCKER_IMAGE = "${ECR_REPOSITORY}/${params.DOCKER_IMAGE_NAME}"
      ECR_DOCKER_TAG = "${params.DOCKER_TAG}"
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
        
        stage ('mvn Build') {
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

        stage('Run test code') {
            when { expression { return params.RUN_TEST } }
            agent { label 'build' }
            steps {
                sh'''
                aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
                docker run --rm ${ECR_DOCKER_IMAGE}:${ECR_DOCKER_TAG} java -jar /app/spring-petclinic.jar
                '''
            }
        }

        stage('Push Docker Image') {
            when { expression { return params.PUSH_DOCKER_IMAGE } }
            agent { label 'build' }
            steps {
                echo "Push Docker Image to ECR"
                sh'''
                    aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
                    docker push ${ECR_DOCKER_IMAGE}:${ECR_DOCKER_TAG}
                '''
            }
        }
        
    }
}
