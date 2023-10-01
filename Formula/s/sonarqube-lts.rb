class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.2.77730.zip"
  sha256 "e7ef7d47baa497c7cd27b4a465ec95095131dab8eea4383239c1d3dbe9790d6d"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, ventura:        "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, monterey:       "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3df3b172c47dbde541f524aaf18ba238ece6095914fb98ab193c650e195999d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8dd3923bb2b3c784f700409c8bb0c5589fd6fc0be6daddeceae0d9468710fd7"
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
