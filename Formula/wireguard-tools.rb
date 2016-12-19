class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20161218.tar.xz"
  sha256 "d805035d3e99768e69d8cdeb8fb5250a59b994ce127fceb71a078582c30f5597"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "f9d6bef22afadd09e06c9404bb2315b58eacc8ee468b14d1d725e859f309475f" => :sierra
    sha256 "fe4b23392954c044bba1b89f67878a0b11495a4ae0ae3a2ec00166adc48d813a" => :el_capitan
    sha256 "eaf7f5d5ed70fd650a3935c3307af2a28b7c1a5d3fe421aa63365dbeaded9247" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
