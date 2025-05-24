pipeline {
    agent any

    parameters {
        choice(name: 'CHOICES', choices: ['apply', 'destroy' ], description: '')
    }
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/srikanthhg/checkov.git'
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image('bridgecrew/checkov:latest').inside {
                        // Run Checkov to scan the code
                        sh 'checkov -d .'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                "${params.CHOICES}" == 'destroy' ? sh 'terraform destroy -auto-approve' : sh 'terraform apply -auto-approve'
                sh "terraform init"
                sh "terraform fmt"
                sh "terraform validate"
                sh "terraform plan -out=tfplan"
                sh "terraform apply -auto-approve tfplan"
            }
        }
    }

    post {
        always {
            echo 'This will always run after the pipeline completes.'
        }
        success {
            echo 'This will run only if the pipeline succeeds.'
        }
        failure {
            echo 'This will run only if the pipeline fails.'
        }
    }
}