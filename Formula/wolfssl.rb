class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      :tag      => "v4.4.0-stable",
      :revision => "e116c89a58af750421d82ece13f80516d2bde02e"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha256 "640adc750bb5f9bbb83c4750255a8451f3800911feb29f4b40bc9c05d6496a87" => :catalina
    sha256 "45cb9c47a12a04ba87b263063b0c9d5ef41df63c23b9e0c2c71fefdc6419ce67" => :mojave
    sha256 "d517858cb06ac4acfb74cf89957a51f3bfc80ffa49eba97406e81b7030f3190e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
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
      --enable-fastmath
      --enable-fasthugemath
    ]

    # Extra flag is stated as a needed for the Mac platform.
    # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic"

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
