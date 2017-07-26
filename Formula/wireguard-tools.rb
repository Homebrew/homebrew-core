class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170726.tar.xz"
  sha256 "db91452b6b5ec28049721a520fe4fd0683825bad45b7383d12d7b819668201db"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "5fd8a8d7474296b8de52f9241aa3c218aea3df890e984c0e8d28146f0ed19aa2" => :sierra
    sha256 "cad9283cdca98facc4ec1af60b5a274dad3807450e5f6b8d06b7dc0c82144f42" => :el_capitan
    sha256 "437958508d282f99a65859c8b6c1e093e7e32e8097efec4865145346f05915b5" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
