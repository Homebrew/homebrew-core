class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.tar.gz"
  sha256 "b3bc1a9bd0c19836c9709c318d41c19c11215a07514f49f89b40b9d50ab49325"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "eb830909eed1e6d861968f324fd0701883df44f9d6e191c4e5ebbe2635cc70e7" => :big_sur
    sha256 "2824baa832bb6abe003371d42bab24df5afab5e4076922b2300a90a98526990b" => :arm64_big_sur
    sha256 "d163d32bba98f0a535d179c5d8efd076d12f41bd9232f5c0a41523a4eeaeb500" => :catalina
    sha256 "6343b9c76468bf9ba05e587403b378b1bb93e5108c6505abef4eaaee92257e22" => :mojave
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  # commit ref, https://git.savannah.gnu.org/cgit/gnulib.git/patch/?id=6a76832db224ac5671599ce332717f985a2addc7
  # remove in next release
  patch :DATA

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-debug",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end

__END__
diff --git a/lib/utime.c b/lib/utime.c
index bf7d7c5..3372179 100644
--- a/lib/utime.c
+++ b/lib/utime.c
@@ -261,6 +261,7 @@ utime (const char *name, const struct utimbuf *ts)

 #else

+# include <errno.h>
 # include <sys/stat.h>
 # include "filename.h"
