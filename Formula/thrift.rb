class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.14.0/thrift-0.14.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.14.0/thrift-0.14.0.tar.gz"
  sha256 "8dcb64f63126522e1a3fd65bf6e5839bc3d3f1e13eb514ce0c2057c9b898ff71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3eb24126da5db23fd34bfd466de7fc1ac5007aad0b733d0382024bfee13bd3ad"
    sha256 cellar: :any, big_sur:       "04f6c25fd0d50182ba07a301af0e1665a6dde9088e9b0c9021850d3371ff80cb"
    sha256 cellar: :any, catalina:      "7d38c3d24b260bbba6908132fb65a75083f8395881b56d64510972cb9edae513"
    sha256 cellar: :any, mojave:        "09f0659c65f5ef81ca8d9787ce2defb877eb324528d4841991c78adc82b09f59"
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
