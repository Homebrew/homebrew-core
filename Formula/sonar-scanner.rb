class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.0.2311.zip"
  sha256 "e45599982e455fc36ac896579a9b88957060882b8eaa3a2d69e9e373f9174381"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git"

  bottle :unneeded

  # https://github.com/SonarSource/sonar-scanner-cli/blob/master/pom.xml#L48-L53
  depends_on "openjdk@11"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    lib.install libexec/"lib/sonar-scanner-cli-#{version}.jar"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"

    env = { JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk@11"].opt_prefix}}", SONAR_SCANNER_HOME: libexec }
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      (bin/file.basename).write_env_script file, env
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
