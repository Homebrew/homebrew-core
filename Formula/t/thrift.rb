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
    sha256 cellar: :any, arm64_golden_gate: "e422a22ab3b0c6ab53ba603582a9d525680b2d108c97aab79105a8b60e69e364"
    sha256 cellar: :any, arm64_tahoe:       "5fed3e2ce1c22f05597ac1f816553ab1c5a56aacf90a6b63b43ab88dfaf94176"
    sha256 cellar: :any, arm64_sequoia:     "0b31de9285cc9bea55943b39d95f061bc1c691ad4d756ef371d3103a1c183558"
    sha256 cellar: :any, arm64_linux:       "058cfa35038ce96bb3da141594199be5134c89ecdd9fd004ead76d17515fc529"
    sha256 cellar: :any, x86_64_linux:      "47aba750ae2b682d73a52bb6c6d24c39e97db14e454f4d09a7f84db91532a54b"
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
