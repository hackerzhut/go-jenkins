node {
  ws {
    try {

        // Setup variables
        def appName = "contacts"
        def imgName = "contacts-api"
        String goPath = "/go/src/github.com/hackerzhut/${appName}"
        def goImage = "golang:1.11.1"


        stage("scm") {
            checkout scm
            // git 'https://github.com/hackerzhut/go-jenkins'
        }

        // https://github.com/deis/workflow-cli/blob/master/Jenkinsfile
        def gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        def gitShortCommit = gitCommit[-8..-1]
        def imgTag = "${env.BUILD_NUMBER}-${gitShortCommit}"
        // def imgFullName = "${registry}/${imgName}:${imgTag}"
        def imgFullName = "${imgName}:${imgTag}"

        stage("test") {
            docker.image("postgres").withRun("-p 5432:5432 -e POSTGRES_PASSWORD=postgres") { c -> 
               // def buildArgs = "--build-arg DB_CONNECTION=${uri} ."
                // def img = docker.build(imgFullName, ".")
                docker.image(goImage).inside("--link ${c.id}:db") {
                    sh "export DB_CONNECTION='host=db port=5432 dbname=postgres user=postgres password=postgres sslmode=disable'"
                    sh 'make test'           
                }
            }
        }

        stage("build") {
            // docker.image(goImage).inside("-v ${workspace}:/src -w /src") {
            //     sh 'make build'
            // }
        }

        stage("publish") {
            // def buildArgs = "."
            // def img = docker.build(imgFullName, buildArgs)
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