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
                        credentialsId: '8ad6cc3a-611a-4899-82a5-d37317ba1973', 
                        keyFileVariable: 'FILENAME', 
                        usernameVariable: 'USERNAME'
                    )]
                ) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@target \
                      "sudo systemctl stop myapp || true"
                    '''
        
                    sh '''
                    scp -o StrictHostKeyChecking=no -i ${FILENAME} myapp.service \
                      ${USERNAME}@target:/tmp/myapp.service
                    '''
        
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@target \
                      "sudo mv /tmp/myapp.service /etc/systemd/system/myapp.service && \
                       sudo chmod 644 /etc/systemd/system/myapp.service && \
                       sudo systemctl daemon-reload && \
                       sudo systemctl enable myapp && \
                       sudo systemctl restart myapp"
                    '''
                }
            }
        }
    }
}
