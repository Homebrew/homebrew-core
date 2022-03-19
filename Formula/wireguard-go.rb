class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20220316.tar.xz"
  sha256 "fd6759c116e358d311309e049cc2dcc390bc326710f5fc175e0217b755330c2a"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18544f2f0ddf425989bc831f638a421e15e5284df4f2b4fe4ed3907fb3677ec7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4c43642e61320c89b71730d44edde8995d93c8a820e989e0868860de6772976"
    sha256 cellar: :any_skip_relocation, monterey:       "764c0cfd35cb75ca0614f706d3d25b91ef7c1f1dabb551f91a922a1b03aad5a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f91612ca3745ee25bebf7436d8085cfa6ede17236250b63098f28ec4b7e832e"
    sha256 cellar: :any_skip_relocation, catalina:       "e58d72efb3b988f224ce982dea787ba47b6a09b195cc02f4949ea996da8bf63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7498d0c23450d19a1c60ab1cda404267ffc9472720f05fe3f7edc56952be7cf6"
  end

  depends_on "go" => :build

  def install
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
