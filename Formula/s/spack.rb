class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.20.2.tar.gz"
  sha256 "62f87ab6ca332118f2812a255edcf4be4977623d067b9396251ce8c44b158e49"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61781b1aa693de63fb62a8dbdc1809c7b4b57ed7de6f9e07c190f497b644caec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61781b1aa693de63fb62a8dbdc1809c7b4b57ed7de6f9e07c190f497b644caec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61781b1aa693de63fb62a8dbdc1809c7b4b57ed7de6f9e07c190f497b644caec"
    sha256 cellar: :any_skip_relocation, sonoma:         "f31b431a919c539647d51064eb252b369417b4df2db2b3603f7dc7a7a686b8fe"
    sha256 cellar: :any_skip_relocation, ventura:        "f31b431a919c539647d51064eb252b369417b4df2db2b3603f7dc7a7a686b8fe"
    sha256 cellar: :any_skip_relocation, monterey:       "f31b431a919c539647d51064eb252b369417b4df2db2b3603f7dc7a7a686b8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9e5e4b18e4350d5992a0ad01cdeb78567f331338ec16dc388a310cfa1aadb8"
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
