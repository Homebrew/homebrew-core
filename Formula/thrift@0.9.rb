class ThriftAT09 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://github.com/apache/thrift/archive/0.9.3.1.tar.gz"
  sha256 "1f7ca02d88a603f2845b2c7abcab74f8107dd7285056284d65241eb7965e143c"

  bottle do
    cellar :any
    rebuild 2
    sha256 "e6f84f60c56f6b40daa198244c8cecdd55de15d091dc704ec2040668645c8854" => :catalina
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
  depends_on "openssl@1.1"

  # Fix CRYPTO_num_locks compile error
  patch do
    url "https://github.com/apache/thrift/commit/4bbfe6120e71b81df7f23dcc246990c29eb27859.patch?full_index=1"
    sha256 "23b29d50cd606b88863153ec8ae1c7b3e1ef0fceca7ec59088b8135f40b99ce6"
  end

  # Fix compile when SSLv3 is disabled (OpenSSL 1.1)
  patch do
    url "https://github.com/apache/thrift/commit/b819260c653f6fd9602419ee2541060ecb930c4c.patch?full_index=1"
    sha256 "5934555674b67fb7a9fad04ffe0bd46fdbe3eca5e8f98dd072efa4bb342c9bfa"
  end

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

    # 0.9.3.1 shipped with a syntax error...
    inreplace "configure.ac", "if test \"$have_cpp\" = \"yes\" ; then\nAC_TYPE_INT16_T",
                              "AC_TYPE_INT16_T"

    # We need to regenerate the configure script since it doesn't have all the changes.
    system "./bootstrap.sh"

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
