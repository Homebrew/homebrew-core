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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6519c4ca27c2aaaa4b09affe1b0ff2a56be9a44240a790ca1d236992331ef537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6519c4ca27c2aaaa4b09affe1b0ff2a56be9a44240a790ca1d236992331ef537"
    sha256 cellar: :any_skip_relocation, monterey:       "95a2cbb2613984184312837655cc4a1a85e53084f5e7aafcab88ad4a380a532b"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a2cbb2613984184312837655cc4a1a85e53084f5e7aafcab88ad4a380a532b"
    sha256 cellar: :any_skip_relocation, catalina:       "95a2cbb2613984184312837655cc4a1a85e53084f5e7aafcab88ad4a380a532b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb58c98f0a1d9e696c4a20aed8e05962e7b184adf5042fd960ed84bedadb2a72"
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
