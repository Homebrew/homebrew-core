class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com/wolfSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl.git",
      :tag      => "v3.15.7-stable",
      :revision => "a7350b7d2ed15648443253cb39ad9195df184139"
  sha256 "4e15f494604e41725499f8b708798f8ddc2fcaa8f39b4369bcd000b3cab482d8"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha256 "e3ef1ca50d091c12187f882a5f5862e43ed904484d21110e99c71c852874a3cd" => :mojave
    sha256 "8c0520a440a3a36d9b0be7a44c31864558991c83b792cc13c25dc99417ddcb79" => :high_sierra
    sha256 "2e3a0e1b48f5dae0f2d73454ebdcebd5e3e6d49c4c424f108234a2a19fe62b02" => :sierra
  end

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
      --enable-sp
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
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
