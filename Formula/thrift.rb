class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.16.0/thrift-0.16.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.16.0/thrift-0.16.0.tar.gz"
    sha256 "f460b5c1ca30d8918ff95ea3eb6291b3951cf518553566088f3f2be8981f6209"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "336a02980f29f8d9ba7366ea0d3122a50b6e95384593061ee533f42f8a217f06"
    sha256 cellar: :any,                 arm64_big_sur:  "78b97e148edf641a56cde92eaa218f44da8847baea8570e1acb40ebf21f2051f"
    sha256 cellar: :any,                 monterey:       "1647c15f977509a0aedfe566ab08b444c4e027c7a78b5c43c1656a57d14279ad"
    sha256 cellar: :any,                 big_sur:        "79bd37d9c191dd5396db03069bb679cab6698a34436229ee718b3ec7320cba16"
    sha256 cellar: :any,                 catalina:       "7689fdacaed0365203163376d884230cc5a19d9ebfb5c65959fb71d1c02bae9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9682093d80cd96998537979152707c57c56550a14617e3f3d0650b6d3ccde62"
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
