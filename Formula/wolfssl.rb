class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.6.3-stable",
      revision: "3b3c175af0e993ffaae251871421e206cc41963f"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1d6a49c07a15973365becf2cfef4afc7b03d9b88d51a6fa878fc28b5201f37c"
    sha256 cellar: :any,                 arm64_monterey: "db15ca1ae6d3d4c14c3363ba48c51d38090ef0c974d30e4d478db4992ed0d58d"
    sha256 cellar: :any,                 arm64_big_sur:  "726a2d1711346d381d22f7d5b30ccc2ee5eed8fa5d05cda12f7cfd362bdc219f"
    sha256 cellar: :any,                 ventura:        "077b1f2430cd52f70312929ce546d7a821e50d6bd0eeb7df00717005569241b7"
    sha256 cellar: :any,                 monterey:       "108d4d33023d05aeb0bbfbaed29ecedd2a4ee6dd3ec400da0fa904efeba9fd2a"
    sha256 cellar: :any,                 big_sur:        "9bd9d570c8c20607547d2a09e847c744505173f8fa7bfdd58f800cbf5bd4cc41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff70d7c64c02deb614da42290f6b785ab1ff6affb723e9c71506b918f2ce9da"
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
