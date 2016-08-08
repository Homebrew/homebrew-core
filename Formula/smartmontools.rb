class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.5/smartmontools-6.5.tar.gz"
  sha256 "89e8bb080130bc6ce148573ba5bb91bfe30236b64b1b5bbca26515d4b5c945bc"

  bottle do
    sha256 "026783b59f7fbea367d6fe845db61b84ad8ecbcea7b39277503bd5548ffc3e4b" => :el_capitan
    sha256 "1f44588d95c27cf0d0a5efc4e1aa892d00bbd3b5d55515db026c0715a6254e70" => :yosemite
    sha256 "87e1640444ba9717a2de2530a9a981705e9752f12a276bfc4dde606ab187e5a7" => :mavericks
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
