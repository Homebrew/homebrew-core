class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "82cba98bd091ca28ccceddf48c4b96354786ae5c9650013c1174327a1346c2a8"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7de73b52bb3a7a58c6b39108c9268501d3ba351eb7c0c9ea3d64e146335e4591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a229a0f814f9d2d61f1ec5f57cb917945aa11efcc10c80f64c546882519ea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0656df631f46d42cc824e50e9422a83b9b60b8f1da357841e0b1785cdfca6777"
    sha256 cellar: :any_skip_relocation, sonoma:        "2350f7094b1c97b4b5511f003743b3eb03765be584ccab12166b963042b04691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "188bbcd7b38bdcd05995441204c9e134f1545db9ef513c523e87cc2e367112d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "990791f71181b270078c5885b8b29abf54d3523f55fcd132bc72a70714149971"
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
