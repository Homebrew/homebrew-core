class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.4/tin-2.4.2.tar.gz"
  sha256 "93839d2fd82175281c57f1a408dfb56bf716cf4f0b259b3e03462dca32391d51"

  bottle do
    sha256 "d4047844c177a458fc5ecef53823dd6e2ff70acc6d36c76cddf72c7e817f0d03" => :high_sierra
    sha256 "0007b4384c05e500560ae3ad0fb4f46a78ee1b93ff97c2e33404b0c2116cfc77" => :sierra
    sha256 "ce603fb1e70d75727c644da65e88b23c24fbc5bf9852d94df0e6e3bff30652af" => :el_capitan
    sha256 "e4e00f28bd2a58040dd0d35379bf756eecdfb6887c8a046c43d187d5180ac0ef" => :yosemite
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
