class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  revision 11

  stable do
    url "http://files.upscaledb.com/dl/upscaledb-2.2.0.tar.gz"
    mirror "https://dl.bintray.com/homebrew/mirror/upscaledb-2.2.0.tar.gz"
    sha256 "7d0d1ace47847a0f95a9138637fcaaf78b897ef682053e405e2c0865ecfd253e"

    # Remove for > 2.2.2
    # Upstream commit from 12 Feb 2018 "Fix compilation with Boost 1.66 (#110)"
    patch do
      url "https://github.com/cruppstahl/upscaledb/commit/01156f9a8.patch?full_index=1"
      sha256 "e65b9f2b624b7cdad00c3c1444721cadd615688556d8f0bb389d15f5f5f4f430"
    end
  end

  bottle do
    cellar :any
    sha256 "cc371a6e14c48cb0cc2a51e1a3dadcb201c3179789d742e29299e6e8cedec918" => :mojave
    sha256 "28c6eafdac4a4ea8a90698a31298f6debfff2503ffffe6a264a4feb1b85725e7" => :high_sierra
    sha256 "4b4f24812463d787b9f6d53e13318af49283f4a8230baa9ebfeac3083d352b7b" => :sierra
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"
  depends_on "gnutls"
  depends_on :java
  depends_on "openssl"
  depends_on "protobuf"

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.37.tar.gz"
    sha256 "4c12bed4936dc16a20117adfc5bc18889fa73be8b6b083993862628469a1e931"
  end

  def install
    # Fix collision with isset() in <sys/params.h>
    # See https://github.com/Homebrew/homebrew-core/pull/4145
    inreplace "./src/5upscaledb/upscaledb.cc",
      "#  include \"2protobuf/protocol.h\"",
      "#  include \"2protobuf/protocol.h\"\n#define isset(f, b)       (((f) & (b)) == (b))"

    system "./bootstrap.sh" if build.head?

    resource("libuv").stage do
      system "make", "libuv.dylib", "SO_LDFLAGS=-Wl,-install_name,#{libexec}/libuv/lib/libuv.dylib"
      (libexec/"libuv/lib").install "libuv.dylib"
      (libexec/"libuv").install "include"
    end

    ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
    ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
    ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "JDK=#{ENV["JAVA_HOME"]}"
    system "make", "install"

    pkgshare.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           pkgshare/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
