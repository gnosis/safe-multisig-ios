pipeline {
    agent any
    environment {
        // this enables ruby gem binaries, such as xcpretty
        PATH = "$HOME/.rbenv/bin:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:$PATH"
        INFURA_STAGING_KEY = credentials('INFURA_STAGING_KEY')
        INFURA_PROD_KEY = credentials('INFURA_PROD_KEY')
        ENCRYPTION_KEY = credentials('ENCRYPTION_KEY')
        CODECOV_TOKEN = credentials('CODECOV_TOKEN')
    }
    parameters {
        string(name: 'SSL_ENFORCE_PINNING', defaultValue: '1', description: 'Enforce SSL Pinning? (0 = NO/1 = YES)')
    }
    stages {
        stage('Unit Test') {
            when {
                // Jenkins checks out PRs with a PR-XXX format
                expression { BRANCH_NAME ==~ /^PR-.*/ }
            }
            steps {
                ansiColor('xterm') {
                    // new param for uikit enabled - alternative
                    sh "env"
                    sh "INFURA_KEY=\"${INFURA_STAGING_KEY}\" SSL_ENFORCE_PINNING=\"${params.SSL_ENFORCE_PINNING}\" bin/test.sh \"Multisig - Staging Rinkeby\""
                    junit 'Build/reports/junit.xml'
                    archiveArtifacts 'Build/*/xcodebuild-test.log'
                    archiveArtifacts 'Build/*/tests-bundle.xcresult.tgz'
                }
            }
        }
        stage('Upload to TestFlight') {
            when {
                expression { BRANCH_NAME ==~ /^(main|release\/.*)$/ }
            }
            steps {
                ansiColor('xterm') {
                    // NOTE: on Xcode 11.5, the keychain is not accessible
                    // by the xcode, so the Jenkins's builds are failing when
                    // user is logged out.
                    // The https://stackoverflow.com/a/55699898 has a fix.
                    // After applying it, the first build has to be manually
                    // granted the access to the signing certificates via
                    // the machine's UI (remotely or directly), then
                    // the uploading to AppStoreConnect started to work.

                    // new param for uikit enabled
                    sh "INFURA_KEY=\"${INFURA_STAGING_KEY}\" SSL_ENFORCE_PINNING=\"${params.SSL_ENFORCE_PINNING}\" bin/archive.sh \"Multisig - Staging Rinkeby\""
                    sh "INFURA_KEY=\"${INFURA_STAGING_KEY}\" SSL_ENFORCE_PINNING=\"${params.SSL_ENFORCE_PINNING}\" bin/archive.sh \"Multisig - Staging Mainnet\""
                    sh "INFURA_KEY=\"${INFURA_PROD_KEY}\" SSL_ENFORCE_PINNING=\"${params.SSL_ENFORCE_PINNING}\" bin/archive.sh \"Multisig - Production Rinkeby\""
                    sh "INFURA_KEY=\"${INFURA_PROD_KEY}\" SSL_ENFORCE_PINNING=\"${params.SSL_ENFORCE_PINNING}\" bin/archive.sh \"Multisig - Production Mainnet\""
                    archiveArtifacts 'Build/*/xcodebuild-*.log'
                }
            }
        }
    }
}
