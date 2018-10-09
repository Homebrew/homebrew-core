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
    sha256 "dbf42ba2dd424374f5397dfc87931ab16b495863509250e36c03cf64f02c265d" => :mojave
    sha256 "07e0a9d2a96e006f0d2114f1c03e3110f5d0b5bd9efd48585164ac2d1de4df29" => :high_sierra
    sha256 "a8e398cdbfd7bcb0f200c699d4173df507fbb132322703ab32a474f87090145b" => :sierra
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
