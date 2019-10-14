class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20191012.tar.xz"
  sha256 "93573193c9c1c22fde31eb1729ad428ca39da77a603a3d81561a9816ccecfa8e"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "65e63b009640b8f72f526602d426492d7e9e76d4608b4d2dec2ccd9e8ee341ab" => :catalina
    sha256 "c165ed343667bd331ba792ce5fb869c31196940ab97f61527413d5ae2b8849f8" => :mojave
    sha256 "4c20b4c5c986e7d1972f12be22f2051d4f817cfd5f0e789a923de1497952e9cc" => :high_sierra
    sha256 "135dd7d027656bd2f8e2d64f7f5c03df708d4aad2351f2cc6597a2bbcfbc070d" => :sierra
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
