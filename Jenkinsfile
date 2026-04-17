pipeline {
    agent any

    stages {

        stage('Terraform Init') {
            steps {
                script {
                    withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                        sh '''
                        cd 00-vpc
                        terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                        sh '''
                        cd 00-vpc
                        terraform plan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                        input message: "Apply Terraform?"
                        sh '''
                        cd 00-vpc
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
        stage('SG') {
    steps {
        sh '''
        cd 10-sg
        terraform init
        terraform apply -auto-approve
        '''
    }
}
       
}
    }
}
