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
    sha256 "90b7b83d8c7905d0da543d3a919f096684f27062d9862f30206c5e1539fe1dfc" => :sierra
    sha256 "2d82452bd410bf985327ded902f25a7d59d83ad807dcbed1b878d9a4d3a91c58" => :el_capitan
    sha256 "6d6af74d4658ea2481a9ff9ed84eb89d73c0e56bc62b1283a0dedbe2c6904234" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
