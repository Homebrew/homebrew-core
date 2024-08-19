class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "374968461ea95fcf22f230aa818cf99cd79af4cd3d28fb0927d5444525b143b3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0b2ce0a308121fefd1ff2c612dfaa3706cb012685fea0ee75b468f5d8d69799"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b2ce0a308121fefd1ff2c612dfaa3706cb012685fea0ee75b468f5d8d69799"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b2ce0a308121fefd1ff2c612dfaa3706cb012685fea0ee75b468f5d8d69799"
    sha256 cellar: :any_skip_relocation, sonoma:         "00be8cfef0140da27a3d980d73e83e5f8b1966ded49cf726acf4a6b4ca64b7e4"
    sha256 cellar: :any_skip_relocation, ventura:        "00be8cfef0140da27a3d980d73e83e5f8b1966ded49cf726acf4a6b4ca64b7e4"
    sha256 cellar: :any_skip_relocation, monterey:       "00be8cfef0140da27a3d980d73e83e5f8b1966ded49cf726acf4a6b4ca64b7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d30217791e6a0007526582ba0057d74119e0956e3aebd7409468d85e2da094"
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
