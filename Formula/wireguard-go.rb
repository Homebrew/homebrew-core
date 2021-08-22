class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20210424.tar.xz"
  sha256 "0f9a7c0657e6119d317a0bab453aeb5140111b186ae10f62cfa081eecf2f03ba"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b5cecc46c8cb3358a10768cd638fefab905dfb66f1ec151af64ce27d152f474"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f3812acc99aaf982518460b33d67930b824e8e86bfd00e9303dd0fb7e94cd74"
    sha256 cellar: :any_skip_relocation, catalina:      "7067cc06c22612f886694f5471b1b7b7d196f9047c1939745f8140d5b1695f1f"
    sha256 cellar: :any_skip_relocation, mojave:        "be446fceccc238dbfe68c3c23cb03feb1e911245934bba66007c263bfeb9114c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93b2808f28f71bc2dca45268cd82a86db23b9f9264df87e0946eef577b62d984"
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
      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
