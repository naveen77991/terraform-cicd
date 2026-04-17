
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/YOUR-REPO.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'cd 00-vpc && terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'cd 00-vpc && terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'cd 00-vpc && terraform apply -auto-approve'
            }
        }
    }
}
