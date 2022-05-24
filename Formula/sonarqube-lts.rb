class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.8.54436.zip"
  sha256 "a491240b2066222680d9770c6da4d5f0cf9873c86e0d0e3fbe4d1383bbf3ce85"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/downloads/"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.(?:zip|t)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bf0b208857351951429718a39d82f2dd0b51278236c7b7cd55f66bd9209eb01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5fa361559222f53d3656fa0d0bc77ec9730da116352a8845a7768082882f093"
    sha256 cellar: :any_skip_relocation, monterey:       "dce9a4bcf3774a6643a5f366cac487f1cb4857f4d8b8d2c1ecabfe3c760da9c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d67233026ad942789ed3b4723794bb7833b20f04637ebf2eaab0e850fd3d0530"
    sha256 cellar: :any_skip_relocation, catalina:       "8408beee73e1c2622f4917d340110f390e2795378040e758754ef4c7bda01094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30b7b0fe6cba81a74746c3ba186c4a785c2d934a5c012550a2b4e89f0dd4eda"
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
