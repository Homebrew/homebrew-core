class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v4.8.1-stable",
      revision: "723ed009ae5dc68acc14cd7664f93503d64cd51d"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "525c3bb7de024ce851ebb2ded4b09ec85e7b4232b2396b17754dd4e09358719c"
    sha256 cellar: :any,                 arm64_big_sur:  "630d303a592f178e4af58d75c1d957b8330e1e72ffb8b815aebd059c768f2452"
    sha256 cellar: :any,                 monterey:       "a90d64e4537cb874902181fe6f7bc4f23b3c40862b4cf112b04a9bc8039b0515"
    sha256 cellar: :any,                 big_sur:        "753f16d4de6f2a439ecdf3a554608edeaa7af98b9f6e724421c786a23c64a8e7"
    sha256 cellar: :any,                 catalina:       "2cffe3c281ead906a9449ec5f85a4c1d7be09ab7a90d4c37ecac0d76f81d2428"
    sha256 cellar: :any,                 mojave:         "13dcbf8ef5cbccb7bf18aeb017e04d8a1ac116a4ec0eb3e44a842eabd91a0aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23130ec9484bdd913cd3fb7e8ec1ca6800b4f2c60d635bf5e5a0e66a98c21e2"
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
