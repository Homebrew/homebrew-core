class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181222.tar.xz"
  sha256 "53dc611524c40cddd242c972a9559f9793e128a0ce772483f12a2704c9f48c54"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "25839f9caa700b230ecaf2d8ad47a81a2dd1b181e8a360859bdbc9446d9c4cc7" => :mojave
    sha256 "edc96f16ab774090b850d5f54394046280d1f92c0c1f5c6b0d5dfab66c7ca22b" => :high_sierra
    sha256 "4f5c2e94d6f2ffca021618908cd6100157550c361ab97b0e5d3701d9d2d32132" => :sierra
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
