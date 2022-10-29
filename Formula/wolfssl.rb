class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.5.2-stable",
      revision: "0ea0b887a51771cc1668d71b9113bbc286dd4f8a"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6ffafa8d44ea8b53069ef50156f8ada3f9f66ba1033d1e1b4b68cf533c282f60"
    sha256 cellar: :any,                 arm64_monterey: "dc6be6bcea7dfa213961deb58b187d28f1e648400d5b5cbd56f24a648cda9514"
    sha256 cellar: :any,                 arm64_big_sur:  "a398cc6bd2894446137ce3d96d35706e3fe91efc86bf9de42561c53ebb933ce0"
    sha256 cellar: :any,                 monterey:       "3c16bf1740c2726ba1ebc37c4c6486a8c8313009185246132699b28f44956b9a"
    sha256 cellar: :any,                 big_sur:        "6705e954b0f3346599e81848b445ac43783a8b7ef11470a4f0daa9b73aff3ef8"
    sha256 cellar: :any,                 catalina:       "c5f342097f269c92dd897dd187bdfccc4c8c71e4fa558bf661cda2b4f5458fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "331f0437e03389373b90b719eb370dfe95cf226b354cc2f2530bc94646062daa"
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
