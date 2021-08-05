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
    sha256 cellar: :any_skip_relocation, big_sur:      "25ed99650ddba6303a40c641d9a63d235ed69d159688c158195924743fdcd3c0"
    sha256 cellar: :any_skip_relocation, catalina:     "25ed99650ddba6303a40c641d9a63d235ed69d159688c158195924743fdcd3c0"
    sha256 cellar: :any_skip_relocation, mojave:       "c0b6fb89e3a481c89fcc5f67bdfa59898530831de4937833424a79a4c8ababe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "22f5ad737ec068adbb0653a92209adaf193bcfec395fa496c879fffbc08de56d"
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
