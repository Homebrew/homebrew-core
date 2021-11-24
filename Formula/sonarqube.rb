class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.2.0.49834.zip"
  sha256 "96aefddd3ec64d3ce73791755de780427165b2e8c6f25adb2510aaab8a567b75"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "0129761b88551453539aea7dc7267b0d92cb84ee36417b64f650b89ab626d112"
    sha256 cellar: :any_skip_relocation, catalina:     "0129761b88551453539aea7dc7267b0d92cb84ee36417b64f650b89ab626d112"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "68e8afd0a5f98e6329461fc53a1bdf3012541b45ee67441e0ecafe31dbb623c3"
  end

  # sonarqube ships pre-built x86_64 binaries
  depends_on arch: :x86_64
  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
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
