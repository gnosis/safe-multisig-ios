pipeline {
    agent any
    environment {
        // this enables ruby gem binaries, such as xcpretty
        PATH = "$HOME/.rbenv/bin:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:$PATH"
    }
    stages {
        stage('Unit Test') {
            when {
                expression { BRANCH_NAME ==~ /^(gh-.*)$/ }
            }
            steps {
                ansiColor('xterm') {
                    sh 'bin/test.sh "Multisig - Development Rinkeby"'
                    junit 'Build/reports/junit.xml'
                    archiveArtifacts 'Build/Multisig - Development Rinkeby/xcodebuild-test.log'
                }
            }
        }
        stage('Archive') {
            when {
                expression { BRANCH_NAME ==~ /^master$/ }
            }
            steps {
                ansiColor('xterm') {
                    sh 'bin/archive.sh "Multisig - Development Rinkeby"'
                    archiveArtifacts 'Build/Multisig - Development Rinkeby/xcodebuild-archive.log'
                    
                    sh 'bin/archive.sh "Multisig - Development Mainnet"'
                    archiveArtifacts 'Build/Multisig - Development Mainnet/xcodebuild-export.log'
                }
            }
        }
    }
}
