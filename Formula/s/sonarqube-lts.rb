class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.4.87374.zip"
  sha256 "d1c0b5cde64280a6e0f015dde53687b6d63c8a7e2d6780a879cb0dc23b3a75b7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a4dcd48e90eb407defccb3d7afef0610a8fada0cea043552bf871b2ad904f56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a4dcd48e90eb407defccb3d7afef0610a8fada0cea043552bf871b2ad904f56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a4dcd48e90eb407defccb3d7afef0610a8fada0cea043552bf871b2ad904f56"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a4dcd48e90eb407defccb3d7afef0610a8fada0cea043552bf871b2ad904f56"
    sha256 cellar: :any_skip_relocation, ventura:        "4a4dcd48e90eb407defccb3d7afef0610a8fada0cea043552bf871b2ad904f56"
    sha256 cellar: :any_skip_relocation, monterey:       "4a4dcd48e90eb407defccb3d7afef0610a8fada0cea043552bf871b2ad904f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ede8d2ff66a69f9cec98c6c7ab5f74388974244c82db081408ed4405c0afed33"
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
