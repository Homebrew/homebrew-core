class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "70740ce9bb51c4d77eef94e4d24e8e2405ac9af2ccb1b37340018ed0316190c6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "9939346d70200550b7f8da6ffc39202041daa165800d7dcac40b177031c4fd7d"
    sha256 cellar: :any, x86_64_linux: "a8563b16a10e83df1b8fbd74a981fb49a1f135766c7068e1817915c1e602b784"
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
