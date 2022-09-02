class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  revision 5

  # The sources.openwrt.org directory listing page is 2+ MB in size and
  # growing. This alternative check is less ideal but only a few KB. Versions
  # on the package page can use a format like 1.2.3-4, so we omit any trailing
  # suffix to match the tarball version.
  livecheck do
    url "https://openwrt.org/packages/pkgdata/restund"
    regex(/<dd [^>]*?class="version"[^>]*?>\s*?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 arm64_monterey: "845534753ce16669495a7aaef8df7c1d458aa402f4abd3bd74e9d826850e7901"
    sha256 arm64_big_sur:  "ffbdb424ef3db691cd4007941e76c04458be1018d30b6ae67a95e8ecaa5d03f4"
    sha256 monterey:       "755063e9fbb486a49193e46323a8ca469e5db473dbb4504f483376cb964bb7e5"
    sha256 big_sur:        "026403c40296087af6ce89436f24ddb7276c4b6ecea3d94798976d3164f3be2f"
    sha256 catalina:       "09b09869c6d0556abe26cecc12158e3c96b3e0b9bf1835e5e2a4c703ae1720fa"
    sha256 x86_64_linux:   "5df3cba8c1579a4437adf8d4f4b717717d2c28707ca0f291447ea717560eff51"
  end

  depends_on "libre"

  def install
    # Configuration file is hardcoded
    inreplace "src/main.c", "/etc/restund.conf", "#{etc}/restund.conf"

    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
    system "make", "config", "DESTDIR=#{prefix}",
                              "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    system "#{sbin}/restund", "-h"
  end
end
