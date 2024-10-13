class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.2.1.4610.zip"
  sha256 "d45e09eecb2fe867ce7548be59d54317192c79944ef7e54c691423c832a8208f"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5e24f759a690b4abb55737325a6c9e94d42b2235abd0e93021306d6016d967e6"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/",
                              SONAR_SCANNER_HOME: libexec,
                              JAVA_HOME:          Language::Java.overridable_java_home_env[:JAVA_HOME]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
