class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.5.4-stable",
      revision: "4fbd4fd36a21efd9d1a7e17aba390e91c78693b1"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ba3020092405373dabe0e02b6a748aead33b12e19f43473a1f82e777450fa2e4"
    sha256 cellar: :any,                 arm64_monterey: "0b36a7a8da2a383088fa5552191abd47b1caec800fa740222df6e8fd660b0cd9"
    sha256 cellar: :any,                 arm64_big_sur:  "850aadd52ef6807c11adb97a186a5e08c0e8db460ccbf04bd0677be0bfa7f780"
    sha256 cellar: :any,                 ventura:        "3916e96cc70eff91a9e703a0989829e5938a27a002c5b26837bf5e87416ecbec"
    sha256 cellar: :any,                 monterey:       "af54e8129748ce0283106f427b9b4e03a9ab496e2304d16b4829fc467b3e3024"
    sha256 cellar: :any,                 big_sur:        "bd3dcbc75f9adaea69c9854861d982510f06d99a6cdc0a08770204bf7fba941a"
    sha256 cellar: :any,                 catalina:       "ec99a22963c3a3a290574a84e5af87a2a2f634ec23fe21c393b761dac41bed62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52afb0dc18ae8daa11ed9fa9f42e18c9bcbd356691e474b7b194722fb8d5177f"
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
