class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.24.0/thrift-0.24.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.24.0/thrift-0.24.0.tar.gz"
  sha256 "e0fa5839a4c5c1d631b0931cf2c554ebbfa4e2fee3a9fb3ffd4f82ce4396c6e4"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de51bdd718da379a12e5cdbaab831ae379e98b233311503a12f79d22fa468914"
    sha256 cellar: :any, arm64_sequoia: "d4d7301ccfec6227f482147ae3e7b60506f801ec240bdea2106a04e192dc4b52"
    sha256 cellar: :any, arm64_sonoma:  "a1c4c94c0268dd8066c88e3b6410a376049a99136c229842d45cc76036a34b89"
    sha256 cellar: :any, sonoma:        "88139860a06592e7b8d6fadf2f9595503a877f812a208c8d0d7664a268206857"
    sha256 cellar: :any, arm64_linux:   "338f5358b943362edc879865b481fbc864c44efa233fb2b795821ad7869253db"
    sha256 cellar: :any, x86_64_linux:  "3ccdaa58d273f59637873243322af545c11be400ebd4cd2e7ee9cb7cae700947"
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
      --with-openssl=#{formula_opt_prefix("openssl@3")}
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
