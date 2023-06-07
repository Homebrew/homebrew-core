class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.3/smartmontools-7.3.tar.gz"
  sha256 "a544f8808d0c58cfb0e7424ca1841cb858a974922b035d505d4e4c248be3a22b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "6190562fe7445bde716f75236a35951fb9215fa0712c7dee9aa92d9a89630007"
    sha256 arm64_monterey: "de5a9816fe979e1f6e95727f2b23946e8d6594718b0b0fcb77da6b3b01bd47b3"
    sha256 arm64_big_sur:  "3ae9274990e2845f9d833e267c3443da5d8ef6daedf0293233847710b2116c72"
    sha256 ventura:        "c2fc2398c32def92729b97433cc68ac5e2cef1d81d1142d6e0cb18a43bcdf32c"
    sha256 monterey:       "7df715580bf7adde46c4abac502ee920cd2384be22a279f8da5813db2f974253"
    sha256 big_sur:        "b353b05f39600a28070f9aeb7c4cff62bf250deff02a03ee8aa4ecabb9639925"
    sha256 catalina:       "c79a0e6dc93a4e0416b5724cecb1a36d6f0977ae0143698abad407eb013b15cb"
    sha256 x86_64_linux:   "5702653e6385bc4388d919fcfebe0ee26860627ab3117b117d582fa79f13ae46"
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
                          "--with-attributelog",
                          "--with-nvme-devicescan"
    system "make", "install"
  end

  test do
    system "#{bin}/smartctl", "--version"
    system "#{bin}/smartd", "--version"
  end
end
