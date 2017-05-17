class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170517.tar.xz"
  sha256 "7303e973654a3585039f4789e89a562f807f0d6010c7787b9b69ca72aa7a6908"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1a8b6ebc35552a73ca9a37d1ea4925225096032a5f78b9fdf3c6a0d68292eaf8" => :sierra
    sha256 "5420272205261aeb628de6a65c726ebc7d90f0ac02ce6749f89c8a1bdcff2ff4" => :el_capitan
    sha256 "c5ce7a92236f33de80dd08d31d436492a54251429aab9eb3d449cecc10552bfb" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
