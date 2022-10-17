class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  revision 7

  # The sources.openwrt.org directory listing page is 2+ MB in size and
  # growing. This alternative check is less ideal but only a few KB. Versions
  # on the package page can use a format like 1.2.3-4, so we omit any trailing
  # suffix to match the tarball version.
  livecheck do
    url "https://openwrt.org/packages/pkgdata/restund"
    regex(/<dd [^>]*?class="version"[^>]*?>\s*?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 arm64_monterey: "6f5c3d486219054b1ae3720ec2c6f9cd79489b750c2335b8b30d5116ca14eacb"
    sha256 arm64_big_sur:  "94792d7d432f40ac05e64893ed6dbbbfe0b6edec6e4ac56d13f4e3c344b9a839"
    sha256 monterey:       "39baca3b602799ef89ee702322388e5ea6f6dacf77631f75d909d5d5e7d302fc"
    sha256 big_sur:        "ee7b89046aa5e38b393f741d0d64cbec54a06d3063daea0add27d7a73999b987"
    sha256 catalina:       "a9207fed58a8b4e83f745d2e71f3a735247a8309d6ea1241af035e21844430b5"
    sha256 x86_64_linux:   "c345cb90c8092a2d137a1edcd1f5cfc0953d93f8ff8d80802009a088687ba2db"
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
