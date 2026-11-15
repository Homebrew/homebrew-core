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
    sha256 cellar: :any, arm64_linux:  "8f1c4aebb6bb80706b86ffd73796353408d97cb2299619fd91e482fb6dcb4fcc"
    sha256 cellar: :any, x86_64_linux: "f0168dfbde76f2d3d5418cbd41660ea8e41abf41df570c4e054ea2b3c2211f0b"
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
