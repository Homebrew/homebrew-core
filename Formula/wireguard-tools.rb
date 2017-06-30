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
    sha256 "555947fab6bf3d26b37275a56e7f69e4dadbc17fd2be0a8f10a7ef79907da9d7" => :sierra
    sha256 "7bed55755ed259a4417dd853d83e6f8afe39831b558301ac3791f049f146998b" => :el_capitan
    sha256 "c018c3838af28393b211229c55eed750bcad7d773f5e293fdada737ae4294378" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
