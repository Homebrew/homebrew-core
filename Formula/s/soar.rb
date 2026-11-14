class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "1d25902da726b992200cfd573b9e8ffe34585f5e19ffd3bf6644255716390e34"
  license "MIT"
  head "https://github.com/pkgforge/soar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "0f39b801425934672aa2a1cb6720bec1099cb7eadeaa7e7c591f2c8c75209bda"
    sha256 cellar: :any, x86_64_linux: "715f25b152ff749173d0b7793b19ca72520709bc5508326e0fee28b6c408dd26"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', (testpath/"test.toml").read
  end
end
