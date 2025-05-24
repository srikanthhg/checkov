// plugins installed: pipeline stage view, docker, terraform, aws 
pipeline {
    agent any
    tools {
        terraform 'terraform'
        
    }

    parameters {
        // choice(name: 'CHOICES', choices: ['apply', 'destroy' ], description: '')

        // booleanParam(name: 'terraform_apply', defaultValue: true, description: 'Toggle this value')

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
        stage('init') {
            steps {
                // ${params.CHOICES} == 'destroy'
                sh "terraform init"
            }
        }
        stage('Lint') {
            steps {
                // Run Terraform fmt to check formatting
                sh 'terraform fmt -recursive'
                // Run Terraform validate to check for syntax errors
                sh 'terraform validate'
            }
        }
        stage('Apply') {
            when {
                expression { params.CHOICE == 'apply' }
            }
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws_cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        stage('Destroy') {
            when {
                expression { params.CHOICE == 'destroy' }
            }
            steps {

                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws_cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform destroy -auto-approve tfplan'
                }
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