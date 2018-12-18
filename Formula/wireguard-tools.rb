class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181218.tar.xz"
  sha256 "2e9f86acefa49dbfb7fa6f5e10d543f1885a2d5460cd5e102696901107675735"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "8415298ec89c1664e830d0dad4d8bd78e6d98f9a4b39b739aa92cc9fbd038175" => :mojave
    sha256 "b1ee2cdc1cf87b1f82e5a27d86eeaeb2a8c773c0bc4772b88cd148cb043e8fa1" => :high_sierra
    sha256 "fd8b554e644407835690e6e3d7bafd86813f2f4d4b40b165dbb337f9cda310da" => :sierra
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
