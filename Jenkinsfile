pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
				cd 'script'
                sh 'bash build.sh'
            }
        }
    }
}
