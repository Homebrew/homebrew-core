class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20190409.tar.xz"
  sha256 "bd7305d69435438ece56df62695197c38469fd0be8c9b6fe56484b6347bf05d6"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1efcc1d6bacea0eb997da3f1fa74849c00ddb9239b9433e119af85f2261c8e41" => :mojave
    sha256 "bd8a7b899f8b6a99390e32561b40cfc51bf81239bf7af229e9ccad51868e7db5" => :high_sierra
    sha256 "c65c7a1dcdb68edb8185ffdc4b537f38d5af131b5360dd0d197fe95d22f1fa6b" => :sierra
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
