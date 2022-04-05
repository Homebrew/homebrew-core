class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip"
  sha256 "df8d97ae93002593fcaceacfe4dfdab68982a8dc52002c441ee6218f4d71961c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/success-download-community-edition/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "668968c3dd5bf2f776953dc3bd9a24fdb79a897098730ec09e0f35cbeb89a394"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa36760e4092c90412b6e6a05705179cefa2ba0e1fad32e80655bb48b9ca5081"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f94c9cf8299db03c18de3c1f41da7952f5aac99d05bf859ccc63e64b0377c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae8137236b2bdba20652e7f61a17c13a02f10180f4fc2a1ce546a9095b82a910"
    sha256 cellar: :any_skip_relocation, catalina:       "e039a62567c2d78d184e16c5bbc715a48e166ecce6b19531f7e5d0dc9a4dae5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f32d955696630688dd0522134cdc4549da00ffb88e078bf32282eaec3d2a4bc3"
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
