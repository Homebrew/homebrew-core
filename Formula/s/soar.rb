class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "cccd500786a2f6fe197eba493ab3254d93279c1589ffb56ce417789ffe0312c4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "c4109cefcb788a75ba90a78ad2555820d070a69fdb98a270d1c92a64f75ae6bf"
    sha256 cellar: :any, x86_64_linux: "5e9bae96ceb078391a4b143b8451e2382ae851aae41a4464fe43d373c2d75f57"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', shell_output("cat test.toml")
  end
end
