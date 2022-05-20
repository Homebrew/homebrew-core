class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.3/smartmontools-7.3.tar.gz"
  sha256 "a544f8808d0c58cfb0e7424ca1841cb858a974922b035d505d4e4c248be3a22b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "e6dcb98550cdf4dbf6e175655a81a8413f71e974ad8b73b352492bbe65bf7b67"
    sha256 arm64_big_sur:  "4fffd7dccb8c3668da027dae7ce63dee48bc2af088da5beac7fa6f714ef09d37"
    sha256 monterey:       "3707ed37f1a3636388b7af716ef2e4082eabd70142141834c0168dc19f212967"
    sha256 big_sur:        "b14a14633dc1557f0c619a583ae1ec15b83f5b2c56f6088de063c6a9b5e8181d"
    sha256 catalina:       "ebac716671db6e00439ce86aedc0d62a55324ce0949d2d9b69d9ee5a2298a630"
    sha256 x86_64_linux:   "e3c590b7a88dbfc59e44adcd5fd42f6f959748ee144988329dc49fb3abf64336"
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-savestates",
                          "--with-attributelog"
    system "make", "install"
  end

  test do
    system "#{bin}/smartctl", "--version"
    system "#{bin}/smartd", "--version"
  end
end
