@Library('pipelib@master') _

node {

  stage('Setup') {
    git([
      url: "https://github.com/venicegeo/pz-docs",
      branch: "master"
    ])
  }

  stage('Archive') {
    withRvm('ruby-2.1.10') {
      sh './ci/archive.sh'
      mavenPush()
    }
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
      cfTarget = 'stage'
    }
    cfBgDeploy {
      cfTarget = 'stage'
    }
  }

  stage ('Cleanup') {
    deleteDir()
  }
}
