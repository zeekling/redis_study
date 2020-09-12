pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'printenv'
                sh 'make MALLOC=jemalloc'
            }
        }
    }
}
