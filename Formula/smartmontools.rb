class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.0/smartmontools-7.0.tar.gz"
  sha256 "e5e1ac2786bc87fdbd6f92d0ee751b799fbb3e1a09c0a6a379f9eb64b3e8f61c"

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
