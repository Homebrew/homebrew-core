class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip"
  sha256 "9a8e1edae1a687356b2895b0d3fd60034a8e59b535e653563de605d1e2b17960"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/downloads/"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.(?:zip|t)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d634ca67a5c82334ea2f1c7f34b3deadff0c7a763e7a39ac058dc405af868d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d9d3bbeee32aaff8e2abfcc462eadb18605896c87bdea68d0e8fda6f6b9a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4d71d334c14740567a43abb374660da5f76a45eef2b5de8d2513e7a237a0c94"
    sha256 cellar: :any_skip_relocation, big_sur:        "e843228f6f74a598898b6fcc0a820fb04f415d6b4aa8de7a60eeec6bcebdf0a9"
    sha256 cellar: :any_skip_relocation, catalina:       "1a46743eda427e53612cbe0e82736b4025261dcc2b1d7e742068e9fbab61d225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3980551b0a52198eb33e37eaf5593cd688bbceeb7e3c242c80856a9f4d89974"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk@11"

  conflicts_with "sonarqube", because: "both install the same binaries"

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
    run [opt_bin/"sonar", "start"]
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
