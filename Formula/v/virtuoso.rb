class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.16.1/virtuoso-opensource-7.2.16.tar.gz"
  version "7.2.16.1"
  sha256 "7e1d5842840f0b4d967c6c668187959a62414f39698e6ee53793c24594f7bbe7"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "124db9abc6fb578c856559f376a79ef4c24935256fb8c64cd765b87123365f00"
    sha256 cellar: :any,                 arm64_sequoia: "3bcc3cfdf19576a1890aa35ca987172d5e327c37c6e3f15f787e562e46c5aca4"
    sha256 cellar: :any,                 arm64_sonoma:  "e20f3e3d0619edabc99bd4c345bb9f2638541c52621a661b4fa97acfc46c186e"
    sha256 cellar: :any,                 sonoma:        "cb48dfa38804d73c29f23f6a07d022b11bebf62f55cf522f5ae8b7ba93f8ec7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54033ce5c9971b061dc154ce4c6bfeaab5e55add60176420d61e9410e682a855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b252f86f5451180e49ed9329fa33723217618ff199260d8f71e50060cdcc18fe"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "net-tools" => :build
    depends_on "xz" # for liblzma
    depends_on "zlib-ng-compat"
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  # Support openssl 3.6, upstream pr ref, https://github.com/openlink/virtuoso-opensource/pull/1364
  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--without-internal-zlib",
                          *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end

__END__
diff --git a/configure b/configure
index 2953300..a4c8766 100755
--- a/configure
+++ b/configure
@@ -23182,8 +23182,8 @@ main (void)
 	/* LibreSSL defines OPENSSL_VERSION_NUMBER 0x20000000L but uses a compatible API to OpenSSL v1.0.x */
 	#elif OPENSSL_VERSION_NUMBER < 0x1020000fL
 	/* OpenSSL versions 0.9.8e - 1.1.1 are supported */
-       #elif OPENSSL_VERSION_NUMBER < 0x30600000L
-       /* OpenSSL versions 3.0.x - 3.5.x are supported */
+       #elif OPENSSL_VERSION_NUMBER < 0x30700000L
+       /* OpenSSL versions 3.0.x - 3.6.x are supported */
 	#else
 	#error OpenSSL version too new
 	#endif
