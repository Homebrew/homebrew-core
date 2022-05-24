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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07fe4038743e02c3474db81af543dcdb4ff35149eaacaae0944695f05facb140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49c9d68a379b6d68e45d6a7af04e8d684102a2f748b54d67e652a75e2fd0b671"
    sha256 cellar: :any_skip_relocation, monterey:       "5b75283c47dc11a78114df31782b10f3715525ea18265c5bb059efbf32827f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "685bbaed5298bbb87c76e3166ee6ba2af26e322ef86bec67db51bc293bca250d"
    sha256 cellar: :any_skip_relocation, catalina:       "f66feff3fea2b654a6dd4af64cf42af35a57b9057aea22714e9ad56e7aa0ca25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f1243b3617996b8a28480f700f491ed3c7bd92423a0f5a8954230244f99d75"
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    if OS.mac?
      assert_match "be utun", pipe_output(prog)
    else

      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
