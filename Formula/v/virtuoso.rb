class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.16.1/virtuoso-opensource-7.2.16.tar.gz"
  version "7.2.16.1"
  sha256 "0a70dc17f0e333d73307c9c46e8a7a82df70a410ddfe027a5bf7ba6c9204a928"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b7ac32764f0040dd1056417f422fb02e15f76bbc2cd674fb5f7537a1877b1cf"
    sha256 cellar: :any,                 arm64_sequoia: "2d605053b6e21ce0601876ac33732170b904c04e5f8cb8c197968b35034ac74c"
    sha256 cellar: :any,                 arm64_sonoma:  "f00770df5eb0747dbc02fd9f388acba7f510f9039de36bc1dad6925b6a08e637"
    sha256 cellar: :any,                 sonoma:        "f0ba234fa8b8dc07f98676a6afdd9c18cd3c123dafdbc5c2dc029b386675131e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "013851e403ba961433f12a29be5cbed55368cd4adb7a5bedc27daf4e114d6037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4215aa1feb1db4985d004bd6e0fea39de4010dff0ed0fa4c20e1be2153003a2c"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
    depends_on "xz" # for liblzma
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
