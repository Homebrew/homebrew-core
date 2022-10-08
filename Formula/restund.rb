class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  revision 6

  # The sources.openwrt.org directory listing page is 2+ MB in size and
  # growing. This alternative check is less ideal but only a few KB. Versions
  # on the package page can use a format like 1.2.3-4, so we omit any trailing
  # suffix to match the tarball version.
  livecheck do
    url "https://openwrt.org/packages/pkgdata/restund"
    regex(/<dd [^>]*?class="version"[^>]*?>\s*?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 arm64_monterey: "fac7150f5870a83898ef4375952d6fd5a49222e28b786fe11df395d378e894b9"
    sha256 arm64_big_sur:  "d1542845633a2aa8c763751de4a8e620e61b7542935aeeacd37869f6921246ef"
    sha256 monterey:       "babbac1ef3298b8d65c44149f1d0d130ffee1933b03233db8c21f02ca06b649a"
    sha256 big_sur:        "74474e34ca2dfb5013fad6552c1cfdd142934ca1b075773a46df1c146b093f18"
    sha256 catalina:       "eb582cf9fb175e8f0b603da2fd3a61ecd4ac4e589ede03baf3336fdf3067d661"
    sha256 x86_64_linux:   "0736e1dec11c1a7ede13e81496439ca0b45263ac1a83cd2b9b7d112222ca641d"
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
