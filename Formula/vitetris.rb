class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "https://www.victornils.net/tetris/"
  url "https://www.victornils.net/tetris/vitetris-0.57.tar.gz"
  sha256 "0c9fa6c8b16e2f8968f65e16a87f1bcd39b827d510c6efb0771f0400ab91cdc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "57a4c3d266930344ac69130d2dc5075c25783d0446712ff983ce1b42c69b4a4b" => :mojave
    sha256 "1a01bb4e1ac4a04e4cd139683a0593c3ad2aadca28c8c7ed7b2ca1881400ffac" => :high_sierra
    sha256 "817866938f1d4df2dcbb69166e187ec4a5d2f61cff83d50725f5112e773c5f34" => :sierra
    sha256 "d3d2d0c8a86995742c790418cd4e11bbf46d0ea4efa6b8bd5f372a3df7f9ea2b" => :el_capitan
    sha256 "3ce0392ac4a01daeb72ae626eba038f32d4b3acd0ecb3695f0ec57376e1a4039" => :yosemite
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
