class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171122.tar.xz"
  sha256 "c52f0694f4e11129a80b60a0d2fe75729f1ad39e3fe4e3ee569629ff21e3ed89"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "267434021767051d2bd4431b016359005ff3738a35bdccff04a302aab6d89884" => :high_sierra
    sha256 "2013a846d03b00902e34950290eb6363ff75ec7316d25d7ec67aee611b6455db" => :sierra
    sha256 "99c8f5f200f73a9ba8f6dcb51ed4876e7c6dbcf3cd5a7bb41975473676102e29" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
