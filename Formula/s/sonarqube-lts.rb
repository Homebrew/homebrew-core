class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.6.92038.zip"
  sha256 "4b50b568de84e94f43638059a6f746d4c9347b07458f3318840664408e8178d5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LT[AS].*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6698efb30331bd468547b170aeac89be4a8e85ce87f011ee9e66fa93ed5c07f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6698efb30331bd468547b170aeac89be4a8e85ce87f011ee9e66fa93ed5c07f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6698efb30331bd468547b170aeac89be4a8e85ce87f011ee9e66fa93ed5c07f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6698efb30331bd468547b170aeac89be4a8e85ce87f011ee9e66fa93ed5c07f5"
    sha256 cellar: :any_skip_relocation, ventura:        "6698efb30331bd468547b170aeac89be4a8e85ce87f011ee9e66fa93ed5c07f5"
    sha256 cellar: :any_skip_relocation, monterey:       "6698efb30331bd468547b170aeac89be4a8e85ce87f011ee9e66fa93ed5c07f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b012bac5b6579954a206de0ae085b4120194b307f612d82b56228954304b7676"
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
