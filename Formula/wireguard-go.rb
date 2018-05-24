class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180524.tar.xz"
  sha256 "1d539f6c51dd33098a536af0285ef03c561db0ff343f23a75405207fcf48ec3e"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "7c099fd56980611fae8959627ea2f6b33b21e87eb9f03f1cad1cfa15ceab7e89" => :high_sierra
    sha256 "98fe4acca321dc743bdb5ee13534ed6b66671d6b5df220ee686b4416c888882a" => :sierra
    sha256 "efa57af38a1294d79201004ecd98051a9c385bfe2a785f3280dc3dc175389bee" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
