class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170517.tar.xz"
  sha256 "7303e973654a3585039f4789e89a562f807f0d6010c7787b9b69ca72aa7a6908"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "51a76cacdc64f2c7514c67d4973b0c9c3ddcfd74495d3f497f21f2d1fa93e745" => :sierra
    sha256 "5ee2b99ce5433a1d612abc41acb88e53169418c575c964200952d30d9d2522f0" => :el_capitan
    sha256 "449bbc2258934fccf6e90770179c3609fdb7f2592dc7166bf594f12e167b22da" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
