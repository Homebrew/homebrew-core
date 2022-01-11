class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.1.1-stable",
      revision: "c3513bf2573c30f6d2df815de216120e92142020"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad04cefb0d479781709b210cefd26b3cf8ee8cb04d79c3f2210133b591355cc4"
    sha256 cellar: :any,                 arm64_big_sur:  "ec34ca5bb0b65f1918fcd4835d33bab5f1adcc51bce65e5f1e5420f6da92d93d"
    sha256 cellar: :any,                 monterey:       "28863258041c123401a49e8b622f49887c364ffdf6daf975e53251c3c83492fe"
    sha256 cellar: :any,                 big_sur:        "f5cb8b0ec5d8fa59ebdb2a90e61ce62615747accd074252a414ec9aa1ac96c09"
    sha256 cellar: :any,                 catalina:       "44474125af92e29c4a264a04cc91b6fc026b5a552c79d18fb9b63217a011ad64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb017bfa60e294ca0366c8b4681ab3a591c5c3e6d81253eb92987013795ca319"
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
