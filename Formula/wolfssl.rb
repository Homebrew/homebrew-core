class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com/wolfSSL/Home.html"
  head "https://github.com/wolfSSL/wolfssl.git"

  stable do
    url "https://github.com/wolfSSL/wolfssl/archive/v3.14.0-stable.tar.gz"
    version "3.14.0"
    sha256 "4ab543c869a65a77dc5d0bc934b9d4852aa3d5834bd2f707a74a936602bd3687"

    # Remove for > 3.14.0
    # Upstream commit from 6 Mar 2018 "Fix issue with the creation of dummy fips.h header."
    patch do
      url "https://github.com/wolfSSL/wolfssl/commit/a7fe5e3502.patch?full_index=1"
      sha256 "9e814ab006fd222fbf34bcec3fd214814b51fd7e765c5061c479a3ea3f29550d"
    end
  end

  bottle do
    cellar :any
    sha256 "a69bca9ea961cbc8ab86726dc5fdf5fd1c3d78782dfca1032256d3d25b995f54" => :high_sierra
    sha256 "3d975638a7ed02e35398d9ab7deb58cb9b3bbf3286f68e1cc0e9b0202b3278c9" => :sierra
    sha256 "16a11f09ba8a10157561c6254a8ea48ad603bcbde66c69057cd42142f4a64618" => :el_capitan
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
