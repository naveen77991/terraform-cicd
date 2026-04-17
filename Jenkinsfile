pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {

        stage('Terraform Init') {
            steps {
                sh '''
                cd 00-vpc
                terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd 00-vpc
                terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Apply Terraform?"
                sh '''
                cd 00-vpc
                terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS'
        }
        failure {
            echo 'FAILED'
        }
        always {
            deleteDir()
        }
    }
}
