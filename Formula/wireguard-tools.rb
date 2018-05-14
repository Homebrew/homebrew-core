class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180513.tar.xz"
  sha256 "28a15c59f6710851587ebca76a335f1aaaa077aad052732e0959f2bae9ba8d5c"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "5090b31dc847eb46b2be6c17f44111d1480513581c6ac082d8fc1797a64324a5" => :high_sierra
    sha256 "9008f78a89da3b9a8ffebd6993b43f8454f74b2ad5ceae74d8fd88374c598379" => :sierra
    sha256 "bc4cebbd91c650870f7ddb34f1f7957597e6c91d997aee772c4e958238be0546" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
