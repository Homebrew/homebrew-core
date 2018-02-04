class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180202.tar.xz"
  sha256 "ee3415b482265ad9e8721aa746aaffdf311058a2d1a4d80e7b6d11bbbf71c722"
  head "https://git.zx2c4.com/WireGuard", :using => :git

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
