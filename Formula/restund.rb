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
    sha256 arm64_monterey: "6aa0911dbabce9a636833a9bde561cadfcd7b9883e5874aec60adf1f83753581"
    sha256 arm64_big_sur:  "5a0d9ab5db469f98ac2d2431af51359d168aeab91a25a1559ed5cf0c2cfd37f2"
    sha256 monterey:       "0c8481d09c3d2a63e18b0047a5fb9bf650f227b68bddda2686020f2487c35ed6"
    sha256 big_sur:        "93efe2fe78b01fd2f14503cf61f246aff7b150cbde38d07d5ad3e08617bf88c6"
    sha256 catalina:       "261e6c73791b1663476bc26bc35701ff7f480a953f17a6238e53527693d80aef"
    sha256 x86_64_linux:   "074acd4ade9a58189e873e29857f056f6ca3e4f10aad2231a9361dc5a8812032"
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
