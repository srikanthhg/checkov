pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    parameters {
        // choice(name: 'CHOICES', choices: ['apply', 'destroy' ], description: '')
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
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
        
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"

                echo "Biography: ${params.BIOGRAPHY}"

                echo "Toggle: ${params.TOGGLE}"

                echo "Choice: ${params.CHOICE}"

                echo "Password: ${params.PASSWORD}"
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