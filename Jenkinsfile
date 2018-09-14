/*
Run test from Jenkins build
*/

def project = 'murano_benchmark'
pipeline {
    options {
        disableConcurrentBuilds()
    }
    agent any
    triggers {
        cron('0 1 * * *')
    }
    parameters {
      string(name: 'domain', defaultValue: 'perftest.apps.dev1.murano.exosite-dev.com')
    }
    stages {
        stage('test') {
            steps {
                sh "DOMAIN=${params.domain} > murano.env"
                sh "./run-compose.sh -f test-docker-compose.yml -p '${project}' run --rm app"
            }
        }
    }
    post {
        always {
            sh "./run-compose.sh -f test-docker-compose.yml -p '${project}' down || true"
        }
    }
}
