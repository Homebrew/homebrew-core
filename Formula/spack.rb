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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94d242fcbb5bcb1bb55dbe6cce7e687584aab95e993ea819358be79a1134e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94d242fcbb5bcb1bb55dbe6cce7e687584aab95e993ea819358be79a1134e18"
    sha256 cellar: :any_skip_relocation, monterey:       "d28050f49cae4ed5136fffe0a04d6b37966aa71d1a7d2a8820f0cbfc2608fe50"
    sha256 cellar: :any_skip_relocation, big_sur:        "d28050f49cae4ed5136fffe0a04d6b37966aa71d1a7d2a8820f0cbfc2608fe50"
    sha256 cellar: :any_skip_relocation, catalina:       "d28050f49cae4ed5136fffe0a04d6b37966aa71d1a7d2a8820f0cbfc2608fe50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6af4078fed14988d0903dd41a8c8a70c962c906447fa8b3a1fbbc963b164d50"
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
    expected = if OS.mac?
      "clang"
    else
      "gcc"
    end
    assert_match expected, shell_output("spack compiler list")
  end
end
