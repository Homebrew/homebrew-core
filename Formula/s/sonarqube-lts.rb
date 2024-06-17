class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.5.90363.zip"
  sha256 "17b6cfab23fcd2e74b9c44aae6455a24eff3ba990a35a14ca186ded1411eefd3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LT[AS].*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c50862c5bd103095c35a52d05f5e450266375fa5243ff96df176d14e8dced22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c50862c5bd103095c35a52d05f5e450266375fa5243ff96df176d14e8dced22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c50862c5bd103095c35a52d05f5e450266375fa5243ff96df176d14e8dced22"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c50862c5bd103095c35a52d05f5e450266375fa5243ff96df176d14e8dced22"
    sha256 cellar: :any_skip_relocation, ventura:        "8c50862c5bd103095c35a52d05f5e450266375fa5243ff96df176d14e8dced22"
    sha256 cellar: :any_skip_relocation, monterey:       "8c50862c5bd103095c35a52d05f5e450266375fa5243ff96df176d14e8dced22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63cd74856439d7b1d8fcf9b84256f58796f45242d33cc54e4380ad1e61723511"
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
