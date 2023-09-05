class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.20.1.tar.gz"
  sha256 "141be037b56e4b095840a95ac51c428c29dad078f7f88140ae6355b2a1b32dc3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5111d4ffb1be8bbeba5f918eb67d85386f789af65da08b4b675d1908e13aa47b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5111d4ffb1be8bbeba5f918eb67d85386f789af65da08b4b675d1908e13aa47b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5111d4ffb1be8bbeba5f918eb67d85386f789af65da08b4b675d1908e13aa47b"
    sha256 cellar: :any_skip_relocation, ventura:        "dac4de5eca776add618fc66d3cc601aecaf1a9c0def08ce074632d2a68ce2ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "dac4de5eca776add618fc66d3cc601aecaf1a9c0def08ce074632d2a68ce2ac4"
    sha256 cellar: :any_skip_relocation, big_sur:        "dac4de5eca776add618fc66d3cc601aecaf1a9c0def08ce074632d2a68ce2ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1239c89be5e006ccf00fca3d40f6d66ebeba426b62ccc659394e3edd9891f73f"
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
