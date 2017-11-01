class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171101.tar.xz"
  sha256 "096b6482a65e566c7bf8c059f5ee6aadb2de565b04b6d810c685f1c377540325"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "3ec4fee8dfd4fb64fb639b5414f1afc310f621cce12fb4d7abfe0419198db2fa" => :high_sierra
    sha256 "0cf3672c3ed1200e64f054a90154f8ac3506725fd73ad441e94277afc42c8a6f" => :sierra
    sha256 "f59eb9a47e33aa6440c7d35fc05c8c00218e5fb65b8a1dd9bf4de715c16784c5" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
