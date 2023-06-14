class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.6.2-stable",
      revision: "9ffa9faecda87a7c0ce7521c83996c65d4e86943"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "622f2b50c5d5c68d5f3f41e4466035be3556a29e04c4dbc0cf1abb4a15a03b6b"
    sha256 cellar: :any,                 arm64_monterey: "f83310a16dc36e4b97d63ea3e45e6bc897ffcd7c5ce7a4e8508860399f56d95c"
    sha256 cellar: :any,                 arm64_big_sur:  "3230f93af4bba82a7a7d01f6db810e1a2fb7a562bcdf43186f694e12dfdab34a"
    sha256 cellar: :any,                 ventura:        "842ec365333b2e349a190152187522503aacff5c74cf0d63e5e4488aa4bf2924"
    sha256 cellar: :any,                 monterey:       "f40b2bce76d49636908e059254c57d1b5a4e56da77e3aec667b98430560ef403"
    sha256 cellar: :any,                 big_sur:        "c0127b85eef6d63e6828a89b19deb1dc9b94f611269aae3ab6ace4ef3b461499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8547460115d3b39dcd74a23dc890566931f2b17069c4bf41e07ff7b6a8bcdecf"
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
