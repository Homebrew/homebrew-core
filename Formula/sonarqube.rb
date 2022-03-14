class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.3.0.51899.zip"
  sha256 "74108676ed881e5a10ad53b42bc8b343e868be37b4d36705b447dc80ed9f2c1c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/success-download-community-edition/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e71daa37dd6f34d250a0776e6e1c90a222d2275ad01b6165026298ef1866edc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77c458a080344e4f53df165828c0e707def89528c6b93b3fe45aaabb7b0e02f2"
    sha256 cellar: :any_skip_relocation, monterey:       "b377dadcaba8cfb19535b0dafe0c6a6a6b734dfc782f1870152bc7bcb25c9324"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd43969b65820a9ff9ff5df59e43ee23df092d10c6cf08edd2792d1626548554"
    sha256 cellar: :any_skip_relocation, catalina:       "a1cd1ee84cc3ac05cd9f33ba52d59263f4c9301d5dbc0bd721e4c1fde7b0921a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c5c756e4a0b7f226f1ebc82caf8b1ee1c88d2107892b43fec266272f80b320f"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    # Use Java Service Wrapper 3.5.46 which is Apple Silicon compatible
    # Java Service Wrapper doesn't support the  wrapper binary to be symlinked, so it's copied
    jsw_libexec = Formula["java-service-wrapper"].opt_libexec
    ln_s jsw_libexec/"lib/wrapper.jar", "#{buildpath}/lib/jsw/wrapper-3.5.46.jar"
    ln_s jsw_libexec/"lib/libwrapper.dylib", "#{buildpath}/bin/macosx-universal-64/lib/"
    cp jsw_libexec/"bin/wrapper", "#{buildpath}/bin/macosx-universal-64/"
    cp jsw_libexec/"scripts/App.sh.in", "#{buildpath}/bin/macosx-universal-64/sonar.sh"
    sonar_sh_file = "bin/macosx-universal-64/sonar.sh"
    inreplace sonar_sh_file, "@app.name@", "SonarQube"
    inreplace sonar_sh_file, "@app.long.name@", "SonarQube"
    inreplace sonar_sh_file, "../conf/wrapper.conf", "../../conf/wrapper.conf"
    inreplace "conf/wrapper.conf", "wrapper-3.2.3.jar", "wrapper-3.5.46.jar"
    rm "lib/jsw/wrapper-3.2.3.jar"
    rm "bin/macosx-universal-64/lib/libwrapper.jnilib"

    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_rf Dir["bin/{#{remove},windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("11")
  end

  service do
    run [opt_bin/"sonar", "console"]
    keep_alive true
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
