class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.1.2.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.1.2.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.1.2.tar.gz"
  sha256 "ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6162623af9da6a56b2f9ae13d63458f6d2e787be3b3ae60c61de2ffe2b1337c" => :el_capitan
    sha256 "d33c5a6b34683d3ec0d63403dd52c593d2f3ba50b16cbcfaac30b0b7b1774fcc" => :yosemite
    sha256 "38151a295b599821506ef117ea2be5190499001268138b144411bc69b19c57e0" => :mavericks
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
