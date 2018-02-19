class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180218.tar.xz"
  sha256 "4ac4c4e4ad4dc2cf9dcb831b0cf347567ccea675ca524528cf5a4d9dccb2fe52"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "7f6e643686eddd744b23b8c1a0434ea74e1047682c73ab402a766db5001534d2" => :high_sierra
    sha256 "fd847c82d3ea7eec4381d6fadbd6ca97776c5e8ac311ef9f3ec05c21966ee7db" => :sierra
    sha256 "bd126a8c8be3ea810c02537681494fefe6c81b3bcd9e623abbb9c853eb51f0b8" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
