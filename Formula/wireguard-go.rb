class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180531.tar.xz"
  sha256 "1cb6add9139fc3bce39ed45b327bc0f13472b685e060691c58a30142ed4e26d2"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "f17534132c17739352348e191891c8ae73aa52f929fe121f43817fc7aa0b574f" => :high_sierra
    sha256 "1df6c730fe9a50ae35575d6e16fd2b6875358757c9524d0584fcf37cc70b7d0a" => :sierra
    sha256 "0e82558f384de6e6a9d517bf3f67217d7ba84713363e9e4fb4011400f73e134a" => :el_capitan
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
