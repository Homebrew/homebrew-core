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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec261406c590d6bc68664f9b274db3a3964080d63c687f53bc1e937a5844da9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2ee15e40130965624f02276e19a3c4a63779488ca202feafcdb4ad82f3b29b4"
    sha256 cellar: :any_skip_relocation, catalina:      "fff46901d402987fba895a6b55aafe5a4e57fa125eae5bee3bbc8fb86b50dc8d"
    sha256 cellar: :any_skip_relocation, mojave:        "9ce81db6287f675b7072b8bace9f13af74340ae3084b2cffaddb4bdc14474890"
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
