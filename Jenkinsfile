pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_PASWD')
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        
        
    }
    
    stages {
        stage('Git checkout') {
            steps {
                echo 'This is for cloning the gitrepo'
                git branch: 'main', url: 'https://github.com/balajigoutham/Banking-Demo.git'
            }
        }

        stage('Create a Package') {
            steps {
                echo 'This will create a package using maven'
                sh 'mvn package'
            }
        }

     

        stage('Create a Docker image from the Package Insure-Me.jar file') {
            steps {
                sh 'docker build -t balaji915/banking:1.0 .'
            }
        }

        
        stage('Login2DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_PASWD', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                }
            }
        }

        stage('Push the Docker image') {
            steps {
                sh 'docker push balaji915/banking:1.0'
            }
        }

        stage('Create Infrastructure using terraform') {
            steps {
                dir('scripts') {
                    sh 'sudo chmod 600 jenkins.pem'
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform init'
                        sh 'terraform validate'
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
    }
}
