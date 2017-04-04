def macos_versions = ["sierra", "el_capitan", "yosemite"]

def cleanup() {
  sh 'rm -f *.bottle*.*'
}

def checkout() {
  brew_bin = "/usr/local/bin"
  brew_cellar = "/usr/local/Cellar"
  brew_repo = "/usr/local/Homebrew"
  brew_tap_repo = "${brew_repo}/Library/Taps/homebrew/homebrew-core"
  sh "mkdir -p ${brew_bin} ${brew_cellar} ${brew_tap_repo} "
  dir(brew_repo) {
    git url: 'https://github.com/Homebrew/brew.git', changelog: false
  }
  sh "ln -sf ${brew_repo}/bin/brew ${brew_bin}/brew"
  dir(brew_tap_repo) {
    checkout scm
  }
}

def test_bot(args) {
  timeout(time: 6, unit: 'HOURS') {
    withEnv(["PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
             'HOMEBREW_DEVELOPER=1']) {
      sh "brew test-bot ${args}"
    }
  }
}

def test() {
  test_bot("--ci-auto ${BOT_PARAMS}")
}

def archive(stash_name) {
  def test_bot_junit = 'brew-test-bot.xml'
  if (fileExists(test_bot_junit)) {
    junit test_bot_junit
  }

  def bottle_glob = '*.bottle*.*'
  if (findFiles(glob: bottle_glob).length >= 1) {
    stash includes: bottle_glob, name: stash_name
  }
}

def build(stash_name) {
  cleanup()
  checkout()
  test()
  archive(stash_name)
  cleanup()
}

try {
  properties([
    buildDiscarder(logRotator(daysToKeepStr: '7', artifactNumToKeepStr: '50')),
    [$class: 'RebuildSettings', autoRebuild: true],
    parameters([string(name: 'BOT_PARAMS', defaultValue: '', description: 'Parameters passed to `brew test-bot`')]),
    pipelineTriggers([[$class: 'GitHubPushTrigger']])
  ])

  stage("Build") {
    // TODO: figure out how to use macos_versions here.
    parallel (
      sierra:     { node("sierra")     { build("sierra")     }},
      el_capitan: { node("el_capitan") { build("el_capitan") }},
      yosemite:   { node("yosemite")   { build("yosemite")   }},
    )
  }

  def stashed_bottles = false
  node("master") {
    stashed_bottles = fileExists("../builds/${env.BUILD_NUMBER}/stashes")
  }
  if (stashed_bottles) {
    stage("Upload") {
      node("master") {
        cleanup()
        checkout()
        for (version in macos_versions) {
          unstash version
        }
        withCredentials([[
            $class: 'UsernamePasswordMultiBinding',
            credentialsId: '5b6903a9-9f39-4c1b-9de6-ba0dd99c82a0',
            passwordVariable: 'BINTRAY_KEY', usernameVariable: 'BINTRAY_USER']]) {
          test_bot("--ci-upload --tap=homebrew/core")
        }
        cleanup()
      }
    }
  }
}
catch (err) {
  // TODO: decide who to email and when
  // mail to: '',
  //      from: 'Brew Test Bot <brewtestbot@icloud.com>',
  //      subject: "${env.JOB_NAME} ${env.BUILD_DISPLAY_NAME} failed!",
  //      body: "Build: ${env.BUILD_URL}\nConsole: ${env.BUILD_URL}console\nTests: ${env.BUILD_URL}testReport/"
  throw err
}
