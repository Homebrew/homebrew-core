class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.5/smartmontools-6.5.tar.gz"
  sha256 "89e8bb080130bc6ce148573ba5bb91bfe30236b64b1b5bbca26515d4b5c945bc"

  bottle do
    sha256 "7688aed939c30a6fe5390005579be0a9fa1a02ef699ea0990c708d49da2e3462" => :el_capitan
    sha256 "2a653de9d0f41210a9b139f1e70ae561a72fa87727704f944f32dec6356a0fee" => :yosemite
    sha256 "1b74b913314ede83f0597bf6df2b2cb763a1fd03490b07a529892cd36c2720c6" => :mavericks
    sha256 "2b6dadf59bf77a6e711c547405d682b9f0e8af37329fe01d9abdefb3ce41fd7e" => :mountain_lion
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
end
