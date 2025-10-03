class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "https://ftp.debian.org/debian/pool/main/u/ucommon/ucommon_7.0.1.orig.tar.gz"
  sha256 "99fd0e2c69f24e4ca93d01a14bc3fc4e40d69576f235f80f7a8ab37c16951f3e"
  license all_of: [
    "LGPL-3.0-or-later",
    "GPL-2.0-or-later" => { with: "mif-exception" },
  ]

  livecheck do
    url "https://ftp.debian.org/debian/pool/main/u/ucommon/"
    regex(/href=.*?ucommon[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "47d6c23a79119bb4b597cb141c4054018cec80e5dabd11b5379a15cd406d96b9"
    sha256 arm64_sequoia:  "8d1eb9d2f6984eb37ce94f421122cdddce8070132ddf9b911dae8ed69accadea"
    sha256 arm64_sonoma:   "aef98eb17b5948c37b54052b5695cbc7de0e3ebfed947973ccf5df6bc99280db"
    sha256 arm64_ventura:  "2f5710346714a1abd916b61ac2f8cdb3935ffb8f25d975e9188b102aa0d2cfc9"
    sha256 arm64_monterey: "38d325d005640c936e08eee001469b019b63be1a604a4cb7ef2def41f2dda2eb"
    sha256 sonoma:         "d9e52557eb8da88b69857f8ada8e310ece430553c7ac5c1b1769fa4b354cc497"
    sha256 ventura:        "7fa74730296e4837ff21ff4a40320d8a5fa0f0f1217bac95875bd59a001fdd44"
    sha256 monterey:       "593ba25333186ce44b5f5c1fadcdc4d1afed3429a7961758128036c5a7f3a115"
    sha256 arm64_linux:    "44f61ccf52f496b65a2225aad7bd15381c4a8f881a6a13ccdc25d76dbadd2948"
    sha256 x86_64_linux:   "3cb9863a696fdced7013b30774bea48fced75770d6e2c7a85d4dda337f1ee271"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"

  on_macos do
    depends_on "gettext"
  end

  # Workaround for macOS 15 SDK adding SO_BINDTODEVICE in sys/socket.h
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--with-sslstack=gnutls", "--with-pkg-config", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ucommon-config", "--libs"

    (testpath/"test.cpp").write <<~CPP
      #include <commoncpp/string.h>
      #include <iostream>

      int main() {
        ucommon::String test_string("Hello, Ucommon!");
        std::cout << test_string << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lucommon"
    system "./test"
  end
end

__END__
diff --git a/corelib/socket.cpp b/corelib/socket.cpp
index 76a52273..04dae257 100644
--- a/corelib/socket.cpp
+++ b/corelib/socket.cpp
@@ -3023,7 +3023,7 @@ int Socket::bindto(socket_t so, const char *host, const char *svc, int protocol)
     if(host && !strcmp(host, "*"))
         host = NULL;
 
-#if defined(SO_BINDTODEVICE) && !defined(__QNX__)
+#if defined(SO_BINDTODEVICE) && !defined(__QNX__) && !defined(__APPLE__)
     if(host && !strchr(host, '.') && !strchr(host, ':')) {
         struct ifreq ifr;
         memset(&ifr, 0, sizeof(ifr));
