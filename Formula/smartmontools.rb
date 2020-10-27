class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.1/smartmontools-7.1.tar.gz"
  sha256 "3f734d2c99deb1e4af62b25d944c6252de70ca64d766c4c7294545a2e659b846"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "cc34524c76ff39abb4afc6794fe404e257cf04816c1d2c33f8edd158e5677239" => :catalina
    sha256 "cce7b82f81c999afcd180dd7fb1ef471bfb24d9934dc3ad326d86db7ea478f2c" => :mojave
    sha256 "77b4722b7ffc997a2b5482518f291640fcabc45468ae5fca12520943869263be" => :high_sierra
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
