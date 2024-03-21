class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.7.0-stable",
      revision: "8970ff4c34034dbb3594943d11f8c9d4c5512bd5"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d8f55a308d7572185f6344dbf477265be64fe8d385df367b9ee7ac73e52ac83"
    sha256 cellar: :any,                 arm64_ventura:  "799a87b81d6f8fd69a4d54dab3ae7e92b74981e73acb51acf0c370721d4abd95"
    sha256 cellar: :any,                 arm64_monterey: "57cdc8fb3023796d11be8f2e0feb695d57d9bf08d7ba4fa5af774ff174cb09e6"
    sha256 cellar: :any,                 sonoma:         "909c5ba5e531e87c15a04a840ac7ec44535f16ea9c3bbc89a87e352dd9bf94bf"
    sha256 cellar: :any,                 ventura:        "3924fd084afaa8b4438f585c78dbf98c78349ea354831e489493b6b66ef96147"
    sha256 cellar: :any,                 monterey:       "dc142c04a3fcb554b77db40e65461e3bc01d70b5137785d87be86fef754694b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b53c459574ef726c5c11a4bce584ac05e789766a89543a72e5d67d30ac33dad"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "util-linux" => :build

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
