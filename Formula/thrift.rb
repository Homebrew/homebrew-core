class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

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
    sha256 cellar: :any,                 arm64_ventura:  "066e17da8cc768ef4d7a824a91fb8109e07a3e515dc389ba587a9d13b86590de"
    sha256 cellar: :any,                 arm64_monterey: "2cea6a1b7ecfbb46a6a0dbb01fd0e3c0af390962588f6a259b9f3c1c058418bd"
    sha256 cellar: :any,                 arm64_big_sur:  "a4fcedab0b6865969910c044a1338e00930a2556ad5bb4459980ef30c7b96b38"
    sha256 cellar: :any,                 ventura:        "8399a41321ed5c4b446d8cfcfd82996730051c5264193ca1cf3aa811591a7fa8"
    sha256 cellar: :any,                 monterey:       "201a2f5ea640aeb581222eb80074f77353ee4f9232de8968343569d5289759b9"
    sha256 cellar: :any,                 big_sur:        "6c2d26ae8aefe3fd9289c3f4bee11b0d7b8cac64dd65e398594f980f609f925b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e0278c5a7fbbbd5c8fc233a40733145f7446398f0f15cf25403de70db6ae1df"
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
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
