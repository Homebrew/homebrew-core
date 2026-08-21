class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "1366ada8ffc7d1eb1956934696cfdb54d6fb6253e71061c28ae416474b2f3b5f"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88a7b02fdcad942ec020a69437de5396c9126b5802a039a1588010e8769f5ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217702aa9fd4453ad8bd4afc8448cc3b2ecef521e653951cf32e53802dbad536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c898e71a6c30bbf87fe8f8bab83fefa1c6bf5f22163475721c1da40140181867"
    sha256 cellar: :any_skip_relocation, sonoma:        "0340f0dc87d7df18b383dd463ec89958729ea28859d17feb3972aad542dac82c"
    sha256 cellar: :any,                 arm64_linux:   "5226255438f3dfd9a2ac515e2c6de8701a2bea5319daba1a5284095a085696a5"
    sha256 cellar: :any,                 x86_64_linux:  "09ecf80444c84ee33f2032657e05ae53a41809d9732ee3c9547de496204f1ba9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end
