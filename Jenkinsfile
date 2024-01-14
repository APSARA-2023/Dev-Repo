pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    // Using Yarn for consistency with Dockerfile
                    sh 'yarn install'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // You can add your test commands here
                    sh 'yarn test'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Assuming you have Terraform installed and configured
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }

        failure {
            echo 'Deployment failed!'
        }
    }
}
