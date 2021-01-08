pipeline {

  agent any

  stages {

    stage('Lint') {
      steps {
        sh 'swiftlint lint ./Sources'
      }
    }

		stage('Test') {
			steps {
				sh 'swift test'
			}
		}

	}

  post {
    always {
    	emailext  body: '''${SCRIPT, template="build-report.groovy"}''',
      					subject: "[Jenkins FP] ${JOB_NAME}",
      					recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']]
    	
    }
  }

}
