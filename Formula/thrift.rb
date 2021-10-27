class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=thrift/0.15.0/thrift-0.15.0.tar.gz"
    mirror "https://archive.apache.org/dist/thrift/0.15.0/thrift-0.15.0.tar.gz"
    sha256 "d5883566d161f8f6ddd4e21f3a9e3e6b8272799d054820f1c25b11e86718f86b"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77ea98789bcafe47df87460c0b236c2a4d0883d3a87f189de5fa228f14b920d1"
    sha256 cellar: :any,                 arm64_big_sur:  "8352c16aaef3267d863dc31aa6e6562ab59ce5823b61296a0a2dfe62fb747112"
    sha256 cellar: :any,                 monterey:       "8fafe39b9a14df03183aadb76da3d2005972de99f9ef99820a760e71bf131f8b"
    sha256 cellar: :any,                 big_sur:        "e371159616481c100f45d01660e70ff68d9df907baef025982e8650ff485b3f4"
    sha256 cellar: :any,                 catalina:       "77ffd9f8aea765983f90ae45c94afd32502d035bb09f58b601290f65fc2966e0"
    sha256 cellar: :any,                 mojave:         "e1f46a93099ec7b01caf380433a05d5014686cc5ea59293286fc55a5b0efd39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1ac943dc0f963402b71ce1189f19e62aa51510165c4f3607dc45b6b95f273f"
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
