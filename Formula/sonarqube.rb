class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip"
  sha256 "b6a32700ccdf48ffd7e9bc57abef6ae271bbb05e6f036ba5f6d170013eb66e62"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "2b78f4693f3381847f2c1e620760acd37e3f6607b43cd7a02dbc4ac3eee4bf96"
    sha256 cellar: :any_skip_relocation, catalina:     "2b78f4693f3381847f2c1e620760acd37e3f6607b43cd7a02dbc4ac3eee4bf96"
    sha256 cellar: :any_skip_relocation, mojave:       "f59b5f1ce0b91bc23485a8f8a00d9c483bd333d32fcbd630c9114be606fe5728"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ecc7027c8e8af2293c0b03d465122e06681f4cc5208ed5c4a8c7888ba02fa5a9"
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
    run [opt_bin/"sonar", "start"]
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
