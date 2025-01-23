class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.8.100196.zip"
  sha256 "07d9100c95e5c19f1785c0e9ffc7c8973ce3069a568d2500146a5111b6e966cd"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LT[AS].*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c36a1d661bd9a1bc41df5754e6a872602bf42ed1ec8e52675a9eb0be16a7fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c36a1d661bd9a1bc41df5754e6a872602bf42ed1ec8e52675a9eb0be16a7fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c36a1d661bd9a1bc41df5754e6a872602bf42ed1ec8e52675a9eb0be16a7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c36a1d661bd9a1bc41df5754e6a872602bf42ed1ec8e52675a9eb0be16a7fe"
    sha256 cellar: :any_skip_relocation, ventura:       "88c36a1d661bd9a1bc41df5754e6a872602bf42ed1ec8e52675a9eb0be16a7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca425d2efdd9e8b788c6ea8c80d21b72de5cd1adecb9d0e9911c6d60081dd86c"
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

    rm_r(Dir["bin/{#{remove},windows}-*"])

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
