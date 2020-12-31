class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.2/smartmontools-7.2.tar.gz"
  sha256 "5cd98a27e6393168bc6aaea070d9e1cd551b0f898c52f66b2ff2e5d274118cd6"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d6d62defc3e7e500c26180245e0af77d7c61d08c840e1b3ef5daeec6159cdb0d" => :big_sur
    sha256 "4ce621436efd811a6c7bec87ccd57c6a214a4b06154ec67017b101c0eeeb82a3" => :arm64_big_sur
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
