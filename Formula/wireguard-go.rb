class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180519.tar.xz"
  sha256 "d2b0f43679b3559952cf8d244d537903d03699ed7c8a2c1e7fc37ee424e30439"
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
    ENV["GOPATH"] = buildpath
    (buildpath/"src/wireguard-go").install buildpath.children
    cd "src/wireguard-go" do
      system "dep", "ensure", "-vendor-only"
      (buildpath/"gopath/src").install (buildpath/"src/wireguard-go/vendor").children
      ENV["GOPATH"] = buildpath/"gopath"
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
