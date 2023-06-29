class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.18.1/thrift-0.18.1.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.18.1/thrift-0.18.1.tar.gz"
    sha256 "04c6f10e5d788ca78e13ee2ef0d2152c7b070c0af55483d6b942e29cff296726"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85600b3e4a39ec5fa0ce1da14f6ed9a13cd92ae6fe16ae487dbcd73321325cb1"
    sha256 cellar: :any,                 arm64_monterey: "97307b5ca8dde1d7a37f2cbeca2f067951c3dada69b13ffc5bf22eb4fc815561"
    sha256 cellar: :any,                 arm64_big_sur:  "77f4dbb7a8de0b329701047cd8832d33c58675c1404a7cf1d84ad39e7404ef0e"
    sha256 cellar: :any,                 ventura:        "6c4cca5e0fade907187b6190bab02b6e8ad726754334c7c6263778005dd4141e"
    sha256 cellar: :any,                 monterey:       "3ee7123fb389d20f50fc60d61b9eeca3a1fb05b63266a3d7c66899a30a22ed50"
    sha256 cellar: :any,                 big_sur:        "dc5dd5406468028339f76642481073fbc56ff852e6cdedddef5912daa315bc76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9df34f68397a255916889927e8c77ad60377b1d8649c0dcd0ec53202a25242a"
  end

  head do
    url "https://github.com/apache/thrift.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "bison" => :build
  depends_on "boost" => [:build, :test]
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --without-java
      --without-kotlin
      --without-python
      --without-py3
      --without-ruby
      --without-haxe
      --without-netstd
      --without-perl
      --without-php
      --without-php_extension
      --without-dart
      --without-erlang
      --without-go
      --without-d
      --without-nodejs
      --without-nodets
      --without-lua
      --without-rs
      --without-swift
    ]

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = buildpath

    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.thrift").write <<~EOS
      service MultiplicationService {
        i32 multiply(1:i32 x, 2:i32 y),
      }
    EOS

    system "#{bin}/thrift", "-r", "--gen", "cpp", "test.thrift"

    system ENV.cxx, "-std=c++11", "gen-cpp/MultiplicationService.cpp",
      "gen-cpp/MultiplicationService_server.skeleton.cpp",
      "-I#{include}/include",
      "-L#{lib}", "-lthrift"
  end
end
