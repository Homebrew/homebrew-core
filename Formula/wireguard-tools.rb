class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171005.tar.xz"
  sha256 "832a3b7cbb510f6986fd0c3a6b2d86bc75fc9f23b6754d8f46bc58ea8e02d608"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "dfa7101a3e1d30d8e4241c06d23f2e442189979758a7df1d6e0cd827d1818e9a" => :high_sierra
    sha256 "1410b395ecc239712c15de77f50cee1b9c19027b9a274408195d8802cd76b570" => :sierra
    sha256 "1bc461241f29a4e929df0cfee7c692807c6a029c9c03f539172314b2b94c2f4a" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
