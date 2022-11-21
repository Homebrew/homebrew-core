class ThriftAT09 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://github.com/apache/thrift/archive/refs/tags/0.9.3.1.tar.gz"
  sha256 "1f7ca02d88a603f2845b2c7abcab74f8107dd7285056284d65241eb7965e143c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1655b3b376b29c54e7f0af8cf55d7f4eff957b03a7df5f1e44fb9e81c457e8fb"
    sha256 cellar: :any,                 arm64_monterey: "051ccc03d1ec77a43ba687fcfe8a20f8f41d8892a6260bf0b8d9cb1a36560c11"
    sha256 cellar: :any,                 arm64_big_sur:  "0b96eded35c6da92ea4fb6a2cbbc2c572838a9a7a0221161088adb77f8ccaa9f"
    sha256 cellar: :any,                 ventura:        "dd52d77c2563b04953249a32a3a4d5a7ffd7b9612a19d03f5c3fc9aa37477594"
    sha256 cellar: :any,                 monterey:       "01572a1b6a61c90cbb2e21f324fe3705c98943888915c32a78a072672ba2740c"
    sha256 cellar: :any,                 big_sur:        "0e5f46ca808e61fb8982787c04bbccedd6e17637b121dedf4a6581f5a30ea9fc"
    sha256 cellar: :any,                 catalina:       "bebef37eaa3671d2810eaaf9f06b7c6cf73ef56f83b8359de514643cd201b946"
    sha256 cellar: :any,                 mojave:         "9c4f0de40a613a30dce7b032425a66d0f5392680d6af39f9944e8982bd7d16d4"
    sha256 cellar: :any,                 high_sierra:    "a85aabc6f3c1d496f618c41e1ca367d2e8c730d9fd543f5b2a74af2760a1869a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20900326c3b385d60e26a62482fecc0c1b30b7d6c9b0b9ec81726938f73ebe7d"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build

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
      --disable-tests
      --disable-tutorial
    ]

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV["JAVA_PREFIX"] = pkgshare/"java"

    # 0.9.3.1 shipped with a syntax error...
    inreplace "configure.ac", "if test \"$have_cpp\" = \"yes\" ; then\nAC_TYPE_INT16_T",
                              "AC_TYPE_INT16_T"

    # We need to regenerate the configure script since it doesn't have all the changes.
    system "./bootstrap.sh"

    system "./configure", *std_configure_args, *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "Thrift", shell_output("#{bin}/thrift --version")
  end
end
