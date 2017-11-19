class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.30.3.tar.gz"
  sha256 "f63c29a07ed7c17d8159ffe947d95d432147d7d6fad5d04b6fb75f341de121e6"

  bottle do
    sha256 "52ee38a9a11caa9698f9d370c01aa5838cc3bacf6a88464d0d5eb93083390cf7" => :high_sierra
    sha256 "775c57ada68a6fe3b3f693e6bf43ec7767b2f800a9c7d4b3bf49bffe9fb1efa6" => :sierra
    sha256 "5eb10500804ccc5a303342141d12e7bb0533d47b637910425f4a3401aef9765c" => :el_capitan
    sha256 "1d4ef021b9c46e67201f36bce3dc40a214c463ecc51bb5d22090a9ee11cd17ce" => :yosemite
    sha256 "c39f691f2a2e5d01a0490f1772465545959ac4f7836fd2873aec4eac7a6e8ac4" => :mavericks
  end

  # Fix missing sys header include for caddr_t on Mac OS
  # Fix omission of creating bin directory by custom Makefile
  # Upstream author is aware of this issue:
  # https://github.com/Homebrew/homebrew/pull/16817
  patch :DATA

  def install
    system "make", "-f", "Makefile_solaris_gcc",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "LIBDIR=#{lib}/yaze",
                   "install"
  end

  test do
    (testpath/"cpm").mkpath
    assert_match "yazerc", shell_output("#{bin}/yaze -v", 1)
  end
end

__END__
diff --git a/Makefile_solaris_gcc b/Makefile_solaris_gcc
index 9e469a3..b25d007 100644
--- a/Makefile_solaris_gcc
+++ b/Makefile_solaris_gcc
@@ -140,11 +140,14 @@ simz80.c:	simz80.pl
		perl -w simz80.pl >simz80.c
		chmod a-w simz80.c

+cdm.o:		CFLAGS+=-include sys/types.h
+
 cdm:		cdm.o
		$(CC) $(CFLAGS) cdm.o $(LIBS) -o $@

 install:	all
		rm -rf $(LIBDIR)
+		mkdir -p $(BINDIR)
		mkdir -p $(LIBDIR)
		mkdir -p $(MANDIR)
		$(INSTALL) -s -c -m 755 yaze_bin $(BINDIR)
