class SonarRunner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner"
  url "https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.8.zip"
  sha256 "0295365a7e5d4499ec6b46cb6c70f3fa127159b58b73930f675acd0897a6b350"
  head "https://github.com/SonarSource/sonar-runner.git"

  bottle :unneeded

  def install
    # Remove windows files
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/sonar-runner"
  end

  def caveats; <<-EOS.undent
      If this is your first install, you should adjust the default configuration:
        #{libexec}/conf/sonar-runner.properties

      after that you should also add a new enviroment variable:
        SONAR_RUNNER_HOME=#{libexec}
      EOS
  end

  test do
    system "#{bin}/sonar-runner", "-h"
  end
end
