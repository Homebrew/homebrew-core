class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  url "http://files.upscaledb.com/dl/upscaledb-2.2.0.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/upscaledb-2.2.0.tar.gz"
  sha256 "7d0d1ace47847a0f95a9138637fcaaf78b897ef682053e405e2c0865ecfd253e"
  revision 5

  bottle do
    cellar :any
    sha256 "41646b2bafdd2d90cc85d82e529c90602554010468a33715a5108e88ca2c191f" => :sierra
    sha256 "732b2d9f23a95649b7fb246d3ca58b864af54c81715564cff73e2ac9dc442073" => :el_capitan
    sha256 "abe0e8f7b2956b769ec6961907921bb690f2f24f73fe6cc9ce46a3bd0b18ef39" => :yosemite
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-java", "Do not build the Java wrapper"
  option "without-protobuf", "Disable access to remote databases"

  deprecated_option "without-remote" => "without-protobuf"

  depends_on "boost"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on :java => :recommended
  depends_on "protobuf" => :recommended

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.37.tar.gz"
    sha256 "4c12bed4936dc16a20117adfc5bc18889fa73be8b6b083993862628469a1e931"
  end

  fails_with :clang do
    build 503
    cause "error: member access into incomplete type 'const std::type_info"
  end

  def install
    # Fix collision with isset() in <sys/params.h>
    # See https://github.com/Homebrew/homebrew-core/pull/4145
    inreplace "./src/5upscaledb/upscaledb.cc",
      "#  include \"2protobuf/protocol.h\"",
      "#  include \"2protobuf/protocol.h\"\n#define isset(f, b)       (((f) & (b)) == (b))"

    system "./bootstrap.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "java"
      args << "JDK=#{ENV["JAVA_HOME"]}"
    else
      args << "--disable-java"
    end

    if build.with? "protobuf"
      resource("libuv").stage do
        system "make", "libuv.dylib", "SO_LDFLAGS=-Wl,-install_name,#{libexec}/libuv/lib/libuv.dylib"
        (libexec/"libuv/lib").install "libuv.dylib"
        (libexec/"libuv").install "include"
      end

      ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
      ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
      ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"
    else
      args << "--disable-remote"
    end

    system "./configure", *args
    system "make", "install"

    pkgshare.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           pkgshare/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
