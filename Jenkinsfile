pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    parameters {
        // choice(name: 'CHOICES', choices: ['apply', 'destroy' ], description: '')

        booleanParam(name: 'terraform_apply', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['apply', 'destroy' ], description: 'pick terraform apply or terraform destroy')
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
                    docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                        // Run Checkov to scan the code
                        sh 'checkov -d .'
                    }
                }
            }
        }
        
        stage('Example') {
            steps {
                echo "Toggle: ${params.TOGGLE}"
                echo "Choice: ${params.CHOICE}"
            }
        }


        stage('Deploy') {
            steps {
                // ${params.CHOICES} == 'destroy'
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