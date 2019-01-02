class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.0/smartmontools-7.0.tar.gz"
  sha256 "e5e1ac2786bc87fdbd6f92d0ee751b799fbb3e1a09c0a6a379f9eb64b3e8f61c"
  
  bottle do
    sha256 "abc4564708c21e53dfd57d668665e42624bc9e740befe72b6b20bb9039e29ef4" => :mojave
    sha256 "555457dd2f346be5471a4297610e6ed7807e7986ecef5bc9e1087a3a831137f8" => :high_sierra
    sha256 "72708ed71cc68fb23516bc971dc1360ffdd63d20ca191b183f3abc10b976269b" => :sierra
    sha256 "8868a3b550422f2366878f57fd823d69475880cca6a9ffe7c0324b3f78df3730" => :el_capitan
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
