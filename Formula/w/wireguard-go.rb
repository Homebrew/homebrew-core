class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20250522.tar.xz"
  sha256 "c698fb9fd09d48e8cf5c1eee3e5f0170f1916a7eed09ba025aa025cd5e721a20"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ae096c9cefaf2ddf1d4c1eebf19ed71a02adf9c9b020b538f6216244fe3a2fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c19618a231e9ca6c62dd268de8ab8905256d96540a252f0cebf05548a3939c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c19618a231e9ca6c62dd268de8ab8905256d96540a252f0cebf05548a3939c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1c19618a231e9ca6c62dd268de8ab8905256d96540a252f0cebf05548a3939c"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6d403f493b281677d95e79448776275d37b728b966fe23f80f1079ecf35d61"
    sha256 cellar: :any_skip_relocation, ventura:       "db6d403f493b281677d95e79448776275d37b728b966fe23f80f1079ecf35d61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfba7916b334b184cde873b2fb11f67369ca88c1a55d176e3bee0811b679a53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fa36967d0cf07ae25e5af14c9b136de29cf5d53f6bfc4f58e66574d3a5aa61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    expected = OS.mac? ? "name must be utun" : "Running wireguard-go is not required"
    assert_match expected, shell_output("#{bin}/wireguard-go -f notrealutun 2>&1", 1)
  end
end
