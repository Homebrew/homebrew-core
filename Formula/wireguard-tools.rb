class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170726.tar.xz"
  sha256 "db91452b6b5ec28049721a520fe4fd0683825bad45b7383d12d7b819668201db"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "b4f43a0049891bfdfb645740c61a16f6588f79b82a500af3fd2780379748c711" => :sierra
    sha256 "b5d2944fa8be1bf4b7aee158ee03b7c0146b092972256d6d147f1518c510e6ac" => :el_capitan
    sha256 "befab39327935563561e5e8b4f5e4614dc8ee428aaf963d26f99b6c4954c955e" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
