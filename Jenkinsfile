pipeline {

  agent any

  environment {
    XC_PROJECT= "GrapeCI.Server.xcodeproj"
    XC_SCHEME = "GrapeCI.Server-Package"
    SOURCES = "Sources"

    SONAR_TOKEN = credentials('SONAR_TOKEN')
  }


  stages {

      stage('Lint') {
        steps {
          sh 'mkdir -p sonar-reports'
          sh 'swiftlint lint --reporter json ${SOURCES} > sonar-reports/swiftlint.json'
        }
      }

      stage('Run unit test') {
          steps {
              sh 'swift test --enable-code-coverage'
          }
      }

      stage('Sonar Cloud') {
        steps {
          sh 'xccov-to-sonarqube-generic.sh build/Logs/Test/*.xcresult/ > sonar-reports/sonarqube-generic-coverage.xml'

          script {
            if (env.CHANGE_ID) {
              sh 'sonar-scanner -Dsonar.login=${SONAR_TOKEN} -Dsonar.pullrequest.key=${CHANGE_ID} -Dsonar.pullrequest.branch=${CHANGE_BRANCH} -Dsonar.pullrequest.base=${CHANGE_TARGET}'
            } else {
              sh 'sonar-scanner -Dsonar.login=${SONAR_TOKEN} -Dsonar.branch.name=${GIT_BRANCH}'
            }
          }
        }
      }

  }

  post {
    always {
    	emailext body: '''${SCRIPT, template="build-report.groovy"}''',
                subject: "[Jenkins FP] ${JOB_NAME}",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']]
    }
  }

}
