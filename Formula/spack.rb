class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.18.1.tar.gz"
  sha256 "d1491374ce280653ee0bc48cd80527d06860b886af8b0d4a7cf1d0a2309191b7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6795d73f3871790496ded8e3e7f7bcb2048bbf9adaeedbe9127e2041ad2ce51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6795d73f3871790496ded8e3e7f7bcb2048bbf9adaeedbe9127e2041ad2ce51"
    sha256 cellar: :any_skip_relocation, monterey:       "3e61196fe5ea3e29d8c0e16f4f771c503a16b9d8dc62c88cfa336dde511974b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e61196fe5ea3e29d8c0e16f4f771c503a16b9d8dc62c88cfa336dde511974b6"
    sha256 cellar: :any_skip_relocation, catalina:       "3e61196fe5ea3e29d8c0e16f4f771c503a16b9d8dc62c88cfa336dde511974b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c064bb613b3784ab0fdac463a919a3a16195e1b829296b5a47fe8f29748c2aa6"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"] # Remove Windows files.
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    system bin/"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}/spack compiler list")
  end
end
