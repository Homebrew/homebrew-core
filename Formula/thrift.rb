class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/thrift/0.12.0/thrift-0.12.0.tar.gz"
  sha256 "c336099532b765a6815173f62df0ed897528a9d551837d627c1f87fadad90428"
  revision 1

  bottle do
    cellar :any
    sha256 "84321af08a88b55fb203083d5653cf2daf7815dbaa3093deb38af952c65e749b" => :mojave
    sha256 "51a0d9888ed9ca351ad0668632f0ec920c7509bfb9fa7bca5e0f446fbf3358a2" => :high_sierra
    sha256 "3a04020ea21057e390d0abba6e78a1396e78a0b1d415dde61acb456d3833055f" => :sierra
  end

  head do
    url "https://github.com/apache/thrift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "bison" => :build
  depends_on "boost"
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
    system "#{bin}/thrift", "--version"
  end
end
