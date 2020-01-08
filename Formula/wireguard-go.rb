class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20191012.tar.xz"
  sha256 "f4b651b7da7c93a4318c1231204d7d4529e2610b57041ee99fd85c22301edbcc"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "8a7b16f346fc85f4a6f5c3a251c115f8912fc97975e38bb06d89cbc6a86bf5ae" => :catalina
    sha256 "a83b5669aa33d227ef2a20f2db58fc09ccdbadde417d7cbd4fab69e696a3b86f" => :mojave
    sha256 "af7d625e4662a343bbbe16c87693331722e8435808e90dcbbe0a2e6df545d2f1" => :high_sierra
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
