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
                    scp -o StrictHostKeyChecking=no -i ${FILENAME} myapp.service \${USERNAME}@target:/tmp/myapp.service
                    scp -o StrictHostKeyChecking=no -i ${FILENAME} main \${USERNAME}@target:/tmp/main
                    '''
        
                    ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@target "
                    # Create system user if it doesn't exist
                    sudo id -u myapp &>/dev/null || sudo useradd -r -s /bin/false myapp
                
                    # Prepare app directory
                    sudo mkdir -p /opt/myapp
                    sudo mv /tmp/main /opt/myapp/main
                    sudo chown myapp:myapp /opt/myapp/main
                    sudo chmod 755 /opt/myapp/main
                
                    # Install systemd service
                    sudo mv /tmp/myapp.service /etc/systemd/system/myapp.service
                    sudo chmod 644 /etc/systemd/system/myapp.service
                
                    # Reload and start service
                    sudo systemctl daemon-reload
                    sudo systemctl enable myapp
                    sudo systemctl restart myapp
                    "
                }
            }
        }
    }
}
