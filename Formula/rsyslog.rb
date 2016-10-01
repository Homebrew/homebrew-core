class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "http://www.rsyslog.com"
  url "http://www.rsyslog.com/files/download/rsyslog/rsyslog-7.4.5.tar.gz"
  sha256 "f5e46e9324e366f20368162b4f561cf7a76fecb4aa0570edcaaa49e9f8c2fe70"

  bottle do
    sha256 "edf1c58262540bc3d4409d6a74a5784114ce31e9481064c6a147d299d61fa0b3" => :sierra
    sha256 "fe4b4b7732000b54f6bcc09495920fa27d2f09f31b575d424b9f71b73e32ae6e" => :el_capitan
    sha256 "a3434bafdb1c54eb0ea50fcbabbbf87f241dac07dd68be55c4de344db3daa114" => :yosemite
    sha256 "2f41f4e354de6cb6cd95630ed396a2099753adef10a63e0304fba550097f6237" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libestr"
  depends_on "json-c"

  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-imfile
      --enable-usertools
      --enable-diagtools
      --enable-cached-man-pages
      --disable-uuid
      --disable-libgcrypt
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end

__END__
diff --git i/grammar/parserif.h w/grammar/parserif.h
index aa271ec..03c4db9 100644
--- i/grammar/parserif.h
+++ w/grammar/parserif.h
@@ -3,7 +3,7 @@
 #include "rainerscript.h"
 int cnfSetLexFile(char*);
 int yyparse();
-char *cnfcurrfn;
+extern char *cnfcurrfn;
 void dbgprintf(char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void parser_errmsg(char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void tellLexEndParsing(void);
