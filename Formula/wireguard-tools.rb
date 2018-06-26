class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180625.tar.xz"
  sha256 "d9bedeb22b1f83d48581608a6521fea1d429fbeb8809419d08703ef2ec570020"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "4f2a87ee624c60e9fcaad8c6ac8e824ce53e4cc873642ca0834e03cc61d6cab5" => :high_sierra
    sha256 "7bfac6fecb9548fc1650f0312023de4b1b9812f751aff44de58d5bb925c64432" => :sierra
    sha256 "bb0c1487e2e02892df04339073e90bc86f432cd2d10ec9e5cf5df86042f5b39e" => :el_capitan
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
