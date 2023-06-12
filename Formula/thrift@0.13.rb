class ThriftAT013 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://github.com/apache/thrift/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "5da60088e60984f4f0801deeea628d193c33cec621e78c8a43a5d8c4055f7ad9"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build

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
      --without-swift
      --disable-tests
      --disable-tutorial
    ]

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV["JAVA_PREFIX"] = pkgshare/"java"

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
