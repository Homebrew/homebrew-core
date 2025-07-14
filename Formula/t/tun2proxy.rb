class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "0452e8995447f458544b005f80c34961da11fe926f1d17c5833d09ab77ff4019"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cbe017b64e78b312c1fee551df9b16dbfa6f2217582fd1584a6c9760e068ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14701d0364c5b6e7c484923fa2fe2b5db568acef8ab1b1891c619b75dba22621"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3038689699f6824d74706a50dd936d826cf9f19bdc2359fdc3c834b63df2bb2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c04c6fb8e43088bdfd11dfe013fa84153b2a2415771e1ea87670175abf15342"
    sha256 cellar: :any_skip_relocation, ventura:       "3cbb5a28489b7cdc03955b191850d296cc583d54262a2a5d40cefe06f0f9d2bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc689a7f09d1c12c15b2803eebbc6e08b300b7d68b5ad7d9601f6c3a78b2a1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b90894f730af22eb154662bd07e0f97a211ae1b4b04a087990aeb2d3e97ab61"
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
