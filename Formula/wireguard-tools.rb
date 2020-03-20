class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200319.tar.xz"
  sha256 "757ed31d4d48d5fd7853bfd9bfa6a3a1b53c24a94fe617439948784a2c0ed987"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "705fe0c1953b0bb8ac9b05e81c0e6e939e49400f142899908aadf999d4c6a4c3" => :catalina
    sha256 "d808dfc50cce70b7f83b6d9d104c540bca3ee6bf2e23527b526fbec136b3dba4" => :mojave
    sha256 "56072dd9dbdc98baa0ba95af88ad5bb6949e9955e4fae35d28995961b43d0451" => :high_sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
