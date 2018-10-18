class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181018.tar.xz"
  sha256 "6bedec38d12596d55cfba4b3f7dfa99d5c2555c2f0bf3b3c9a26feb7c6b073ff"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1701eaf394c72b0e92f117d07eb5a05fe3c6c2e690cff97cf2e198178e164823" => :mojave
    sha256 "54dea98cbbd7942e8bce1ed3135b1e5190f91a428e9fb6f699211e8995a82e8e" => :high_sierra
    sha256 "791644f37fbaa1ec7bc4b115f4cc1d19420f110a4c96075bddb4f01048fb2221" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
