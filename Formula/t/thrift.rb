class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"
  revision 1
  compatibility_version 3

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.24.0/thrift-0.24.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.24.0/thrift-0.24.0.tar.gz"
    sha256 "e0fa5839a4c5c1d631b0931cf2c554ebbfa4e2fee3a9fb3ffd4f82ce4396c6e4"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/apache/thrift/commit/d586077a37e14446cf385893608ea9e60a59d083.patch?full_index=1"
      sha256 "701ad5a1a24283338927282ad6fb7b85a3c82f36c4eaae7842f8a2d9887b5971"
      type :backport
    end
    patch do
      url "https://github.com/apache/thrift/commit/cd199715b7da0ae036f606fe55a3b3fe8cbc4866.patch?full_index=1"
      sha256 "31c478e39294b2fff86f76fb8e428e0c8f5921d7c4f334d10619fc0233c11335"
      type :backport
    end
    patch do
      url "https://github.com/apache/thrift/commit/f51d97b68fb6c8a2c907d22b9e8189a90603ba0c.patch?full_index=1"
      sha256 "7c8a53c3111ba4a806b34005b1f2cd16a1fde34662677c41327daa160abaa2d0"
      type :backport
    end
    patch do
      url "https://github.com/apache/thrift/commit/edf0020f08599b0c62436678c3f21645201d2560.patch?full_index=1"
      sha256 "2e0b1df359a5e6418a342c9206ac3dc38064a7013460ff98739e0cb0bd4943ce"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9cf20e9b0fc582ac22978fdf11b22c933293d633e06646638cb28fac6846be1c"
    sha256 cellar: :any, arm64_tahoe:       "de51bdd718da379a12e5cdbaab831ae379e98b233311503a12f79d22fa468914"
    sha256 cellar: :any, arm64_sequoia:     "d4d7301ccfec6227f482147ae3e7b60506f801ec240bdea2106a04e192dc4b52"
    sha256 cellar: :any, arm64_sonoma:      "a1c4c94c0268dd8066c88e3b6410a376049a99136c229842d45cc76036a34b89"
    sha256 cellar: :any, sonoma:            "88139860a06592e7b8d6fadf2f9595503a877f812a208c8d0d7664a268206857"
    sha256 cellar: :any, arm64_linux:       "338f5358b943362edc879865b481fbc864c44efa233fb2b795821ad7869253db"
    sha256 cellar: :any, x86_64_linux:      "3ccdaa58d273f59637873243322af545c11be400ebd4cd2e7ee9cb7cae700947"
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
