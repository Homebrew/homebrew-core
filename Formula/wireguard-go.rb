class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20190805.tar.xz"
  sha256 "2f56d2c4ebc3e50d581e92c046ebf3c884c703c4d5b3b484e45f55e50c0034da"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "6c00aa32912204b9197742ba84a2d96402d49e66fba03df1417ff4bdf177038f" => :mojave
    sha256 "faaedaff2e6101eed4766f8d7fac6026e8d5413dfe853f3fe7f2abd0fc66a831" => :high_sierra
    sha256 "3f78a474cdcc13fa156857482bf8d52a2e59672efb139b3797fcbe55e1b2d43a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
