class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171017.tar.xz"
  sha256 "57b79a62874d9b99659a744513d4f6f9d88cb772deaa99e485b6fed3004a35cd"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "cb8fdb16ff9045daf00ef8b63acc4697be4fe4e44a0c86f89eb1912689aee333" => :high_sierra
    sha256 "8c5ba7ac8d1baa35c72b2db32febb6c620d85299fd4674d37bed0cd198ae1859" => :sierra
    sha256 "f01bc9d7c1000fedcb8577359d3bef533ee18872bb4bbe645c6da9cd65f74851" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
