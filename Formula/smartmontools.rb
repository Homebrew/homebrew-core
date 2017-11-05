class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.6/smartmontools-6.6.tar.gz"
  sha256 "51f43d0fb064fccaf823bbe68cf0d317d0895ff895aa353b3339a3b316a53054"

  bottle do
    sha256 "c4ad7926a0da73101e7ef83eda23cfd21c808af7f6d19b8d8b8ea4714432895b" => :high_sierra
    sha256 "36d3ef7c8959108c52d0d3e8539c09f40547f73f7b30c295a66e741ff5ec110f" => :sierra
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
