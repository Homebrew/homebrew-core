class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20190908.tar.xz"
  sha256 "3c4cc802a521736d01d24bfb4fe29a5e74da07d69637ec7bcdee074decf62c6a"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "29959d4a87c09636b0f3dd89905dc0f9d81862ccf942c67834b162f7cac66d0e" => :mojave
    sha256 "bbe9ef9b46de18a4133f62b93204aa5d06c3129e9ffbf90e9e87a1505193c2ce" => :high_sierra
    sha256 "a4483d505d39194f2e0c091eec94332f3be8c59d5b019f71eec4e3703739f377" => :sierra
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
