class Rogue < Formula
  desc "Dungeon crawling video game"
  # Historical homepage: https://web.archive.org/web/20160604020207/rogue.rogueforge.net/
  homepage "https://sourceforge.net/projects/roguelike/"
  url "https://src.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
  version "5.4.4"
  sha256 "7d37a61fc098bda0e6fac30799da347294067e8e079e4b40d6c781468e08e8a1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d1837a65589cfc24e6ff05f585e4cb9991e06cecbccf119688cc95fd60dd1dc9" => :catalina
    sha256 "fe9135c4e75abf4298cc231e0372ff8088fa57450fbd8c718e8a0fb8ac3ed723" => :mojave
    sha256 "a65be75ef53988084ebe86a523e5fbda23205a2e5843b9015bfda312ade8e6f2" => :high_sierra
  end

  def install
    ENV.ncurses_define

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace "config.h", "rogue.scr", "#{var}/rogue/rogue.scr"

    inreplace "Makefile" do |s|
      # Take out weird man install script and DIY below
      s.gsub! "-if test -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(man6dir)/$(PROGRAM).6 ; fi", ""
      s.gsub! "-if test ! -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(mandir)/$(PROGRAM).6 ; fi", ""
    end

    system "make", "install"
    man6.install gzip("rogue.6")
    libexec.mkpath
    (var/"rogue").mkpath
  end

  test do
    system "#{bin}/rogue", "-s"
  end
end
