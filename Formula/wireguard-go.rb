class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181018.tar.xz"
  sha256 "6bedec38d12596d55cfba4b3f7dfa99d5c2555c2f0bf3b3c9a26feb7c6b073ff"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "505cf5f7b28b296ed6137d6e3532c3a51a3074165824abd63ea1be14bd0562ae" => :mojave
    sha256 "e8eba0f2b7ac40344d0720208382d8738f26d0f8a0a8ee21be8f809a52690d0f" => :high_sierra
    sha256 "8156e45dab29bc6df4f2d9b23f8c3f9f03c709dc7254605480b9be32fb26484d" => :sierra
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
