class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180802.tar.xz"
  sha256 "cd1da34b377d58df760aadf69ced045081517570586fc2d4eed7f09f5d5a47c6"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "cc85b9598286d5c06cc7af7c8db1b7a8e3e7744dad1c86ba46f4f396a02de3a1" => :high_sierra
    sha256 "46e1e70f4246fb252650e74225400a8d2b9b63dc41c1add57ea01a863c86fb55" => :sierra
    sha256 "d71c3d67bcbfd625d778eed03a4c2e1cad14749da6defe4a6e8a40647b6abedd" => :el_capitan
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
