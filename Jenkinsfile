pipeline {

  agent any

  environment {
    XC_PROJECT= "GrapeCI.Server.xcodeproj"
    XC_SCHEME = "GrapeCI.Server-Package"
    SOURCE_DIR = "./Sourcess"

    SONAR_TOKEN = credentials('SONAR_TOKEN')
  }


  stages {

    stage('Lint') {
      steps {
        sh 'swiftlint lint ${SOURCE_DIR} > sonar-reports/swiftlint.txt'
      }
    }

		stage('Run unit test') {
			steps {
				sh 'xcodebuild -scheme ${XC_SCHEME} build test | xcpretty'
			}
		}

    stage('Sonar Cloud') {
      steps {
        sh 'slather coverage -x --scheme ${XC_SCHEME} --output-directory sonar-reports ${XC_PROJECT}'

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
    	emailext  body: '''${SCRIPT, template="build-report.groovy"}''',
      					subject: "[Jenkins FP] ${JOB_NAME}",
      					recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']]
    	
    }
  }

}
