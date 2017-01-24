class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.4/tin-2.4.1.tar.gz"
  sha256 "58e714e130d32258a41ce829c3286c5d4edb9df642ca7a62328b006c1f756478"

  bottle do
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
