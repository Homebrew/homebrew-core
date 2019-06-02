class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190601.tar.xz"
  sha256 "7528461824a0174bd7d4f15e68d8f0ce9a8ea318411502b80759438e8ef65568"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "12270a702d011517d2d7cad123b5be3a79f969f3b26fa3b50eb41aca8e5dee5d" => :mojave
    sha256 "074c48663bbd9b2c27a970389812cab4579aafb2abb9ddcfc868ffdd0e0970be" => :high_sierra
    sha256 "f1de72a66f9049437b1ac956b1695623f2712fa2cfd54946ce19496ddcc0e959" => :sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
