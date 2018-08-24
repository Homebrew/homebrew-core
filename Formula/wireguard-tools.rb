class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180809.tar.xz"
  sha256 "3e351c42d22de427713f1da06d21189c5896a694a66cf19233a7c33295676f19"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "d27dc906309373106e2d35fe0e6524f0f91fa9734013635a1c76b450d2bbd8b3" => :mojave
    sha256 "ba73ad87b744cc4283ee2aa409336b1dda2cac1922a79578d1144d077236a8f3" => :high_sierra
    sha256 "52f535902df6a3f7c926e5fe7a7614c75a1a97777fbcbaa9ec8b68f23bf5647f" => :sierra
    sha256 "631fa59397ceddfa898bdf18b76107f38908fe3aa6fd808c2d560e25269bc6b9" => :el_capitan
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
