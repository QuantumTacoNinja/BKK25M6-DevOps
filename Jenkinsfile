pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    stages {
        stage('Test') {
            steps {
                sh "go test ./..."
            }
        }
        
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }

        stage('Deploy') {
            steps {
                withCredentials(
                    [sshUserPrivateKey(
                        credentialsId: '423c6206-8e7f-4b54-911b-95600c9c7a80', 
                        keyFileVariable: 'FILENAME', 
                        usernameVariable: 'USERNAME'
                    )]
                ) {
                    sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@target "sudo systemctl stop myapp" || true' 
                    sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@target:'
                }
            }
        }
    }
}
