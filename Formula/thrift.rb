class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.18.1/thrift-0.18.1.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.18.1/thrift-0.18.1.tar.gz"
    sha256 "04c6f10e5d788ca78e13ee2ef0d2152c7b070c0af55483d6b942e29cff296726"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "82591c3d842a3cadcb1b639204e84542de312863b61513a1dd8a72c542a96188"
    sha256 cellar: :any,                 arm64_monterey: "932ab09d7b343ebc02f0661b305d94dc69770a37b403161256f9ac4778ab5c69"
    sha256 cellar: :any,                 arm64_big_sur:  "d2f6a0b9cc82d3b72562915947fee1c6b483ffa6b87e57013c3f3438c4e33910"
    sha256 cellar: :any,                 ventura:        "ebfa59b9d51bd2558445c7bbeb3ca17255718a42ab92ddacd56b5c2dec53a689"
    sha256 cellar: :any,                 monterey:       "a7831c8263916b6046b2683e1367ca6787e2561c9ce66db090dd7517f2834201"
    sha256 cellar: :any,                 big_sur:        "20da9a6b17c787d33ecaa1e6960591f60db7afd16237d7ecc1c23bda55788704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0617a356f75b693bac1428c20c96353071ae0f1a4c7c33fab1e884c964469f"
  end

  head do
    url "https://github.com/apache/thrift.git", branch: "master"

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
    (testpath/"test.thrift").write <<~EOS
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
