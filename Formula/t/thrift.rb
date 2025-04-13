class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.21.0/thrift-0.21.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.21.0/thrift-0.21.0.tar.gz"
    sha256 "9a24f3eba9a4ca493602226c16d8c228037db3b9291c6fc4019bfe3bd39fc67c"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eeb71b60993855c21f047fea4ce798bc758e5e7131e2e0c5c34657ac0bcc4848"
    sha256 cellar: :any,                 arm64_sonoma:  "04d15c0e6be86946302dfd384f904a0849819a47f4940ef3e00f85a73e6d0b93"
    sha256 cellar: :any,                 arm64_ventura: "93b2fe6a55f5ae205627808ffcdabb30bf33f6853af28fd13d83a218f26cac67"
    sha256 cellar: :any,                 sonoma:        "74376f8d45a9663628a53a5460b6c900a2e2c01b06a20203e0b3d008b74abac5"
    sha256 cellar: :any,                 ventura:       "cb800f4e59d0ebd83f4feda5b39400d651539707b7be074c939eb64282c044db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2811ce2e7531e40bdab091b972eefbd5c98198f3ccc63cdda280c11e1f08db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "591acbcb3495f691cc81fdd51a6b4196c2a8a40dddbe654045209e157c667632"
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
