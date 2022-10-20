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
    sha256 arm64_monterey: "714b496cc03f12a5f65ae28d37d01655cde36b61e19d24949621760ce13ca63d"
    sha256 arm64_big_sur:  "08701e81d42ae8cb3d8f34b3aeb2ecbe62f0c4e8b1f7394636e3b6a78e6d3d3e"
    sha256 monterey:       "4f20eb365588f4726e13efffb6a076904e0fc28984fffed8dfc6b6e1e59da3d3"
    sha256 big_sur:        "a8cb0b9832a28d98ec0695541c48803172f3cd9b66d8058da23976d8c50d28b8"
    sha256 catalina:       "b70f3bce4ea8a18a486d66fb787db5cae0dd62c98acd4f4cd29c8470e951a5d7"
    sha256 x86_64_linux:   "19d0aaa303b7a5019fb886bc4f4091f6e9f54304f864b67a0a73dc2a68f9f86d"
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
