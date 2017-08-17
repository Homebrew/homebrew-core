class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2"
  sha256 "e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "99a00bb5523cda0abb2a849e7af85cd8739526fea08231687b88724222b1aad7" => :sierra
    sha256 "a2b8cc310fa04d1ce66ffc0de2ea6591503cede49135e4b854e6267c837b5010" => :el_capitan
    sha256 "cdf8a97ab37a46eb605587b50eb7541be53866870241b85f202e92df2a67b8a8" => :yosemite
  end

  option "without-iso14755", "Disable ISO 14775 Shift+Ctrl hotkey"
  option "without-unicode3", "Disable 21-bit Unicode 3 (non-BMP) character support"

  deprecated_option "disable-iso14755" => "without-iso14755"

  depends_on "pkg-config" => :build
  depends_on :x11

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-256-color
      --with-term=rxvt-unicode-256color
      --with-terminfo=/usr/share/terminfo
      --enable-smart-resize
    ]

    args << "--disable-iso14755" if build.without? "iso14755"
    args << "--enable-unicode3" if build.with? "unicode3"

    system "./configure", *args
    system "make", "install"
  end

  test do
    daemon = fork do
      system bin/"urxvtd"
    end
    sleep 2
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end

__END__
diff --git a/configure b/configure
index c756724..5e94907 100755
--- a/configure
+++ b/configure
@@ -7847,8 +7847,8 @@ $as_echo_n "checking for $PERL suitability... " >&6; }

      save_CXXFLAGS="$CXXFLAGS"
      save_LIBS="$LIBS"
-     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts`"
-     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts`"
+     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
      cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */

@@ -7884,8 +7884,8 @@ $as_echo "#define ENABLE_PERL 1" >>confdefs.h

         IF_PERL=
         PERL_O=rxvtperl.o
-        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts`"
-        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts`"
+        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
         PERLPRIVLIBEXP="`$PERL -MConfig -e 'print $Config{privlibexp}'`"
      else
         as_fn_error $? "no, unable to link" "$LINENO" 5
diff --git a/Makefile.in b/Makefile.in
index eee5969..c230930 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -31,6 +31,7 @@ subdirs = src doc

 RECURSIVE_TARGETS = all allbin alldoc tags clean distclean realclean install

+.PHONY: install
 #-------------------------------------------------------------------------

 $(RECURSIVE_TARGETS):
