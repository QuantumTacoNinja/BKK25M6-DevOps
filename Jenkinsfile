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
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Deploy') {
            steps {
                withCredentials(
                    [sshUserPrivateKey(
                        credentialsId: '980a612d-43c7-4077-aa94-773a9b714893', 
                        keyFileVariable: 'FILENAME', 
                        usernameVariable: 'USERNAME'
                    )]
                ) {
                    sh 'docker save myapp:latest | ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker "docker load"'
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker """
                        docker run --publish 4444:4444 myapp:latest
                    """
                    '''
                }
            }
        }
    }
}
