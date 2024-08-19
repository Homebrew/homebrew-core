class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.1.0.4477.zip"
  sha256 "6928d282b22381d37865c725293f8d03613f81104bc2461ed3318fac2f345cdc"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a4a993d143f125bf902bfaea4e8a69c064f944eb682c4f2a311d765a8fa0b8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a4a993d143f125bf902bfaea4e8a69c064f944eb682c4f2a311d765a8fa0b8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a4a993d143f125bf902bfaea4e8a69c064f944eb682c4f2a311d765a8fa0b8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a4a993d143f125bf902bfaea4e8a69c064f944eb682c4f2a311d765a8fa0b8c"
    sha256 cellar: :any_skip_relocation, ventura:        "3a4a993d143f125bf902bfaea4e8a69c064f944eb682c4f2a311d765a8fa0b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "3a4a993d143f125bf902bfaea4e8a69c064f944eb682c4f2a311d765a8fa0b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50f629e9d25548f2d0eb31cf42a16edcc5f4f94a4acfa649834949ebbc8fcaa2"
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
                              JAVA_HOME:          Formula["openjdk"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
