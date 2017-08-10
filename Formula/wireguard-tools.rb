class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170810.tar.xz"
  sha256 "ab96230390625aad6f4816fa23aef6e9f7fee130f083d838919129ff12089bf7"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "7e92459ea705eafe236f81b419f363c2685b13388418fcdaba523b1cdb48bcac" => :sierra
    sha256 "d50b6f175745d5404ba8ffd587270822c36fc4bac5026189a86656814224b78c" => :el_capitan
    sha256 "f4e77a3b7bfb1fdd564d7d421d55eb37af5fbe958901eca66dff02589b5751b7" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
