class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.2/smartmontools-7.2.tar.gz"
  sha256 "5cd98a27e6393168bc6aaea070d9e1cd551b0f898c52f66b2ff2e5d274118cd6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "566032c867e1637d14de60f18fb16d7467dd8b52ac0c87a2528cf28fb6edeb5c"
    sha256 arm64_big_sur:  "27f51cc884f31b7ba77754294e701a9a219e06e8070d4e7630310cf1d01c0b1e"
    sha256 monterey:       "e8293cfbe0e6f3c3d3e4ca5cf85b207f61ad8385c880cc398876170131366f33"
    sha256 big_sur:        "9cccb94c747cd2897d458da6a31c2e5c03acfd81faa30c99260fe77ec8c140f0"
    sha256 catalina:       "34aa008976f95dc5568c90c0b99eccdcec7983df3787ac4be1e02284f307c1e7"
    sha256 mojave:         "3f699e7deb392d47d805cf4dad81e53cf67fe0186b00f42e798235fa9079f388"
    sha256 x86_64_linux:   "ab856ea947e68cee8cb149c53571c933802635e00a342501a1be072db56a081b"
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
