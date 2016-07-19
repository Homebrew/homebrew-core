class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com/wolfSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl/archive/v3.9.6.tar.gz"
  sha256 "d32422ef76cec78fea6e51a96cc9e999d64be75b9c1d0f14fa9237507bed4467"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha256 "5de5f6a35b5759ae75dc32e863d62af42a38e3ed17070ff473f4d7120c61a1b7" => :el_capitan
    sha256 "f56967bb958c6f4b3a4380e8987997ff29ac624499844d37062febe39573c8d1" => :yosemite
    sha256 "190abbc96a4e0ed90f05657c60ddadb3065d6e1b2b68d688898c9e0f2a987ddc" => :mavericks
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
