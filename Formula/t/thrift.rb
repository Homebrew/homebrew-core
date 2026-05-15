class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.23.0/thrift-0.23.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.23.0/thrift-0.23.0.tar.gz"
  sha256 "1859d932d2ae1f13d16c5a196931208c116310a5ff50f2bfd11d3db03be8f46f"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37388761423cac9f473862af5fdd46873d4eba832d9260edd419fb35a92e9cb7"
    sha256 cellar: :any,                 arm64_sequoia: "dd6ed015e1b7a980c3dfa2b0dd1c01d563a8cf73bdb7f3de87d0cc1656fc1e1b"
    sha256 cellar: :any,                 arm64_sonoma:  "f2fa00c53a8b8d8630df1fdab10ee8f3d65b3665d08bf733c493ebc2b2f815ac"
    sha256 cellar: :any,                 sonoma:        "e612d135257541b83e49f87a8ee4970db4db526aef405212e05e5887eef4a279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3e3ce909464d1ffc26af810160ecb6db3665d742b76a0924f358983767cde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30dd3f72b9f5c0dc9c73286534b24230ccd6bb6ad58cd43d235e8a79f6107c0f"
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
  depends_on "openssl@3"

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
