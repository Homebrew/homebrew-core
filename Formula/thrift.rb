class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.14.2/thrift-0.14.2.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.14.2/thrift-0.14.2.tar.gz"
  sha256 "4191bfc0b7490e20cc69f9f4dc6e991fbb612d4551aa9eef1dbf7f4c47ce554d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fd86b3329477abd74446f29de5b1c3b84705390b8d878b55f3ab2a83ef6511bc"
    sha256 cellar: :any, big_sur:       "b408f5d8714788cb4d5ffa575718b78fa63233663b33d6932e3611e577a087eb"
    sha256 cellar: :any, catalina:      "16d575e5eb6ed75e1fa0951ba708762fc6dd430522330bb36a50adcf47ffa835"
    sha256 cellar: :any, mojave:        "0d8063ec5f3e3c2074749cc02826fb19331bf522d52e4439980d776c0e594392"
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
