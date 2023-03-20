class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.19.1.tar.gz"
  sha256 "c9666f0b22ccf3cbda2736104d5d4e3b9cad5b4b4f01874a501e97d2c9477452"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e943d10efdcbc725797b313713801db7490ed0f0012ca4f0ed259c4fb1f871ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3276f6f499a3df1a627871c0d94b080cffaba49b89d86bbd38a6053266d5584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f799a963dd10a73a19611628381028f73a0827231db80531ce80253f2b6eae4d"
    sha256 cellar: :any_skip_relocation, ventura:        "95afa45de7fe533db6d4d1b1a65a9c890a4e05c45a0fc646ab6d44ff7ab60060"
    sha256 cellar: :any_skip_relocation, monterey:       "2e42db9232335e44475639d36e4416025fd2cfea701772e6599fd804676650e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f6c2b86e99d7512e2b883186efee7f849d28d8c045d72a6eba9bc2588c6aa15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b4e3db63b08c7dec9773de6d3b315a3fde0df78d9d7f803341f9e56c04757c"
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
