@Library('pipelib@master') _

node {

  stage('Setup') {
    git([
      url: "https://github.com/venicegeo/pz-docs",
      branch: "master"
    ])
  }

  stage('Archive') {
    withRvm(rubyVersion: '2.4.0') {
      sh """
        ./ci/archive.sh
      """
    }
    mavenPush()
  }

  stage ('CI Deploy') {
    cfPush()
    zap()
    cfBgDeploy()
  }

  stage ('Integration Testing') {
    postman()
  }

  stage('Staging Deploy') {
    cfPush {
      cfDomain = "stage.devops.geointservices.io"
      cfSpace = 'stage'
    }
    cfBgDeploy {
      cfDomain = "stage.devops.geointservices.io"
      cfSpace = 'stage'
    }
  }

  stage ('Cleanup') {
    deleteDir()
  }
}
