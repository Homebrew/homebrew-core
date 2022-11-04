class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.5.3-stable",
      revision: "a7635da9e64a43028d2f8f14bce75e4bed39f162"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4bf94ff0404271a6014b1582accb65a0bb4f941ec5811febaa59722cc55deb9"
    sha256 cellar: :any,                 arm64_monterey: "881f0f65a26483a0b3f42cac5303e91c4f74e9bc14c4d2a2372a4de84962263e"
    sha256 cellar: :any,                 arm64_big_sur:  "a51f6e23a48ed35f63a135f3ddffd6782200cc8c674273e237d7891889dfb746"
    sha256 cellar: :any,                 monterey:       "88ad7d7244ff90c35ddd51729593d7718939832a63f514c7d0e0c260718ce61a"
    sha256 cellar: :any,                 big_sur:        "5ac5f934d8c5f3b4aadd563ebd9cb6c74fa67e47260f54c61f03673a438559c9"
    sha256 cellar: :any,                 catalina:       "aa31fccb92e85a4edd2a890ce2dbdbd337d2b5453ac5cf9590b64c9cb5406300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180a6632efd4d1962fad7da9585411b90f383ac666cb85d8699ba20c6e563795"
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
      --enable-quic
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

    if OS.mac?
      # Extra flag is stated as a needed for the Mac platform.
      # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
      # Also, only applies if fastmath is enabled.
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

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
