class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170105.tar.xz"
  sha256 "1bd990eeae6fbf599ccddde81caa92770f58623ad9705f875bcfab8254583896"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "0df3f228bc62a277ee353e63aab3d9aa4dd80c4a37b46e98918259b5136681b7" => :sierra
    sha256 "88de8437d4efe25dd20b42a23bc37a1b18ef1d193e66a21b512797050a152755" => :el_capitan
    sha256 "ccf7484e4a6a2af335a6fbaed87c715bc28e7740c0106d17ad3738ea7fa4e94f" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
