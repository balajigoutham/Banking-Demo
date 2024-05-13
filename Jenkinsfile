pipeline {
    agent any
    
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

        stage('Publish the HTML Reports') {
            steps {
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Banking/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }

        stage('Create a Docker image from the Package Insure-Me.jar file') {
            steps {
                sh 'docker build -t balaji915/banking:1.0 .'
            }
        }

        stage('Login2DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASWD', variable: 'DOCKER_HUB_PASWD')]) {
                    sh "docker login -u balaji915 -p ${DOCKER_HUB_PASWD}"
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
                    sh 'sudo chmod 600 learnawskey.pem'
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
