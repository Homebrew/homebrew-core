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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2c787766ebc3353063d6587529ace383b8d3e1a2b3ad853d6d1603734fe89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df64c44ab8dfaf70244a6dcb2fe439a34b963e2cc2018f3d5aa250ba8f054d24"
    sha256 cellar: :any_skip_relocation, monterey:       "d69dd0f8179bd50bc8a017868f0c4fdc4367a20d2d0821ce408995df13f5277f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bff3fa4e9c6cdf563a464d2c15bc4cf41b64e1bba6caa3bdd543b32be004c28"
    sha256 cellar: :any_skip_relocation, catalina:       "e779f6c1c826f9210c1cdab545e94965a9587a6630a7acd861e5114751d866cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc58a80f7dd387a6e05462def97df3db4e974427fc5a78c6809565ef162289c6"
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
