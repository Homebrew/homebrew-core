class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.1.3.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.1.3.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.1.3.tar.gz"
  sha256 "55cc554efec5fdaad70de921cd5a5eeb6c29a95524c715f3bbf849235b0800c0"

  bottle do
    sha256 "1b023b82b13c5afaaf0ef980465b660c7a3972f842b2a73cbb2fe541d0a7d210" => :high_sierra
    sha256 "e33f81c60ee6abe14cec39696d5d7c0d1384fac41fe5d2ca0b8b65db006d637b" => :sierra
    sha256 "b25d1d738aeb8c9964ade0962f84f47e8818be89bb476d683be5e4fbd7770c64" => :el_capitan
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
