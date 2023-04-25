class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.19.2.tar.gz"
  sha256 "4978b37da50f5690f4e1aa0cfe3975a89ccef85d96c68d417ea0716a8ce3aa98"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "537c9b1165797769bec834018b8194cc27b4ae350f5b8e58f108a173b87b30c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "537c9b1165797769bec834018b8194cc27b4ae350f5b8e58f108a173b87b30c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "537c9b1165797769bec834018b8194cc27b4ae350f5b8e58f108a173b87b30c6"
    sha256 cellar: :any_skip_relocation, ventura:        "f337781daace40e9c7a338df5be67747679c9a5d16ec185afcb1416ce9150bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "f337781daace40e9c7a338df5be67747679c9a5d16ec185afcb1416ce9150bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f337781daace40e9c7a338df5be67747679c9a5d16ec185afcb1416ce9150bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cac0fa099061422d1150fa175f0905fac81f721e79b92e0ad795548ef4321875"
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
