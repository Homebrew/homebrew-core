class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tcl8.6.6-src.tar.gz"
  mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.6-src.tar.gz"
  version "8.6.6"
  sha256 "a265409781e4b3edcc4ef822533071b34c3dc6790b893963809b9fe221befe07"
  revision 1

  bottle do
    sha256 "4ab93b570b42e79fef6f154e4ffc1be7faf792eaedda3ea995edfe846670efac" => :sierra
    sha256 "7749a9306ad76868443c254d2191d7809b89fd536d3c723095a60879bff01abd" => :el_capitan
    sha256 "dde73a5b17f8dc6acfd974f88605a97e9b50ca12b1af9071825c67c69b33cf7c" => :yosemite
  end

  keg_only :provided_by_osx,
    "Tk installs some X11 headers and OS X provides an (older) Tcl/Tk."

  deprecated_option "enable-threads" => "with-threads"

  option "with-threads", "Build with multithreading support"
  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"
  option "with-x11", "Build X11-based Tk instead of Aqua-based Tk"

  depends_on :x11 => :optional
  depends_on "pkg-config" => :build if build.with? "x11"

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tk8.6.6-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.6-src.tar.gz"
    version "8.6.6"
    sha256 "d62c371a71b4744ed830e3c21d27968c31dba74dd2c45f36b9b071e6d88eb19d"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.18/tcllib-1.18.tar.gz"
    sha256 "72667ecbbd41af740157ee346db77734d1245b41dffc13ac80ca678dd3ccb515"
  end

  # sqlite won't compile on Tiger due to missing function;
  # patch submitted upstream: http://thread.gmane.org/gmane.comp.db.sqlite.general/83257
  patch :DATA if MacOS.version < :leopard

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-threads" if build.with? "threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh8.6", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        args = ["--prefix=#{prefix}", "--mandir=#{man}", "--with-tcl=#{lib}"]
        args << "--enable-threads" if build.with? "threads"
        args << "--enable-64bit" if MacOS.prefer_64_bit?

        if build.with? "x11"
          args << "--with-x"
        else
          args << "--enable-aqua=yes"
          args << "--without-x"
        end

        cd "unix" do
          system "./configure", *args
          system "make", "TK_LIBRARY=#{lib}"
          # system "make", "test"  # for maintainers
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish8.6", bin/"wish"
        end
      end
    end

    if build.with? "tcllib"
      resource("tcllib").stage do
        system "./configure", "--prefix=#{prefix}",
                              "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end

__END__
diff --git a/pkgs/sqlite3.8.8.3/generic/sqlite3.c b/pkgs/sqlite3.8.8.3/generic/sqlite3.c
index 7d513fa..b1d968a 100644
--- a/pkgs/sqlite3.8.8.3/generic/sqlite3.c
+++ b/pkgs/sqlite3.8.8.3/generic/sqlite3.c
@@ -16805,6 +16805,7 @@ SQLITE_PRIVATE void sqlite3MemSetDefault(void){
 #include <sys/sysctl.h>
 #include <malloc/malloc.h>
 #include <libkern/OSAtomic.h>
+
 static malloc_zone_t* _sqliteZone_;
 #define SQLITE_MALLOC(x) malloc_zone_malloc(_sqliteZone_, (x))
 #define SQLITE_FREE(x) malloc_zone_free(_sqliteZone_, (x));
@@ -16812,6 +16813,29 @@ static malloc_zone_t* _sqliteZone_;
 #define SQLITE_MALLOCSIZE(x) \
         (_sqliteZone_ ? _sqliteZone_->size(_sqliteZone_,x) : malloc_size(x))
 
+/*
+** If compiling for Mac OS X 10.4, the OSAtomicCompareAndSwapPtrBarrier
+** function will not be available, but individual 32-bit and 64-bit
+** versions will.
+*/
+
+#ifdef __MAC_OS_X_MIN_REQUIRED
+# include <AvailabilityMacros.h>
+#elif defined(__IPHONE_OS_MIN_REQUIRED)
+# include <Availability.h>
+#endif
+
+typedef int fc_atomic_int_t;
+#if (MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4 || __IPHONE_VERSION_MIN_REQUIRED >= 20100)
+# define fc_atomic_ptr_cmpexch(O,N,P) OSAtomicCompareAndSwapPtrBarrier ((void *) (O), (void *) (N), (void **) (P))
+#else
+# if __ppc64__ || __x86_64__
+#  define fc_atomic_ptr_cmpexch(O,N,P) OSAtomicCompareAndSwap64Barrier ((int64_t) (O), (int64_t) (N), (int64_t*) (P))
+# else
+#  define fc_atomic_ptr_cmpexch(O,N,P) OSAtomicCompareAndSwap32Barrier ((int32_t) (O), (int32_t) (N), (int32_t*) (P))
+# endif
+#endif
+
 #else /* if not __APPLE__ */
 
 /*
@@ -16998,7 +17022,7 @@ static int sqlite3MemInit(void *NotUsed){
     malloc_zone_t* newzone = malloc_create_zone(4096, 0);
     malloc_set_zone_name(newzone, "Sqlite_Heap");
     do{
-      success = OSAtomicCompareAndSwapPtrBarrier(NULL, newzone, 
+      success = fc_atomic_ptr_cmpexch(NULL, newzone,
                                  (void * volatile *)&_sqliteZone_);
     }while(!_sqliteZone_);
     if( !success ){
