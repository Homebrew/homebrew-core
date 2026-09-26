class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.25.0/thrift-0.25.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.25.0/thrift-0.25.0.tar.gz"
  sha256 "66da4707214c54c94bac082103dc67adaf9e08925662700f269170a7b534b214"
  license "Apache-2.0"
  revision 1
  compatibility_version 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d285f9dacce1246fa9faaa0c049144c5d0d31e5b80817bae14fa2d676fd4ea3"
    sha256 cellar: :any, arm64_tahoe:       "e25867b29dcbee74e54fb5c705bbcad6899b0f8f1dcde539acdd2e60f4891a74"
    sha256 cellar: :any, arm64_sequoia:     "9604c7ca5fb75e3feadcfc7082138a0ffcefefeaa86acd10504cfed594a99fc5"
    sha256 cellar: :any, arm64_linux:       "f283682e5cae69164465f3ecc6d99413cf7eede15bfaefc5866c7a22f870334c"
    sha256 cellar: :any, x86_64_linux:      "d9b178eb3bca5dc3a50b48a44836ea9517fa14fbe893cf2de348d83b3f3f3297"
  end

  head do
    url "https://github.com/apache/thrift.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  depends_on "bison" => :build
  depends_on "boost" => [:build, :test]
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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
    (testpath/"test.thrift").write <<~THRIFT
      service MultiplicationService {
        i32 multiply(1:i32 x, 2:i32 y),
      }
    THRIFT

    system bin/"thrift", "-r", "--gen", "cpp", "test.thrift"

    system ENV.cxx, "-std=c++11", "gen-cpp/MultiplicationService.cpp",
      "gen-cpp/MultiplicationService_server.skeleton.cpp",
      "-I#{include}/include",
      "-L#{lib}", "-lthrift"
  end
end
