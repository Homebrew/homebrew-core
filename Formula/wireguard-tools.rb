class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181007.tar.xz"
  sha256 "d26e0d1216594871b5947e76d64c2fa50e9b34b68cdcfa3fdad588cbb314af89"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "0c0499f7834ee1d891c0059c0fd4fb89de2ab85d44ebcb8a7f041e7bcd98b08c" => :mojave
    sha256 "5c4fe1e5bbe62c807c56f222971d08475b3b4cd5126370329ba1ec6138baaeda" => :high_sierra
    sha256 "9c9f580022d380ca7aa519838b5509087db7394d8a11782c707581d53c0120db" => :sierra
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
