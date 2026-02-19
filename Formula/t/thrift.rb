class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.22.0/thrift-0.22.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.22.0/thrift-0.22.0.tar.gz"
    sha256 "794a0e455787960d9f27ab92c38e34da27e8deeda7a5db0e59dc64a00df8a1e5"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4bb047f3d74c5a11f20e5bd50a79ad89745ae9684b5f90529ee76928af6ade36"
    sha256 cellar: :any,                 arm64_sequoia: "57789905a11fba3cc15bdf565b3ae5cb433ead8bca0cb8303f020d185b4ef642"
    sha256 cellar: :any,                 arm64_sonoma:  "cdf09a38f15d2f72ab1a9edc47a5af5e613f448c66b43d47259c5716553e3993"
    sha256 cellar: :any,                 sonoma:        "96a2cc6d24ea0a82e431f87befb21766da37630a685dcefb0274bf8c939f5c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33dca7c0cac36c3b2c72df78a56c732dfc9705750a12b504b6e98ce4d9341b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9206127d5d2652d0803c870a06daf8ca6d24b4d12676b39bad2f767c18479453"
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
