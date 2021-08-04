class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip"
  sha256 "cb27f3230c8126f7082b89a7d018734b59321821e150a50c016e5cb887e68c5c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e70fe81f87e9b1b9d3ba69f02e987d47505c1c49e0163f1a1f91aee1d35655c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b26f126b981440dbfd0bcecf145fbb48b548f46c93d0c26e8d02b63bd8347103"
    sha256 cellar: :any_skip_relocation, catalina:      "b26f126b981440dbfd0bcecf145fbb48b548f46c93d0c26e8d02b63bd8347103"
    sha256 cellar: :any_skip_relocation, mojave:        "476709c0932f4bb2fb01df928b4ee49534833347c2709339bb0ad32ffad943d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27759a532884e3d571a16a818f68a6dd7b160f48ea42374716d7248f7ae4fef2"
  end

  # sonarqube ships pre-built x86_64 binaries
  depends_on arch: :x86_64
  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    remove = "linux"
    keep = "macosx-universal"
    on_linux do
      remove = "macosx"
      keep = "linux-x86"
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
