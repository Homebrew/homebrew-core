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
    sha256 cellar: :any,                 arm64_sonoma:   "f3f5722adb7e5894916733b6057e0d6b0cd1e396ef25247178fffebe4f24de54"
    sha256 cellar: :any,                 arm64_ventura:  "a02e95cd80bb1449b1c5d99980eae6e523c17db8288700fca3a9c93bd2fe30f7"
    sha256 cellar: :any,                 arm64_monterey: "8a7b1552e6a8ddadbdc8503bca1491d8a9a9aee539e25eaa2b2706e77e1e1485"
    sha256 cellar: :any,                 sonoma:         "d768072f12162da9d0b6a687fd5d3acc4ee71855dfee7a54fd0e4be6d92bd785"
    sha256 cellar: :any,                 ventura:        "9bed028e5e37b2a4356a26fd119dfe5043a8fb58489c507645bb4beece5e543a"
    sha256 cellar: :any,                 monterey:       "18cd06b3f18e2a09b00ba633b00dcec16b8a94ffd45b2bd1c091e688f9bfe801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ce871f71dc0d62e530d3ff12ec1a1de7b8016f96ad7e8f8fc9e56b9aea3a45"
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
