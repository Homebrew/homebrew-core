class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.17.0/thrift-0.17.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.17.0/thrift-0.17.0.tar.gz"
    sha256 "b272c1788bb165d99521a2599b31b97fa69e5931d099015d91ae107a0b0cc58f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee3bde856db5cfd342c2383cb108c8b4d2cd93c82a99fc44d203c34fbad46804"
    sha256 cellar: :any,                 arm64_monterey: "cab37541e49c9895b900cfbec2ef67fddf240699975bdaa2eea25e5110dc31e1"
    sha256 cellar: :any,                 arm64_big_sur:  "bb496e6fe3cfdfafc3b2558af33c6008802f157efef43b12c801315c9cd4da45"
    sha256 cellar: :any,                 ventura:        "cc594cd722d68c7d7bce933eb510cbe2b819e5e7a455ad5398caf00cc236a9ed"
    sha256 cellar: :any,                 monterey:       "17406f83b600ee211014de055114ba8948ef7802dd3f0de80bb63ed0a33dfd10"
    sha256 cellar: :any,                 big_sur:        "e446d029f2856a2f9afaccabec4c469abc60330df078e89c773f42e372f9b639"
    sha256 cellar: :any,                 catalina:       "103df8d65c791c3d3430d8ccf2165e27c30dd9745164a163871333b191338c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771930b8511e07801658fc5b94f374a758a135ae4da0f2ec2b61b990137b954a"
  end

  head do
    url "https://github.com/apache/thrift.git"

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
    (testpath/"test.thrift").write <<~'EOS'
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
