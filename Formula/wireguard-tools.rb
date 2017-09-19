class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170918.tar.xz"
  sha256 "e083f18596574fb7050167090bfb4db4df09a1a99f3c1adc77f820c166368881"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "b8293b2fa77eb22bd3c1c452b16c5526ee994814f4dbe1c47ae69162a5283709" => :sierra
    sha256 "7b349e77994b70e10ee48f3da41bfd490708a14b13f44988cd798adb261dedd9" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
