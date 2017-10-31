class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171031.tar.xz"
  sha256 "69b9787b7ae2c681532a7a346e170471f1a651359ed53ff9e6fb8b2c60b9f96a"
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
