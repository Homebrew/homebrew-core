class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171211.tar.xz"
  sha256 "57d799d35e92c905e548d00adeb7ed1ead4d6560f084c99e5aae0a87b4eb09e4"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "7257847ee8ade80d3bc94ad34643e160ae0f569efbc5e8e9e3a506fa6192ceed" => :high_sierra
    sha256 "7fa4259be0ab28b2b9ef41294954e7e9f7c6c317129686b899af218414aef11b" => :sierra
    sha256 "121d2792d21c5aea4b8a7c96b75e14de0e42e8d20599c42170dc9c4138066896" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
