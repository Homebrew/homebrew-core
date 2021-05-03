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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6814c231237dcbfaf07ca6c32a581b8e0c5cb77221a810d49b8ca9d2ea6a9e77"
    sha256 cellar: :any_skip_relocation, big_sur:       "a430931f6c5e75da8191a52f25d5e596d821fa895ca1cd7cbf6e567baa053411"
    sha256 cellar: :any_skip_relocation, catalina:      "eeecbb9a6788baaca5d07f6304750f1d9c05c4e10096824e4c297f507ff00d60"
    sha256 cellar: :any_skip_relocation, mojave:        "71d028421938522d7a435f5c5fd5c4e18dc28bcd53a380466fe05ad844d480c1"
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
