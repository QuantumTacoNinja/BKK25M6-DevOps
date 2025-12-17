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
                        credentialsId: '6732d61e-e9f4-45a9-ae56-2948c90801f4', 
                        keyFileVariable: 'FILENAME', 
                        usernameVariable: 'USERNAME'
                    )]
                ) {
                    sh 'chmod 755 ./deploy.sh'
                    sh './deploy.sh'
                }
            }
        }
    }
}
