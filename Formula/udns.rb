class Udns < Formula
  desc "DNS resolver library"
  homepage "http://www.corpit.ru/mjt/udns.html"
  url "http://www.corpit.ru/mjt/udns/udns-0.4.tar.gz"
  sha256 "115108dc791a2f9e99e150012bcb459d9095da2dd7d80699b584ac0ac3768710"

  bottle do
    cellar :any
    sha256 "8fbcc7a26f6be81abfe4766e9efc012c720938e8ea9dc9f20497cb82b101e659" => :sierra
    sha256 "59939957b47912ebb286426391a4e2c904ecc416e9de18dc8c0a74052ac82ffe" => :el_capitan
    sha256 "342aff7270a4251655eb7cfc538b39db1805cfe965ada5cad1a2819b727d9107" => :yosemite
    sha256 "d6be7acb570845e63c6ac69b8169c4ce1d5a31f5f76f60bad10168a5b13126ff" => :mavericks
  end

  # Build target for dylib. See:
  # http://www.corpit.ru/pipermail/udns/2011q3/000154.html
  patch :DATA

  def install
    system "./configure"
    system "make"
    system "make", "dylib"

    bin.install "dnsget", "rblcheck"
    doc.install "NOTES", "TODO", "ex-rdns.c"
    include.install "udns.h"
    lib.install "libudns.a", "libudns.0.dylib", "libudns.dylib"
    man1.install "dnsget.1", "rblcheck.1"
    man3.install "udns.3"
  end
end

__END__
--- udns-0.4.orig/Makefile.in	2014-01-23 02:45:31.000000000 -0800
+++ udns-0.4/Makefile.in	2014-08-16 20:22:00.000000000 -0700
@@ -42,6 +42,11 @@
 SOLIBV = lib$(NAME).so.$(SOVER)
 SOLIBFL= -L. -l$(NAME)_s
 
+DYLIB   = lib$(NAME).dylib
+DYLIBV = lib$(NAME).$(SOVER).dylib
+
+LIBS   = $(LIB) $(SOLIBV) $(DYLIB)
+
 UTILS   = $(USRCS:.c=)
 UOBJS   = $(USRCS:.c=.o)
 SOUTILS = $(USRCS:.c=_s)
@@ -71,6 +76,14 @@
 .c.o:
 	$(CC) $(CFLAGS) $(CDEFS) -c $<
 
+dylib: $(DYLIB)
+
+$(DYLIBV): $(SOBJS)
+	$(CC) -dynamiclib $(SOBJS) -o $(DYLIBV)
+$(DYLIB): $(DYLIBV)
+	rm -rf $@
+	ln -s $(DYLIBV) $@
+
 shared: $(SOLIBV) $(SOUTILS)
 sharedlib: $(SOLIBV)
