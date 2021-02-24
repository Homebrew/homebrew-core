class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20210212.tar.xz"
  sha256 "a44dbf8e18fed0d24feb6cc5782d0e7c4dfd0ffe35401a3f5e66c1da2936fa31"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "162f7ad7f901af452d744d37a3be0f188dcc09f01109f91c7f5e29ff8a4c5d1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb5f5aa7a36debffb04b279e207a08f09eee9aa8f29f33561a1ec96f7d8d40bb"
    sha256 cellar: :any_skip_relocation, catalina:      "ac3b82d9f4ecc195f3f162e2da8addb8a60ecaff2564a955b55ccf8f4fd1c02c"
    sha256 cellar: :any_skip_relocation, mojave:        "38a730c0c5d0a27e6e0a8221da3e9200737830d7d77e9af6ac61b258dcd573be"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    on_macos do
      assert_match "be utun", pipe_output(prog)
    end

    on_linux do
      assert_match "Running this software on Linux is unnecessary", pipe_output(prog)
    end
  end
end
