class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Despite the experimental tag the tools themselves are stable.
  # Please only update version when the tools have been modified/updated.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-experimental-0.0.20161103.tar.xz"
  sha256 "e9d6a97002e0b63bb9572bf42037a7f5b67ccad421fec3afac684e4fc5e931ac"
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
