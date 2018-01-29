class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.1.3.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.1.3.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.1.3.tar.gz"
  sha256 "55cc554efec5fdaad70de921cd5a5eeb6c29a95524c715f3bbf849235b0800c0"

  bottle do
    sha256 "51924d6d4c11681643fa8c41e3204104bbb356ba32984fa951fe7f0d65081ee6" => :high_sierra
    sha256 "36a448b89f5d70680ea20f7235ff1003143f00734753d19e1d27c23515589671" => :sierra
    sha256 "795d7a7ab57aa31fce67b053f5753e3b0b108f408ef95867fe03562b591d2eda" => :el_capitan
    sha256 "93d8c8ae676a50d71b93b72ac4b2a54b91b3730308d20c303b2c1a0de238b78e" => :yosemite
  end

  depends_on "autoconf" => :build

  def install
    system "./prepare-source"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-rsyncd-conf=#{etc}/rsyncd.conf",
                          "--enable-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"rsync", "--version"
  end
end
