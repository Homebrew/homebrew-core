class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftpmirror.gnu.org/gnu/wget/wget-1.25.0.tar.gz"
  sha256 "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "95813f55485b527013d3caff66c3c52389947769ba3fa56bea3dd37bd64bc542"
    sha256 arm64_sequoia: "03c53f2362562e8325f486dce8ef0daa2826bf7b35647deab93ca65d9006000c"
    sha256 arm64_sonoma:  "f7e1d373d330de52e9ba82293c31fa1d268dc36bd37bcfda968f527e42e724dc"
    sha256 sonoma:        "2df5a5bfb22520aebb4693e42877a703157b60ebae3dc426becf3a6a2b939a5a"
    sha256 arm64_linux:   "fe5bcfa1f8fc0df487dbb88ca3272867a845a226c907f2a937665dbe6efe0d2b"
    sha256 x86_64_linux:  "ff1f252c29b196108376bce23f6fdb56af9c4416d8ed81c7346b845ee00ec310"
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "openssl@4"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  # OpenSSL 4 removes SSLv3_client_method.
  patch :DATA

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@4"].opt_prefix}",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl",
                          "--without-included-regex"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", File::NULL, "https://google.com"
  end
end

__END__
diff --git a/src/openssl.c b/src/openssl.c
index 7310514..6b748bf 100644
--- a/src/openssl.c
+++ b/src/openssl.c
@@ -226,7 +226,7 @@ ssl_init (void)
       break;
 
     case secure_protocol_sslv3:
-#ifndef OPENSSL_NO_SSL3_METHOD
+#if !defined OPENSSL_NO_SSL3_METHOD && OPENSSL_VERSION_NUMBER < 0x40000000L
       meth = SSLv3_client_method ();
 #endif
       break;
