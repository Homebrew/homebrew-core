class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170629.tar.xz"
  sha256 "51c44624f20eaff96780845214f85491c0c7330598633cd180bb2a6547e5d2b2"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "d105b07dd9d82d49ca78b62e546881913d4fb33dba29eea507e05c05b0b843b0" => :sierra
    sha256 "c3d924fedcf37ffaa5d8a865773d64a7f1e74f6441a066184fe804bd73ad7727" => :el_capitan
    sha256 "f4d7f7cbd326e2d62c5df0089a3d50a9b58422cc39396b4d0ea8d5ecfbea845c" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
