class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.4/tin-2.4.2.tar.gz"
  sha256 "93839d2fd82175281c57f1a408dfb56bf716cf4f0b259b3e03462dca32391d51"

  bottle do
    sha256 "e9b2afbdc37d3a349dd8341e7ceb1191466b28fc9e636ef15308d6c5b7075ba4" => :high_sierra
    sha256 "7964b2236af4b8c195271238b66a054293d94ce5bda3f10746f0b8e1d06c9f91" => :sierra
    sha256 "572e6d081547a2b9fc46afffa994f52ffd5696be884e18858c8c03131a72faec" => :el_capitan
  end

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
