class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.10.1.tar.gz"
  sha256 "5256629b0b063b51aad317dbd8f385ad0d56cc4155621d9bb0f6484aa2e7c95c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d297bb2d57c6c978cca4b6128ab1e997ed215fe541e6dfc6996fa91e5001d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9ca787b3e30a93ed36ad0a3bf7e323c90cce322e53321f9f8e699bddb3c4077"
    sha256 cellar: :any_skip_relocation, monterey:       "cf216c574ffb9ba612501ecb300ad62efd51c2361f43fe2f7d6fcd24e02679cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "35c88fe762c8e8ed6c1b67540ac1eca844961f368828d83f994da73ddd62dc2c"
    sha256 cellar: :any_skip_relocation, catalina:       "569cc39bbd032bb6d755b201b3ad3dea40c1162071592fa1e70605b7034f53b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ee5ad57ba8a70d91bbf552441a78c2f558699dbccad738f4ed9c4cd92e3e90"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
