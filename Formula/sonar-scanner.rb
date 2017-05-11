class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
  url "https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.2.768.zip"
  sha256 "f4ef43882f53be905cb8f29117b1350f2bf9b413cda54fc8febe06af529e2129"
  head "https://github.com/SonarSource/sonar-scanner-cli.git"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/", :SONAR_SCANNER_HOME => libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
