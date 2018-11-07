class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181018.tar.xz"
  sha256 "af05824211b27cbeeea2b8d6b76be29552c0d80bfe716471215e4e43d259e327"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "32bbbd3cd261f2aface8d8ffc015b3c839007d67f6207abed1c884a0ff8c8d89" => :mojave
    sha256 "3babbc98d0daf06b4c5cbe4f9723f3af8af307a7f007fdb25924b23427ce53e1" => :high_sierra
    sha256 "a26728be426af651aa16fe5292e1c4a64afb0ab6e5f28216fee016a2fdf23bad" => :sierra
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
