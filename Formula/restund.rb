class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  revision 2

  livecheck do
    url "https://sources.openwrt.org/"
    regex(/href=.*?restund[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "121db12a30c4d647cfab3ca8971ffdd1b9e36983b8ab7a9b36fe28e9114cd9f1"
    sha256 arm64_big_sur:  "0cf1f41bae82bd89ca31660484f86bcd155e4b37376e0bab44f1c03bc11f6035"
    sha256 monterey:       "5545a66698ca89ecbe93d701f24f740a899ccc48b8137e24457e30b841bda6a0"
    sha256 big_sur:        "b0f0b4a0bf6530e42eae54badd1e62956233e73f307c71e122c33e58f2fc137e"
    sha256 catalina:       "bce6bfeb4304fd4107eba5106d19bf3cf37fbbcd0c25f44560ac5ab5ad736643"
    sha256 x86_64_linux:   "e3d49c5379342631beb4b367583ba82ea405515d018c0cff1db97bf1b5cfb72c"
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
