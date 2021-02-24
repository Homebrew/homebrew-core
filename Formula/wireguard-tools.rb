class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20210223.tar.xz"
  sha256 "1f72da217044622d79e0bab57779e136a3df795e3761a3fc1dc0941a9055877c"
  license "GPL-2.0-only"
  head "https://git.zx2c4.com/wireguard-tools.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3528b50affb6bb5a991a4d3389e1c215a2e9cd9a1591c65eedade9253f1f5ead"
    sha256 cellar: :any_skip_relocation, big_sur:       "58f2cfaeb9053557487a81d32db19af9610ab7084183fa9dae645e6bc06818bb"
    sha256 cellar: :any_skip_relocation, catalina:      "a4e4e92ad654b6f90345337fe1b52543c2f9714cf0e1ca9b3e9a05cc636637d4"
    sha256 cellar: :any_skip_relocation, mojave:        "c23c30b23e792e4e7c888c3ac0cb6e9ae85b09ac2722c51fe867280f802ead13"
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
