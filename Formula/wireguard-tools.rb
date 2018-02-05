class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  stable do
    # Please only update version when the tools have been modified/updated,
    # since the Linux module aspect isn't of utility for us.
    url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180202.tar.xz"
    sha256 "ee3415b482265ad9e8721aa746aaffdf311058a2d1a4d80e7b6d11bbbf71c722"

    # Fix "fatal error: 'endian.h' file not found"
    # Equivalent to upstream commit from 5 Feb 2018 "tools: endian.h is not portable"
    # See https://git.zx2c4.com/WireGuard/patch/?id=d99954e0376d50c31f052cd6455e8665d9d9dd66
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/4e4ca86/wireguard-tools/endian.patch"
      sha256 "68d77d13a7fc748f02e4a78eb405599b04d1b99dcbee8af06cf8eb8f0ba9c908"
    end
  end

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
