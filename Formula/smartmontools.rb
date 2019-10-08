class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.0/smartmontools-7.0.tar.gz"
  sha256 "e5e1ac2786bc87fdbd6f92d0ee751b799fbb3e1a09c0a6a379f9eb64b3e8f61c"

  bottle do
    sha256 "83418daec52373443bbf5c30ea6a808fbd36ec7ed31e708512e1adf7cc3204a1" => :catalina
    sha256 "eeb9c234d61a85547f6e5f169966f5afd5cb5c31a9f17d758910bdd855d711c4" => :mojave
    sha256 "e77726b986b056d7b58112e965c399861d41a568193c45b9862d7ef5f04ed479" => :high_sierra
    sha256 "74c52c197fbfef3715fe6ed1dc787756cb7185932958005f738c2ce142579a48" => :sierra
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
