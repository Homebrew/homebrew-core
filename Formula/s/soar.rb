class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "1d9a15865895e1a4e08dc0a24382512a458653e1c959db4bae4760545b3e6a04"
  license "MIT"
  head "https://github.com/pkgforge/soar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "52db12777c88d0d595f2a76a3cbbe8f8ca7be9472ce114862927ebd46d7f24b8"
    sha256 cellar: :any, arm64_linux:  "64b3c32b9b247e519fee4f82ebb2efa2cd19aec3df357387fa3dfaa35f21fe12"
    sha256 cellar: :any, x86_64_linux: "a8fedf33318b607041338f0494f3bc678d7a1d79d8d90cc10a2c10c8a989e682"
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
