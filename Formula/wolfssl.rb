class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com/wolfSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl/archive/v3.15.3-stable.tar.gz"
  version "3.15.3"
  sha256 "2b98d9ddac2a3188210de720051bed58f91910ee028a4b0a6dd6fd3c9ddb6fec"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha256 "b67f341e8bd3fac6564a569d6bdf2e6b73addd505710c180d5dcb9653704ef93" => :mojave
    sha256 "7238f8d6ee25019ca14b6d7ad0b7ff640c4417ed80915380194b8e6a10042590" => :high_sierra
    sha256 "5592c1ac094abe44a735cd678d1f67f1c0883a3294495ac6958b5c43c6b770a5" => :sierra
    sha256 "f01b977e6e6a6c64468d11251045ff03abf01a4daf5db45757afeeeb1a7a7d4e" => :el_capitan
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-alpn
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-curve25519
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ed25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-ipv6
      --enable-jni
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-rabbit
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
      --enable-tls13
    ]

    if MacOS.prefer_64_bit?
      args << "--enable-fastmath" << "--enable-fasthugemath"
    else
      args << "--disable-fastmath" << "--disable-fasthugemath"
    end

    args << "--enable-aesni" if Hardware::CPU.aes? && !build.bottle?

    # Extra flag is stated as a needed for the Mac platform.
    # https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if MacOS.prefer_64_bit?

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
