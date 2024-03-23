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
    sha256 cellar: :any,                 arm64_sonoma:   "1208a14184bdbe424bc6575be0fc11ccf1e934b772e8978f46095a8603571d06"
    sha256 cellar: :any,                 arm64_ventura:  "8161ed8e8a1e3b319581b7064f2c8b4e9cfb76c51ce6b7f398a72983a0d242cd"
    sha256 cellar: :any,                 arm64_monterey: "5f6151bdc7d518220f7ae0e477ee1e4bd1b4ae0dd896e4b24f9aed31d636fbc7"
    sha256 cellar: :any,                 arm64_big_sur:  "3c1580f6ea44503a9d295234444915b68c3b684ec88249db168bfcffdb545a35"
    sha256 cellar: :any,                 sonoma:         "c87d878c8802317cdabbc7a6b8ec7521a62b5f0d56e5319ca99c9ad115f8eee4"
    sha256 cellar: :any,                 ventura:        "21dd6722482aff1bbcc82b609f64065f244c28570f22fceac0e7dd18ad07d1a2"
    sha256 cellar: :any,                 monterey:       "6fb23ee0d37cecd41b0b0b0d485dfd337b68e39a324af52909acad8c2b900d19"
    sha256 cellar: :any,                 big_sur:        "1503fc7cc61ef7e6d7d0952db04188abb8131c02d036c5cfe3f97f814fa8c43f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ed6e94d948ced7b025cd27e1dd57a1c3a091b6dc7be4c86b5fe414d72e07b2"
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
