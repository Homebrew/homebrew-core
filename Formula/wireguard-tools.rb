class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170115.tar.xz"
  sha256 "7e5f9f4699a2d4ace90d0df5d81bf0f67205ee08c45b95e0acc379bedef5ffe8"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1f1783c30f004bba4b95bd20e6e3503dc9e9ac7ff019e763502e70d2f9c90b83" => :sierra
    sha256 "87ae9dd2f1b9ba941686d7f86408507b1db0f7823c48096cd9d8354dcc8672d0" => :el_capitan
    sha256 "ef777ce37f2401907ad460491ff90f62c9d68e5e1a8b657f2420a294f44ba4c8" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
