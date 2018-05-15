class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180514.tar.xz"
  sha256 "e895b65e06e85429403be3d1987577a6967476b069f0ff53caead6f682f466da"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "5090b31dc847eb46b2be6c17f44111d1480513581c6ac082d8fc1797a64324a5" => :high_sierra
    sha256 "9008f78a89da3b9a8ffebd6993b43f8454f74b2ad5ceae74d8fd88374c598379" => :sierra
    sha256 "bc4cebbd91c650870f7ddb34f1f7957597e6c91d997aee772c4e958238be0546" => :el_capitan
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
