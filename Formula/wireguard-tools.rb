class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20210914.tar.xz"
  sha256 "97ff31489217bb265b7ae850d3d0f335ab07d2652ba1feec88b734bc96bd05ac"
  license "GPL-2.0-only"
  revision 1
  head "https://git.zx2c4.com/wireguard-tools.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b259fd595487c21cc4b6c90afa90db9fee8de0f24b1cf84b0d5aefa004c870f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f69a9518761bd34c5dfdb235e5e40dbcf01e9456fa434d75ea475ead3bb2db2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b057d7864b252c1491fb43781089b367e34a50c28205a48a71bf840e91bc7b86"
    sha256 cellar: :any_skip_relocation, ventura:        "84b07859344b28045a31729b8b0236a9d68613bc9b4b9fafd0a97afecda8bbde"
    sha256 cellar: :any_skip_relocation, monterey:       "fedc27b84e7ad3adc4679e8a07f9ec1cb28adc689c7db91bbc566c36a6694310"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a910e42465d73b85af98fb2fe7d14b2b95599061112f497cd48f80f5a062f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96e4f05a320dad90bcf53e9e1e41c19da5e0bb242e9af596a6204d99fee681a"
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    cd "src" do
      inreplace ["completion/wg-quick.bash-completion", "wg-quick/darwin.bash"],
        " /etc/wireguard", " #{etc}/wireguard"
      inreplace ["man/wg-quick.8", "wg-quick/linux.bash"], "/etc/wireguard", etc/"wireguard"
    end
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
