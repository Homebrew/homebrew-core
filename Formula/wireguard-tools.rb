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
    sha256 "dedacd9ae2b646a91349fbcf2293858a17dcec4e4687037c42e50eeb9152ce25" => :high_sierra
    sha256 "f306020d71eccd4404e52af1f150eaee55472b5fca3a500a4550986ae5ce3c09" => :sierra
    sha256 "cbe12ce9c1ef1cdc7be65edae85ab23e2093481b086a9a06d8c8f3e9d5e3e604" => :el_capitan
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
