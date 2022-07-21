class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  revision 3

  # The sources.openwrt.org directory listing page is 2+ MB in size and
  # growing. This alternative check is less ideal but only a few KB. Versions
  # on the package page can use a format like 1.2.3-4, so we omit any trailing
  # suffix to match the tarball version.
  livecheck do
    url "https://openwrt.org/packages/pkgdata/restund"
    regex(/<dd [^>]*?class="version"[^>]*?>\s*?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 arm64_monterey: "85bc704bc8c9dbcb8d639da5e88396a2b33a7c05498da8c0fd7a41d9abe87148"
    sha256 arm64_big_sur:  "18839968d135c3ec784b9afe2c7de51519aace1c7a4afb5ea814a1c3f68f02a9"
    sha256 monterey:       "7f3a3b35e8949a23b3013354b54a9943c02d04ace99398707222813095e91b8b"
    sha256 big_sur:        "7d80a6fbc29a971b6f4b0e7407f316aa4ba07d6ac3451f67734d42b1fc632925"
    sha256 catalina:       "5983efae04ea29414da9695d9fe28f9e98697e47c200db55f180bcd56afc0726"
    sha256 x86_64_linux:   "983eb96c587eb079ea0ca3f43c46c57af85f409b8c11abc84e7405ed4e51c15a"
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
