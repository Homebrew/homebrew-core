class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
  url "https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778.zip"
  sha256 "4e3035f208548621433c8713de5e536aa81ae1ab4df2998e041b9236b3ba3170"
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
