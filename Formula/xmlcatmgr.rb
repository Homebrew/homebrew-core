class Xmlcatmgr < Formula
  desc "Manipulate SGML and XML catalogs"
  homepage "http://xmlcatmgr.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmlcatmgr/xmlcatmgr/2.2/xmlcatmgr-2.2.tar.gz"
  sha256 "ea1142b6aef40fbd624fc3e2130cf10cf081b5fa88e5229c92b8f515779d6fdc"

  bottle do
    sha256 "ed6376a26e59f66eccad7e0db6e0d111c8d93697fbee1e748e8c18e53035b4f2" => :sierra
    sha256 "b55ae55a25d8ddc6ed88b2c7cb0c5aa77588ecd668684a592632a1addd5de22e" => :el_capitan
    sha256 "4515f7fa360ed92348a6325f26645609110f18eb74111b1bd9d2717ee7600f2f" => :yosemite
    sha256 "3e09fe17a25bca20447863f19093209824871f2bb3635a0ab1fc9dcbb7d94967" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
