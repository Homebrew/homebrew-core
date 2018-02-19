class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180218.tar.xz"
  sha256 "4ac4c4e4ad4dc2cf9dcb831b0cf347567ccea675ca524528cf5a4d9dccb2fe52"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "e2f31efffc7983c154771e78fdd0478cd3cced3b1c2fad138a5e283a077d89ae" => :high_sierra
    sha256 "e94a9ab0234d02b32c36b19b635a8547409a9ca8e2701504487d771494fb4983" => :sierra
    sha256 "b58bec450de2e169d78bac699f41c8b0f90299e0592a317c5b0d6dd0c921ff16" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
