class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

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
    sha256 cellar: :any,                 arm64_tahoe:   "42608a22cdba8bc0100f0d60f78359ea3d9a2baaec1eadf236a05f5362c9b87f"
    sha256 cellar: :any,                 arm64_sequoia: "70c48b3b34e4aa0908129c427ee8c0da57a052180692f01c6afb468cc1e1392b"
    sha256 cellar: :any,                 arm64_sonoma:  "a8bd60c98ef9c6a987391251b619506453bc60fa81f8a8d419e8732c01c540df"
    sha256 cellar: :any,                 arm64_ventura: "54a0bf02668741b09c8e3859d25cf4f3228bb3259a93aa1e82ce39c447de8946"
    sha256 cellar: :any,                 sonoma:        "f4173a0bc4fe8a05a14c8d33bdcf5e2364965f4138ee0c58b9627dad43b3ba2a"
    sha256 cellar: :any,                 ventura:       "d6d6745b54e308233d5e85e98887ffa7029785535c7861cd48cd22ccf2a6adf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2346bc45c0a02792c5dc16144571f15842fac8f95840e6c9a0d7a9de7da3859c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a0c481912313d3b116a70687b97318473645131958ce443ddba3668cd394c9"
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
