class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171127.tar.xz"
  sha256 "5e0a93cccce70e5758ddebaaa94d3df74cb664f592895efbd43dc6171ee5b25b"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "b29209edb086202846cfe37ff33a6f1651d475a5260f6656682292c8b8f4d363" => :high_sierra
    sha256 "dbbb925bb5efba5dcb5592a41c5139e1ddb7dce434df42c2e3e2fbfefc27908f" => :sierra
    sha256 "4a082964646366fdd18e1a116a29e4def80a3bf5c2d284c6a4d846717d944f12" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
