class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20201118.tar.xz"
  sha256 "8b9f3dd5f7083118fae9259868f994562270167a7ee9db28c53f415f0b20a388"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8202a28ec02de5c7e82afc087610a85c3704bb5413890cc83c83e8a98a8e6650"
    sha256 cellar: :any_skip_relocation, big_sur:       "75c2b3b1531830c9cd45eb7569a7b8c0d8e2896d4123cae0a15cc1ceeb4f3da0"
    sha256 cellar: :any_skip_relocation, catalina:      "16df54f1adef2a15ea9c5cb4a51a4696e423bfc5a4449b264376d97877b48218"
    sha256 cellar: :any_skip_relocation, mojave:        "412be0aa4d2f277825695e732099f62f0183d9eb9e85286c25cc7624589d0ce6"
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
