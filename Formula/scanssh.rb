class Scanssh < Formula
  desc "Scan for SSH and open proxies"
  homepage "https://www.monkey.org/~provos/scanssh/"
  url "https://www.monkey.org/~provos/scanssh-2.1.tar.gz"
  sha256 "057eec87edafbbe5bc22960cbac53e3ada0222400d649a5e2f22cc8981f5b035"

  depends_on "libevent" => :build
  depends_on "libdnet" => :build

  patch :p0, :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-libdnet=#{Formula["libdnet"].opt_prefix}/",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/scanssh", "-V"
  end
end

__END__
--- configure	2005-03-05 19:21:31.000000000 +0000
+++ /private/tmp/scanssh-20170810-13773-8ohthr/scanssh-2.1/.brew_home/configure.scanssh	2017-08-10 13:06:51.000000000 +0100
@@ -2795,6 +2795,11 @@
         if cd $withval; then withval=`pwd`; cd $owd; fi
         EVENTINC="-I$withval"
         EVENTLIB="-L$withval -levent"
+     elif test -f $withval/include/event.h -a -f $withval/lib/libevent.a; then
+        owd=`pwd`
+        if cd $withval; then withval=`pwd`; cd $owd; fi
+        EVENTINC="-I$withval"
+        EVENTLIB="-L$withval -levent"
      else
         { { echo "$as_me:2799: error: event.h or libevent.a not found in $withval" >&5
 echo "$as_me: error: event.h or libevent.a not found in $withval" >&2;}
