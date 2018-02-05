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
    sha256 "790cd025a7f17c08f9e0f472878a04d572c1eb2109e5e47a585b48de50b9be1a" => :high_sierra
    sha256 "908d4685660013aaa80617e8bed2a91cb3fd2e7af63c64329bc72eb8bed913b4" => :sierra
    sha256 "425b537e2fac1da694a592ec226f4b2e6cf70b6f0845a7d2d45e770758c551f5" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
