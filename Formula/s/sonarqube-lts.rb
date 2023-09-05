class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.1.69595.zip"
  sha256 "40bb45f551c7959ba1d3a5ff7b5432a558a5b2ad2efa5e9e1fcf52b83142897b"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ee04d25b1bc22cdfe62ebd85d819e49b99988ce2557c8651d10be888f0e7255"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee04d25b1bc22cdfe62ebd85d819e49b99988ce2557c8651d10be888f0e7255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee04d25b1bc22cdfe62ebd85d819e49b99988ce2557c8651d10be888f0e7255"
    sha256 cellar: :any_skip_relocation, ventura:        "1ee04d25b1bc22cdfe62ebd85d819e49b99988ce2557c8651d10be888f0e7255"
    sha256 cellar: :any_skip_relocation, monterey:       "1ee04d25b1bc22cdfe62ebd85d819e49b99988ce2557c8651d10be888f0e7255"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ee04d25b1bc22cdfe62ebd85d819e49b99988ce2557c8651d10be888f0e7255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ef68e06f7f2340fbed67f00a989e8d05a2f2a9c9de0bcd75f68bbf74f18575"
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
