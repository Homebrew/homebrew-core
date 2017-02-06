class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "http://www.victornils.net/tetris/"
  url "http://www.victornils.net/tetris/vitetris-0.57.tar.gz"
  sha256 "0c9fa6c8b16e2f8968f65e16a87f1bcd39b827d510c6efb0771f0400ab91cdc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d894a98104d29fc3bfcfb59e2796aff6edce184440f8211e3db00d7fe6a70fc" => :el_capitan
    sha256 "5a924675df65dfa62e04be4ab2d9ab4edc44b2095583a87b26a354a83ea62838" => :yosemite
    sha256 "8a15d0e55e5fe09cf569c977882bb33c725de38cb5019b70c0a8dcd66c1fda21" => :mavericks
  end

  # remove a 'strip' option not supported on OS X and root options for
  # 'install'
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--without-xlib"
    system "make", "install"
  end

  test do
    system "#{bin}/tetris", "-hiscore"
  end
end
__END__
--- a/Makefile  2013-10-07 11:57:18.000000000 +0200
+++ b/Makefile  2013-10-07 11:57:29.000000000 +0200
@@ -5,7 +5,7 @@
 # Uncomment to change the default.  (Only used in Unix-like systems.)
 #HISCORE_FILENAME = /var/games/vitetris-hiscores

-INSTALL = install -oroot -groot
+INSTALL = install

 default: build
	@echo Done.
@@ -18,7 +18,7 @@
  cd src; $(MAKE) tetris
	mv -f src/tetris$(EXE) $(PROGNAME)
	@echo stripping symbols to reduce program size:
-	-strip --strip-all $(PROGNAME)
+	-strip $(PROGNAME)

 gameserver: src/netw/gameserver.c
	cd src/netw; $(MAKE) gameserver
