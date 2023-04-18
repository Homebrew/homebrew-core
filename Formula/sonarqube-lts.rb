class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip"
  sha256 "f5b3045ac40b99dfc2ab45c0990074f4b15e426bdb91533d77f3b94b73d3d411"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "291ec50d14580b960d7cb31486f4855082a901808b81d92cc618c964c8b04aeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "291ec50d14580b960d7cb31486f4855082a901808b81d92cc618c964c8b04aeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "291ec50d14580b960d7cb31486f4855082a901808b81d92cc618c964c8b04aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "291ec50d14580b960d7cb31486f4855082a901808b81d92cc618c964c8b04aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "291ec50d14580b960d7cb31486f4855082a901808b81d92cc618c964c8b04aeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "291ec50d14580b960d7cb31486f4855082a901808b81d92cc618c964c8b04aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75372df8c663391bc204e5812e406b1168aef878219edd4c005b28b545eaad6"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube", because: "both install the same binaries"

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
      Language::Java.overridable_java_home_env("17")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    ENV["SONAR_JAVA_PATH"] = Formula["openjdk@17"].opt_bin/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
