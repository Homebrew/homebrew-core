class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  url "http://files.upscaledb.com/dl/upscaledb-2.2.0.tar.gz"
  sha256 "7d0d1ace47847a0f95a9138637fcaaf78b897ef682053e405e2c0865ecfd253e"

  bottle do
    cellar :any
    sha256 "e895c09364de3873adaf0e9f83be26e15ff3794cf90a1f51a3cc8a154892bfa1" => :el_capitan
    sha256 "8cb5f00f0685408c0d17044c4073357c90b0f458ca263e43e71b7a3d95938a24" => :yosemite
    sha256 "f6da669995d949ae8f20200c09325296832ba1993ae2712f7111951a3017f740" => :mavericks
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-java", "Do not build the Java wrapper"
  option "without-remote", "Disable access to remote databases"

  depends_on "boost"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on :java => :recommended
  depends_on "protobuf" if build.with? "remote"

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.36.tar.gz"
    sha256 "421087044cab642f038c190f180d96d6a1157be89adb4630881930495b8f5228"
  end

  fails_with :clang do
    build 503
    cause "error: member access into incomplete type 'const std::type_info"
  end
  fails_with :llvm do
    build 2336
    cause "error: forward declaration of 'const struct std::type_info'"
  end

  def install
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

    if build.with? "remote"
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
