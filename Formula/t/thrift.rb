class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.20.0/thrift-0.20.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.20.0/thrift-0.20.0.tar.gz"
    sha256 "b5d8311a779470e1502c027f428a1db542f5c051c8e1280ccd2163fa935ff2d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93a5538c94151be23ff7ecb1aa8dcd88738217fc7092f8b6a20d033f99c63206"
    sha256 cellar: :any,                 arm64_ventura:  "41e37eea7e17eb56ac112fcd2c6ef55dad48a162356d5d3059b7cb343e6f2712"
    sha256 cellar: :any,                 arm64_monterey: "c226249f0a56ab2f1bbcd82034309db8fa93c26e6dfe34b6fce4c146d7ba47ef"
    sha256 cellar: :any,                 sonoma:         "d30ef2a3176a45cbcb7e2e72a83b812b296bb01b28d8ac30861c22dcf9a16e03"
    sha256 cellar: :any,                 ventura:        "859125a35b08285676003bcb591b4c4c8f201c1fd3e29a7101861da3eceda6f0"
    sha256 cellar: :any,                 monterey:       "f6675b3a7a9d65d3f110a115137e43f5de6d35c60d9aba1a6ce1b1ed56752c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "710a77b27ffa924c1ea308bb8eb779a50562f32678843f8c8c5b8f00613b3907"
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
