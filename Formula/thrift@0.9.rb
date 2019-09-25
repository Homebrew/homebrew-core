class ThriftAT09 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz"
  sha256 "b0740a070ac09adde04d43e852ce4c320564a292f26521c46b78e0641564969e"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8f53901fc673714781061e6c78e74cffe4145681d9e0c54b75a6f51e9ad280d7" => :mojave
    sha256 "512e477e531ba50224ff3dd89cf5029e0bb52637d5dda62a1ace4b7051e3883d" => :high_sierra
    sha256 "fe51400fc1062beda47105f013d5d98f28dbe061897f630831a52169f5d1b59b" => :sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    args = %w[
      --without-erlang
      --without-haskell
      --without-java
      --without-perl
      --without-php
      --without-php_extension
      --without-python
      --without-ruby
      --without-tests
    ]

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV["JAVA_PREFIX"] = pkgshare/"java"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "Thrift", shell_output("#{bin}/thrift --version")
  end
end
