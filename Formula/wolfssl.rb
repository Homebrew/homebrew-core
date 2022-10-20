class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.5.1-stable",
      revision: "f1e2165c591f074feb47872a8ff712713ec411e1"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d58ece55f910b429a31687cba72757f437bcb99a55a520043977cc3d36b6cb20"
    sha256 cellar: :any,                 arm64_big_sur:  "2139c747398b2c05dab02eb5f96f29c5c086487a3929f759674c57bf42be32fe"
    sha256 cellar: :any,                 monterey:       "967f55dde5a99e53c796b09b3a77c0e45362a9b992531b56e4e60744712b9549"
    sha256 cellar: :any,                 big_sur:        "9776785ec4381ece723d5c2f252d7b05c8612e8f602513e0852257e3166e002c"
    sha256 cellar: :any,                 catalina:       "3b76ba018498f8d81f226d4bfad17307c3f29035694cd775b2ad6c0bc1b6f5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f1df8a292ed260dbf4ccdb81dbd1ea7bbf95f421a574c18a89e71301e1e56c"
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
