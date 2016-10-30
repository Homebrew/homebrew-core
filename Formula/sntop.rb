class Sntop < Formula
  desc "Curses-based utility that polls hosts to determine connectivity"
  homepage "http://sntop.sourceforge.net/"
  url "http://distcache.freebsd.org/ports-distfiles/sntop-1.4.3.tar.gz"
  sha256 "943a5af1905c3ae7ead064e531cde6e9b3dc82598bbda26ed4a43788d81d6d89"

  bottle do
    cellar :any_skip_relocation
    sha256 "84eb48e821906cb71abf1f8d6e6b5bfe42b243bdad6715dbcffefc8e80462e32" => :sierra
    sha256 "5d878e67c779335a8eb02815ba54b77942e14f2ff3a8d21bf62cbec82ed82be1" => :el_capitan
    sha256 "6249ada241e03cff9f860c18125016e646d88c8f97a417acad9c81dd95a8c708" => :yosemite
    sha256 "3c7b79334ee07ec52ad014ccdcc42dca8b923f2486793b751eee3b239be07705" => :mavericks
  end

  depends_on "fping"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    etc.mkpath
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    sntop uses fping by default and fping can only be run by root by default.
    You can run `sudo sntop` (or `sntop -p` which uses standard ping).
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
