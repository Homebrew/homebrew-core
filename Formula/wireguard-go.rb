class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180613.tar.xz"
  sha256 "3e22e6f2a715f05f9bbc5b1a9c737ab2edc8f26b2af61f9cc31f83391cd663ff"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "853ed072be489b8be2fc574400c4c7d34d56386476ddd24d8d5577de1175c67c" => :high_sierra
    sha256 "040e873a5738f8b35fbe34dce506e1a7bed8b1dbc99a6d43ad90122a60b5c544" => :sierra
    sha256 "7173aa41675e04ea0a51b5d3a3dcb1d4cfb47e44b004320fd1fb4cbef8710eac" => :el_capitan
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
