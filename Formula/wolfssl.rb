class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.6.0-stable",
      revision: "979707380c677dfa65e3ba48f19e149773a4a32d"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5d6adad9bb984aca7e12e88af41bb99cadb3e74e5805a7e50af7a61145b0f36"
    sha256 cellar: :any,                 arm64_monterey: "70629f41e2988b2d303568653bf0d4e7f33c44119c8dd935d471c253280c15f2"
    sha256 cellar: :any,                 arm64_big_sur:  "966192b56b361b794716cc995d4fa94f115a94cb04bb286cca75e8d25b0c3555"
    sha256 cellar: :any,                 ventura:        "b8ea4838eb281b5e68334d5114563afc1226e6e20fe86eabea4db48102336be9"
    sha256 cellar: :any,                 monterey:       "a0b755c2ecc1f169b40e4d7fc627474a8e3ec65176aa41a4d050ba06949ad142"
    sha256 cellar: :any,                 big_sur:        "6d9006e9f0b140a091bd5d288bd2b64dfd14f4966cfcf5aef1f1cecd62cc6c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f146fdfeeab0e3882fb52b24049886dbe47321cc6c5ba7c7cfaa61aab1e26e"
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
