class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.14.2/thrift-0.14.2.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.14.2/thrift-0.14.2.tar.gz"
  sha256 "4191bfc0b7490e20cc69f9f4dc6e991fbb612d4551aa9eef1dbf7f4c47ce554d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9738721db2b89ba29c0d4d5922b4db5e2833a1042c20e082a8231d2cc0d7b781"
    sha256 cellar: :any,                 big_sur:       "8db076de8c1cb6fe950bf2150cad3742333f85c2d7f246eae6528f4da600a04f"
    sha256 cellar: :any,                 catalina:      "27776fc09fc1a434311dfebb60337205947598c31b833fe309f3046c771f08e7"
    sha256 cellar: :any,                 mojave:        "4ad50446316a8f9d35256debd51b8bf3ea1697cf43c7b8efe1e2f82922e75d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16de2437099d4e842c67cf90fe5b59a45b46c4d54dedf3743ca9339dbb6fb4f2"
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

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-erlang
      --without-haskell
      --without-java
      --without-perl
      --without-php
      --without-php_extension
      --without-python
      --without-ruby
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
