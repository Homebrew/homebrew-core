class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.1.2.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.1.2.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.1.2.tar.gz"
  sha256 "ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2"

  bottle do
    sha256 "36a448b89f5d70680ea20f7235ff1003143f00734753d19e1d27c23515589671" => :sierra
    sha256 "795d7a7ab57aa31fce67b053f5753e3b0b108f408ef95867fe03562b591d2eda" => :el_capitan
    sha256 "93d8c8ae676a50d71b93b72ac4b2a54b91b3730308d20c303b2c1a0de238b78e" => :yosemite
  end

  depends_on "autoconf" => :build

  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.1.2.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.1.2.tar.gz"
    mirror "https://launchpad.net/rsync/main/3.1.2/+download/rsync-patches-3.1.2.tar.gz"
    sha256 "edeebe9f2532ae291ce43fb86c9d7aaf80ba4edfdad25dce6d42dc33286b2326"
    apply "patches/fileflags.diff",
          "patches/crtimes.diff",
          "patches/hfs-compression.diff"
  end

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
