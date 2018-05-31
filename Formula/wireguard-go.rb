class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180531.tar.xz"
  sha256 "1cb6add9139fc3bce39ed45b327bc0f13472b685e060691c58a30142ed4e26d2"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "20a47b91c606d368beb184bfb6b1704140c8684f8d0a83e54df335df099d3f01" => :high_sierra
    sha256 "6472e50a74971cde26e1326512ac9a09f69fda3052cc061e0803ea95ddef90ae" => :sierra
    sha256 "5b1628b76fa928067dd7dfa5c5a96b938a82e351f42b17091a1027377b94d618" => :el_capitan
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
