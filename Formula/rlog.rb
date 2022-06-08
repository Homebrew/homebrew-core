class Rlog < Formula
  desc "Flexible message logging facility for C++"
  homepage "https://github.com/vgough/rlog"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rlog/rlog-1.4.tar.gz"
  sha256 "a938eeedeb4d56f1343dc5561bc09ae70b24e8f70d07a6f8d4b6eed32e783f79"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey:  "cd251b465737a2c5d9cd4aaeff4a625d1c48d50778bc8c93ad4e683b04ca82c5"
    sha256 cellar: :any,                 arm64_big_sur:   "543009caf7c0dede6026949c6ccd5569183cabd78414542efcc3a43ae1a25cfa"
    sha256 cellar: :any,                 monterey:        "239d339429358a6e685e6793eee4c528008eeeb40731b4c6cfa44f2ca571adf4"
    sha256 cellar: :any,                 big_sur:         "4d6953945346cc4b3548510ebad0bd441246101be7c7a8c633b98c6e94c9fdaa"
    sha256 cellar: :any,                 catalina:        "42b1e5a687f78df9121a75bc0b1194a534f31b8476521592879ea5fe381d634f"
    sha256 cellar: :any,                 mojave:          "4ceb686581d1dad40fbbd4dec3d26205f56d9c25179ca4880158a06c2895f197"
    sha256 cellar: :any,                 high_sierra:     "5d85e13db4c6dd2892d136a96af4ac46d72254a39b842559ac9a4f9f3841af3e"
    sha256 cellar: :any,                 sierra:          "51f6586bcfa2235a19b311189ca63431c596c689c7b014850e4a0cef2275074e"
    sha256 cellar: :any,                 el_capitan:      "c95d8998639fd75131f923191eaa857bc3ff8f33ee64ca3b5d459ac1979e6fa2"
    sha256 cellar: :any,                 x86_64_yosemite: "44f3b8ee89802fb13674e3b60e873045a459bf13513b84f3f7b94c8a4444b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:    "a272cb9d709fffe4c798d278a49455a5a05a0e4c408e158609b168718b9c5e1b"
  end

  patch :DATA

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

# This patch solves an OSX build issue, should not be necessary for the next release according to
# https://code.google.com/p/rlog/issues/detail?id=7
__END__
--- orig/rlog/common.h.in	2008-06-14 20:10:13.000000000 -0700
+++ new/rlog/common.h.in	2009-05-18 16:05:04.000000000 -0700
@@ -52,7 +52,12 @@

 # define PRINTF(FMT,X) __attribute__ (( __format__ ( __printf__, FMT, X)))
 # define HAVE_PRINTF_ATTR 1
+
+#ifdef __APPLE__
+# define RLOG_SECTION __attribute__ (( section("__DATA, RLOG_DATA") ))
+#else
 # define RLOG_SECTION __attribute__ (( section("RLOG_DATA") ))
+#endif

 #if __GNUC__ >= 3
 # define expect(foo, bar) __builtin_expect((foo),bar)
