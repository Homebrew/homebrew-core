class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20210424.tar.xz"
  sha256 "b288b0c43871d919629d7e77846ef0b47f8eeaa9ebc9cedeee8233fc6cc376ad"
  license "GPL-2.0-only"
  head "https://git.zx2c4.com/wireguard-tools.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30909b7220b43135eb3a0d37677ffc86245016b6c3f5d672dbffab01673172da"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f153d66ddac6cbafa6877e29af6ae58b32abd63331c372f86fa72e5d0a6a0e9"
    sha256 cellar: :any_skip_relocation, catalina:      "59c67c1becf7d8d52f666094c71404e4f1bd133747bfdad717145a14a1c2a04f"
    sha256 cellar: :any_skip_relocation, mojave:        "99745e645ddbed286defa52eeb6862325a09be2aab48fa04b23dec6686513a1a"
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
