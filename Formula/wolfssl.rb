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
    sha256 cellar: :any,                 arm64_monterey: "32eb066adb36d3571598d5e04996f1aa986fe246793021b14db8d7c482b83399"
    sha256 cellar: :any,                 arm64_big_sur:  "1a5cb2e50d0c4a090b6a6bae0f2c93b37628f268bc5fc4f41b803da55c291b4a"
    sha256 cellar: :any,                 monterey:       "e62531cfe6f1639c2bbf190f26f61666f4139219a2355d86964c7cb26f8b32bf"
    sha256 cellar: :any,                 big_sur:        "5f627ea578328854825fea3955db5d43692d207f80492e22f3db47a862cc561c"
    sha256 cellar: :any,                 catalina:       "220bcf83e70671b379700dd07892d59b585646b0ff15b5a5b609f7b9976a063b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37199e7ab1c218d6a57b2611df5e3007d9485375d7de3787c988df6d1b16a36"
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
