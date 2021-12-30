class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.17.1.tar.gz"
  sha256 "96850f750c5a17675275aa059eabc2ae09b7a8c7b59c5762d571925b6897acfb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e7233d05e67ecfb9664e0aca3cd9f18aca48aa9ba7ffe5e4ec87367e9786e88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e7233d05e67ecfb9664e0aca3cd9f18aca48aa9ba7ffe5e4ec87367e9786e88"
    sha256 cellar: :any_skip_relocation, monterey:       "22176d71173973e99ef931baf659a1b46c5a178c20380f647c9e3890ad30d933"
    sha256 cellar: :any_skip_relocation, big_sur:        "22176d71173973e99ef931baf659a1b46c5a178c20380f647c9e3890ad30d933"
    sha256 cellar: :any_skip_relocation, catalina:       "22176d71173973e99ef931baf659a1b46c5a178c20380f647c9e3890ad30d933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b415b31956e60a2e0ac75f5fcebe24cf38f520805609767341c7b8eae05607"
  end

  depends_on "python@3.10"

  def install
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    on_macos do
      assert_match "clang", shell_output("spack compiler list")
    end
    on_linux do
      assert_match "gcc", shell_output("spack compiler list")
    end
  end
end
