class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.4.0.2170.zip"
  sha256 "b24c19e948f152a4ea8dc43d037253234add639503d42194f6175869693ff058"
  license "LGPL-3.0"
  head "https://github.com/SonarSource/sonar-scanner-cli.git"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/", SONAR_SCANNER_HOME: libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
