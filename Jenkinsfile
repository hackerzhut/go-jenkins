node {
  ws {
    try {

        // https://github.com/deis/workflow-cli/blob/master/Jenkinsfile
        gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        gitShortCommit = gitCommit[-8..-1]

        // Setup variables
        def appName = "contacts"
        def imgTag = "${env.BUILD_NUMBER}-${gitShortCommit}"
        def imgName = "contacts-api"
        // Path we will mount the project to for the Docker container
        String goPath = "/go/src/github.com/hackerzhut/${applicationName}"
      
        // def imgFullName = "${registry}/${imgName}:${imgTag}"
        def imgFullName = "${imgName}:${imgTag}"
        def goImage = "golang:1.11.1-alpine3.8"


        stage("scm") {
            checkout scm
        }

        stage("test") {
            docker.image("postgres").withRun("-p 5432:5432 -e POSTGRES_PASSWORD=postgres") { c -> 
                docker.image(goImage).inside("--link ${c.id}:db") {
                    sh "export DB_CONNECTION='host=db port=5432 dbname=postgres user=postgres password=postgres sslmode=disable'"
                    sh 'make test'           
                }
            }
        }

        stage("build") {
            docker.image(goImage).inside("-v ${workspace}:/src -w /src") {
                sh 'make build'
            }
        }

        stage("publish") {
            def buildArgs = "."
            def img = docker.build(imgFullName, buildArgs)
        }

        stage("deploy") {

        }
      
    } catch (InterruptedException e) {
      throw e

    // Catch all build failures and report them to Slack etc here.
    } catch (e) {
      throw e

    // Clean up the workspace before exiting. Wait for Jenkins' asynchronous
    // resource disposer to pick up before we close the connection to the worker
    // node.
    } finally {
      step([$class: 'WsCleanup'])
      sleep 10
    }
  }
}